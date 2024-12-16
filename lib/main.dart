// main.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'app/modules/audio_manager/audio_manager.dart';
import 'app/modules/product/controllers/product_controller.dart';
import 'app/modules/product/controllers/promo_controller.dart';
import 'app/modules/services/connectivity_service.dart';
import 'app/modules/services/notification_service.dart';
import 'app/routes/app_pages.dart';

/// Handler for background FCM messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize GetStorage
  await GetStorage.init();
  // Get.put<ProductController>(ProductController());
  // Get.put<PromoController>(PromoController()); 

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize ConnectivityService asynchronously
  if (!Get.isRegistered<ConnectivityService>()) {
    await Get.putAsync<ConnectivityService>(() async {
      final connectivityService = ConnectivityService();
      await connectivityService.initialize(); 
      return connectivityService;
    });
  }

  // Initialize NotificationService asynchronously
  if (!Get.isRegistered<NotificationService>()) {
    await Get.putAsync<NotificationService>(() async {
      final notificationService = NotificationService();
      await notificationService.init(); 
      return notificationService;
    });
  }

  // Initialize AudioManager as a singleton
  if (!Get.isRegistered<AudioManager>()) {
    Get.put<AudioManager>(AudioManager(), permanent: true);
  }

  // Run the app
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
    );
  }
}
