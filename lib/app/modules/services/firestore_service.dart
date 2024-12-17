// app/modules/services/firestore_service.dart

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();

  /// Menambahkan data dengan mekanisme retry menggunakan exponential backoff
  Future<void> addDataWithRetry(String collection, Map<String, dynamic> data) async {
    int retryCount = 0;
    const int maxRetries = 5;
    const Duration initialDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        await _firestore.collection(collection).add(data);
        print('Data berhasil disimpan ke Firestore');
        return; // Keluar dari fungsi jika berhasil
      } catch (e) {
        if (e is FirebaseException && e.code == 'unavailable') {
          retryCount++;
          final delay = initialDelay * pow(2, retryCount);
          print('Firestore unavailable, retrying in ${delay.inSeconds} seconds...');
          await Future.delayed(delay);
        } else {
          // Tangani error lain atau rethrow
          print('Terjadi error: $e');
          rethrow;
        }
      }
    }

    print('Gagal menyimpan data ke Firestore setelah $maxRetries percobaan');
    // Simpan data ke local storage sebagai pending
    await _savePendingData(collection, data);
    throw Exception('Gagal menyimpan data ke Firestore setelah $maxRetries percobaan');
  }

  /// Menyimpan data ke local storage sebagai pending
  Future<void> _savePendingData(String collection, Map<String, dynamic> data) async {
    List<Map<String, dynamic>> pendingData = _storage.read<List<dynamic>>('pending_$collection')?.cast<Map<String, dynamic>>() ?? [];
    pendingData.add(data);
    await _storage.write('pending_$collection', pendingData);
    print('Data disimpan secara lokal untuk sinkronisasi nanti');
  }

  /// Mengirim data yang belum terkirim
  Future<void> sendPendingData(String collection) async {
    List<dynamic> pendingData = _storage.read<List<dynamic>>('pending_$collection') ?? [];

    for (var data in pendingData) {
      try {
        await _firestore.collection(collection).add(Map<String, dynamic>.from(data));
        print('Data pending berhasil disinkronkan ke Firestore');
      } catch (e) {
        print('Gagal menyinkronkan data pending: $e');
        // Jika masih gagal, hentikan proses sinkronisasi
        return;
      }
    }

    // Jika semua data berhasil disinkronkan, hapus dari local storage
    await _storage.remove('pending_$collection');
    print('Semua data pending telah disinkronkan dan dihapus dari local storage');
  }

  /// Menambahkan data tanpa mekanisme retry (opsional)
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      print('Data berhasil ditambahkan ke Firestore');
    } catch (e) {
      print('Gagal menambahkan data: $e');
      rethrow;
    }
  }
}
