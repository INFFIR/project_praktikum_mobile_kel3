import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    syncLocalData(); // Sinkronisasi data saat aplikasi dibuka
  }

  // Fungsi untuk login
  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Cek koneksi internet
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Simpan data lokal jika tidak ada koneksi
      await saveToLocalStorage(email, password);
      return false; // Login gagal karena tidak ada koneksi
    } else {
      // Jika ada koneksi, lanjutkan proses login
      return await processLogin(email, password);
    }
  }

  // Simpan data ke GetStorage
  Future<void> saveToLocalStorage(String email, String password) async {
    storage.write('pending_login', {
      'email': email,
      'password': password,
    });
    Get.snackbar(
      'Offline Mode',
      'Your login data has been saved locally. It will be synced when you are online.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Proses login menggunakan Firebase Authentication
  Future<bool> processLogin(String email, String password) async {
    try {
      // Login menggunakan Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Dapatkan informasi pengguna
      User? user = userCredential.user;
      if (user != null) {
        print('Logged in user: ${user.email} with UID: ${user.uid}');
      }

      // Simpan data login ke Firestore
      await FirebaseFirestore.instance.collection('users').add({
        'email': email,
        'uid': user!.uid,
        'timestamp': DateTime.now().toIso8601String(),
      });

      return true; // Login berhasil
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided.');
      } else {
        Get.snackbar('Error', 'Failed to login: ${e.message}');
      }
      return false; // Login gagal
    }
  }

  // Sinkronisasi data lokal ke Firebase
  Future<void> syncLocalData() async {
    final pendingLogin = storage.read('pending_login');
    if (pendingLogin != null) {
      final email = pendingLogin['email'];
      final password = pendingLogin['password'];
      final success = await processLogin(email, password);
      if (success) {
        // Hapus data lokal setelah sinkronisasi berhasil
        storage.remove('pending_login');
        Get.snackbar(
          'Sync Success',
          'Your offline data has been synced to the server.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
