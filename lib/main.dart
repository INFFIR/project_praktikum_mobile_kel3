// main.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/modules/audio_manager/audio_manager.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/services/notification_service.dart';

/// Handler untuk pesan background FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Menangani pesan background: ${message.messageId}');
  // Simpan notifikasi ke Firestore jika diperlukan
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
