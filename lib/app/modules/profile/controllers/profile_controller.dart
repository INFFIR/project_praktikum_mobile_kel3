import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart'; // Tambahkan untuk membuka URL
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfileController extends GetxController {
  final box = GetStorage();
  final ImagePicker _picker = ImagePicker();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var currentAddress = ''.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Menambahkan FirebaseAuth

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
    // Mulai pengecekan sinkronisasi data secara periodik
    Timer.periodic(Duration(seconds: 10), (timer) {
      syncPendingData(); // Cek dan sinkronkan data jika perlu
    });

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

  Future<bool> isOnline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
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

  void syncPendingData() async {
    try {
      bool online = await isOnline(); // Mengecek koneksi internet
      if (online) {
        bool? pendingUpdate = box.read('pendingProfileUpdate');
        if (pendingUpdate == true) {
          // Lakukan sinkronisasi data ke Firebase
          await saveAddressToFirebase(addressController.text);

          // Setel ulang tanda pembaruan di local storage
          await box.remove('pendingProfileUpdate');
          Get.snackbar('Info', 'Data berhasil disinkronkan dengan Firebase');
        }
      }
    } catch (e) {
      print('Error syncing data: $e');
    }
  }

// Fungsi untuk memuat data profil berdasarkan UID
  Future<void> loadProfileData() async {
    try {
      final uid = box.read('uid'); // Ambil UID user dari storage
      if (uid != null) {
        // Ambil data pengguna dari Firestore berdasarkan UID
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (userDoc.exists) {
          // Menampilkan data pengguna
          usernameController.text = userDoc['username'] ?? '';
          emailController.text = userDoc['email'] ?? '';
          addressController.text = userDoc['address'] ?? '';
        } else {
          Get.snackbar('Error', 'User data not found');
        }
      } else {
        Get.snackbar('Error', 'UID not found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
      print('Error loading profile data: $e');
    }
  }

  // Fungsi untuk memperbarui data profil
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      // Simpan data ke local storage
      await box.write('username', usernameController.text);
      await box.write('userEmail', emailController.text);

      if (passwordController.text.isNotEmpty) {
        await box.write('userPassword', passwordController.text);
      }

      // Cek apakah ada koneksi internet
      bool online = await isOnline();

      if (online) {
        // Jika ada koneksi, update ke Firebase
        await saveAddressToFirebase(addressController.text);
        Get.snackbar('Success', 'Profil berhasil diperbarui');
      } else {
        // Jika tidak ada koneksi, simpan data di local storage dan antri untuk sinkronisasi nanti
        await box.write('pendingProfileUpdate', true); // Tandai ada pembaruan
        Get.snackbar('Info', 'Tidak ada koneksi, data disimpan sementara');
      }
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
      await _auth.signOut(); // Menggunakan FirebaseAuth untuk sign out
      Get.offAllNamed('/welcome'); // Arahkan ke halaman welcome setelah logout
      await box.erase(); // Hapus data dari GetStorage
      Get.offAllNamed('/login'); // Arahkan ke halaman login
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

      // Simpan alamat ke Firebase
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
        // Simpan data ke Firestore berdasarkan UID
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'address': address, // Menyimpan alamat
          'username': usernameController.text, // Menyimpan username
        });
        Get.snackbar('Success', 'Alamat dan username berhasil diperbarui');
      } else {
        Get.snackbar('Error', 'UID pengguna tidak ditemukan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan alamat dan username');
      print('Error saving address and username: $e');
    }
  }
}
