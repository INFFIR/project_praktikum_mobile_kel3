import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart'; // Tambahkan untuk membuka URL

class ProfileController extends GetxController {
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var currentAddress = ''.obs;

  // Controllers untuk username, email, password, dan alamat
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController =
      TextEditingController(); // Controller untuk alamat manual

  // State observables
  RxString imagePath = ''.obs; // Path gambar profil
  RxBool isImageLoading = false.obs; // Loading state untuk memilih gambar
  RxBool isLoading = false.obs; // Loading state untuk update profil
  Rx<LatLng> currentPosition =
      const LatLng(0, 0).obs; // Menyimpan lokasi koordinat

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // Fungsi untuk load data user dari GetStorage
  void loadUserData() {
    try {
      usernameController.text = box.read('username') ?? '';
      emailController.text = box.read('userEmail') ?? '';
      imagePath.value = box.read('profileImagePath') ?? '';
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data profil');
      print('Error loading user data: $e');
    }
  }

  // Fungsi untuk memilih gambar
  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
        await saveProfileImage();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar');
      print('Error picking image: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  // Simpan gambar profil ke GetStorage
  Future<void> saveProfileImage() async {
    try {
      await box.write('profileImagePath', imagePath.value);
      Get.snackbar('Success', 'Gambar profil berhasil disimpan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan gambar profil');
      print('Error saving profile image: $e');
    }
  }

  // Fungsi untuk memperbarui data profil
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      await box.write('username', usernameController.text);
      await box.write('userEmail', emailController.text);

      if (passwordController.text.isNotEmpty) {
        await box.write('userPassword', passwordController.text);
      }

      // Update alamat yang ada di addressController
      await saveAddressToFirebase(addressController.text);

      Get.snackbar('Success', 'Profil berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil');
      print('Error updating profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    try {
      await box.erase();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout');
      print('Error during logout: $e');
    }
  }

  // Fungsi untuk mengambil lokasi saat ini dan mengonversinya menjadi alamat
  Future<void> fetchCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Aktifkan layanan lokasi');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Izin lokasi ditolak');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Izin lokasi ditolak secara permanen');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentAddress.value =
          'Lat: ${position.latitude}, Long: ${position.longitude}';

      // Simpan alamat ke Firebase
      await saveAddressToFirebase(currentAddress.value);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil lokasi');
      print('Error fetching location: $e');
    }
  }

  // Fungsi untuk membuka Google Maps
  void openGoogleMaps() async {
    if (addressController.text.isNotEmpty) {
      // Jika alamat dimasukkan manual, buka Google Maps
      String googleUrl =
          "https://www.google.com/maps?q=${addressController.text}";
      if (await canLaunch(googleUrl)) {
        await launchUrl(Uri.parse(googleUrl));
      } else {
        Get.snackbar('Error', 'Google Maps tidak dapat dibuka');
      }
    } else if (currentAddress.value.isNotEmpty) {
      // Jika lokasi GPS tersedia, buka berdasarkan koordinat
      var latLng = currentAddress.value.split(", ");
      if (latLng.length == 2) {
        double latitude =
            double.tryParse(latLng[0].replaceAll('Lat: ', '')) ?? 0.0;
        double longitude =
            double.tryParse(latLng[1].replaceAll('Long: ', '')) ?? 0.0;
        String googleUrl = "https://www.google.com/maps?q=$latitude,$longitude";
        if (await canLaunch(googleUrl)) {
          await launchUrl(Uri.parse(googleUrl));
        } else {
          Get.snackbar('Error', 'Google Maps tidak dapat dibuka');
        }
      }
    }
  }

// Add this function to your ProfileController
  Future<void> updateManualAddress(String newAddress) async {
    try {
      // Set the new address to the currentAddress observable
      currentAddress.value = newAddress;

      // Optionally, update the address in Firebase if needed
      await saveAddressToFirebase(newAddress);

      Get.snackbar('Success', 'Alamat berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui alamat');
      print('Error updating address: $e');
    }
  }

  // Simpan alamat ke Firebase
  Future<void> saveAddressToFirebase(String address) async {
    try {
      final uid = box.read('uid'); // Ambil UID user dari storage
      if (uid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'address': address});
        Get.snackbar('Success', 'Alamat berhasil diperbarui');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan alamat');
      print('Error saving address: $e');
    }
  }
}
