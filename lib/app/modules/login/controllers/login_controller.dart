import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Initialize controllers for email and password input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Additional initialization if needed
  }

  // Simulate a login process
  Future<bool> login() async {
    // Check if the input fields are not empty
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Logika login di sini (misalnya panggilan API)
      print('Email: ${emailController.text}');
      print('Password: ${passwordController.text}');

      // Simulasi sukses login (anda bisa mengganti ini dengan logika autentikasi nyata)
      await Future.delayed(const Duration(seconds: 2)); // Simulate a network call

      // Assume login is successful for this example
      return true; 
    }
    // Return false if login fails
    return false;
  }

  @override
  void onClose() {
    // Clean up controllers when the widget is removed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
