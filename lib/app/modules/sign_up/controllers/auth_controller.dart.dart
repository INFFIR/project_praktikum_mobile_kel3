import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

import '../../connection/controllers/connection_controller.dart'; // Import GetStorage

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GetStorage _storageBox =
      GetStorage(); // Menggunakan GetStorage untuk penyimpanan lokal

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final addressController = TextEditingController();

  Rx<File?> profileImage = Rx<File?>(null);

  // Method untuk mengambil foto dari galeri
  Future<void> pickProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // Method untuk registrasi
  Future<void> register() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Email and password cannot be empty");
      return;
    }

    // Mengecek status koneksi sebelum mencoba mendaftar
    if (!Get.find<ConnectionController>().isConnected.value) {
      _saveDataLocally(); // Menyimpan data ke lokal
      return; // Menghentikan proses registrasi jika tidak ada koneksi
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;
      String? profileImageUrl;

      if (profileImage.value != null) {
        profileImageUrl = await _uploadProfileImage(uid, profileImage.value!);
      }

      await _firestore.collection('users').doc(uid).set({
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'address': addressController.text.trim(),
        'profileImageUrl': profileImageUrl,
        'createdAt': Timestamp.now(),
      });

      Get.snackbar("Success", "Account created successfully");

      emailController.clear();
      passwordController.clear();
      usernameController.clear();
      addressController.clear();
      profileImage.value = null;

      Get.offAllNamed('/home');
    } catch (e) {
      String errorMessage = 'An error occurred';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }
      Get.snackbar("Error", errorMessage);
    }
  }

  // Fungsi untuk mengupload foto profil ke Firebase Storage
  Future<String> _uploadProfileImage(String uid, File imageFile) async {
    try {
      Reference ref = _storage.ref().child('profile_images').child('$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      Get.snackbar("Error", "Failed to upload profile image");
      rethrow;
    }
  }

  // Menyimpan data sementara ke GetStorage ketika koneksi terputus
  void _saveDataLocally() {
    final userData = {
      'username': usernameController.text.trim(),
      'email': emailController.text.trim(),
      'address': addressController.text.trim(),
      'profileImage': profileImage.value?.path,
    };
    _storageBox.write('userData', userData);
    Get.snackbar(
      "No Internet Connection",
      "Data saved locally. Will upload when connection is restored.",
    );
  }

  // Menyelesaikan upload data dari penyimpanan lokal saat koneksi tersedia
  Future<void> uploadDataLocally() async {
    var savedData = _storageBox.read('userData');
    if (savedData != null) {
      try {
        String uid = savedData['email']; // Assuming email is unique
        String? profileImageUrl;

        if (savedData['profileImage'] != null) {
          File imageFile = File(savedData['profileImage']);
          profileImageUrl = await _uploadProfileImage(uid, imageFile);
        }

        await _firestore.collection('users').doc(uid).set({
          'username': savedData['username'],
          'email': savedData['email'],
          'address': savedData['address'],
          'profileImageUrl': profileImageUrl,
          'createdAt': Timestamp.now(),
        });

        // Setelah berhasil upload, hapus data lokal
        _storageBox.remove('userData');
        Get.snackbar("Success", "Data uploaded successfully");
      } catch (e) {
        Get.snackbar("Error", "Failed to upload local data");
      }
    }
  }
}


