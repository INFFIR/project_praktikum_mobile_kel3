// lib/app/bindings/welcome_binding.dart
import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    // Menggunakan put untuk memastikan hanya satu instance WelcomeController
    Get.put<WelcomeController>(WelcomeController());
  }
}
