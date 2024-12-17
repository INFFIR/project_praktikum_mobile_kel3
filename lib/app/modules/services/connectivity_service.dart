import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  RxBool isConnected = true.obs;
  bool wasOffline = false;  // Flag untuk melacak apakah sebelumnya offline

  @override
void onInit() {
  super.onInit();
  _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
        isConnected.value = false;
        wasOffline = true;  // Tandai bahwa kita sebelumnya offline
        _showOfflineSnackBar();
      } else {
        isConnected.value = true;
        if (wasOffline) {
          _showOnlineSnackBar();  // Tampilkan snackbar online hanya setelah sebelumnya offline
          wasOffline = false;  // Reset flag setelah online
        }
      }
    });

    // Deteksi perubahan halaman dan tampilkan snackbar jika offline
    ever(isConnected, (_) {
      if (!isConnected.value) {
        _showOfflineSnackBar();
      }
    });
  }

  // Tampilkan Snackbar untuk pemberitahuan Offline
  void _showOfflineSnackBar() {
    if (!isConnected.value) {
      // Tampilkan snackbar permanen saat offline
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Offline', 
          'Anda sedang offline!', 
          backgroundColor: Colors.red, 
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(days: 365),  // Membuat snackbar tetap muncul
        );
      }
    }
  }

  // Tampilkan Snackbar untuk pemberitahuan Online
  void _showOnlineSnackBar() {
    if (isConnected.value) {
      // Hapus Snackbar offline dan tampilkan yang Online
      if (Get.isSnackbarOpen) {
        Get.back();  // Menutup snackbar yang sedang terbuka
      }
      Get.snackbar(
        'Kembali Online', 
        'Anda sekarang terhubung ke internet!', 
        backgroundColor: Colors.green, 
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),  // Snackbar Online muncul sebentar
      );
    }
  }

  // Cek status koneksi saat ini
  Future<bool> checkConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}