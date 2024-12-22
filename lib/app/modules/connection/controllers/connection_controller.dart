import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../sign_up/controllers/auth_controller.dart.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool isConnected = true.obs;

  final AuthController authController =
      Get.find<AuthController>(); // Mengambil instance AuthController

  @override
  void onInit() {
    super.onInit();
    print("Listening to connectivity changes...");
    _checkInitialConnectivity(); // Cek status koneksi saat aplikasi dimulai
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> statusList) {
      // Kita menerima List<ConnectivityResult>, maka iterasi pada list atau gunakan data pertama
      if (statusList.isNotEmpty) {
        _updateConnectionStatus(
            statusList.first); // Ambil status pertama dari list
      }
    });
  }

  /// Mengecek koneksi saat aplikasi pertama kali dijalankan
  void _checkInitialConnectivity() async {
    try {
      var initialStatus = await _connectivity.checkConnectivity();
      _updateConnectionStatus(initialStatus as ConnectivityResult);
    } catch (e) {
      print("Error checking initial connectivity: $e");
    }
  }

  /// Memperbarui status koneksi berdasarkan hasil dari ConnectivityResult
  void _updateConnectionStatus(ConnectivityResult status) {
    if (status == ConnectivityResult.none) {
      print("No internet connection detected.");
      isConnected.value = false;
      Get.snackbar(
        "No Internet Connection",
        "Please check your connection",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      print("Internet connection detected.");
      isConnected.value = true;
      // Jika koneksi kembali, upload data yang tersimpan lokal
      authController.uploadDataLocally();
    }
  }
}

