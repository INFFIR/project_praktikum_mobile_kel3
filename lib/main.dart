import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/notification/notification_controller.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/welcome/view/welcome_page.dart';
import './app/routes/app_pages.dart'; // Pastikan path ini sesuai dengan struktur folder Anda

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase
  Get.put(NotificationController()); // Register NotificationController
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
      home: const WelcomePage(),
    );
  }
}
