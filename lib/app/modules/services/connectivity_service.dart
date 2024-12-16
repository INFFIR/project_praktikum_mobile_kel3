// lib/services/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import '../product/controllers/product_controller.dart';
import '../product/controllers/promo_controller.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription; // Perbaikan tipe
  final GetStorage _storage = GetStorage();

  // Observable connection status
  var isConnected = true.obs;

  Future<void> initialize() async {
    try {
      // Check initial connectivity status
      ConnectivityResult initialResult = (await _connectivity.checkConnectivity()) as ConnectivityResult;
      _updateConnectionStatus(initialResult, initial: true);

      // Listen for connectivity changes
      _subscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        _updateConnectionStatus(result);
      } as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;
    } catch (e) {
      // Handle potential errors, such as missing permissions
      print('Error initializing connectivity: $e');
      isConnected.value = false;
    }
  }

  void _updateConnectionStatus(ConnectivityResult result, {bool initial = false}) {
    bool previousStatus = isConnected.value;

    // Jika status tidak none, dianggap terhubung
    bool isConnectedNow = result != ConnectivityResult.none;

    if (!isConnectedNow) {
      isConnected.value = false;
      if (!initial) {
        Get.snackbar(
          'No Internet',
          'Anda sedang offline.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,
        );
      }
    } else {
      isConnected.value = true;
      if (!previousStatus) {
        // Tampilkan snackbar hanya saat koneksi dipulihkan
        Get.snackbar(
          'Internet Connected',
          'Koneksi internet kembali.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.5),
          colorText: Colors.white,
        );
        // Upload pending local data
        _uploadPendingData();
      }
    }
  }

  Future<void> _uploadPendingData() async {
    try {
      // Pastikan controller sudah diinisialisasi dan tersedia
      if (Get.isRegistered<ProductController>()) {
        final productController = Get.find<ProductController>();
        await productController.uploadPendingProducts();
      }
      if (Get.isRegistered<PromoController>()) {
        final promoController = Get.find<PromoController>();
        await promoController.uploadPendingPromos();
      }
    } catch (e) {
      // Handle errors, seperti controller tidak ditemukan
      print('Error uploading pending data: $e');
    }
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
