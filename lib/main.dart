// main.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart'; // Untuk GetStorage
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk Firestore
import 'package:project_praktikum_mobile_kel3/app/modules/services/connectivity_service.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/services/firestore_service.dart'; // Import FirestoreService
import 'app/modules/audio_manager/audio_manager.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/services/notification_service.dart';
import 'dart:io' show Platform;

/// Handler untuk pesan background FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Menangani pesan background: ${message.messageId}');
  // Simpan notifikasi ke Firestore jika diperlukan
}

/// Fungsi untuk menginisialisasi pengaturan Firestore
Future<void> initializeFirestoreSettings() async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  if (Platform.isAndroid || Platform.isIOS) {
    // Mengatur pengaturan Firestore untuk Android dan iOS
    db.settings = Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    print('Persistensi Firestore diaktifkan untuk Android/iOS');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp();

  // Inisialisasi Firestore dengan pengaturan untuk Android/iOS
  await initializeFirestoreSettings();

  // Inisialisasi GetStorage
  await GetStorage.init();

  // Daftarkan ConnectivityService dan FirestoreService menggunakan Get.lazyPut()
  Get.lazyPut<ConnectivityService>(() => ConnectivityService());
  Get.lazyPut<FirestoreService>(() => FirestoreService());

  // Mengatur handler untuk pesan background FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Inisialisasi NotificationService
  if (!Get.isRegistered<NotificationService>()) {
    await Get.putAsync<NotificationService>(() async {
      final notificationService = NotificationService();
      await notificationService.init();
      return notificationService;
    });
  }

  // Inisialisasi AudioManager sebagai singleton
  if (!Get.isRegistered<AudioManager>()) {
    Get.put<AudioManager>(AudioManager(), permanent: true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vape Store',
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const WelcomePage(), // Sudah ditentukan di initialRoute
    );
  }
}
