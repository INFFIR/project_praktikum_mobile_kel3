// app/controllers/data_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/services/firestore_service.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/services/connectivity_service.dart';

class DataController extends GetxController {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final ConnectivityService _connectivityService = Get.find<ConnectivityService>();

  @override
  void onInit() {
    super.onInit();
    // Mendengarkan perubahan konektivitas
    ever(_connectivityService.isConnected, (bool isConnected) {
      if (isConnected) {
        // Koneksi kembali tersedia, kirim data yang belum terkirim
        _firestoreService.sendPendingData('your_collection');
      }
    });
  }

  /// Fungsi untuk menambahkan data
  Future<void> addData(Map<String, dynamic> data) async {
    try {
      await _firestoreService.addDataWithRetry('your_collection', data);
      Get.snackbar(
        'Sukses',
        'Data berhasil ditambahkan ke Firestore',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
