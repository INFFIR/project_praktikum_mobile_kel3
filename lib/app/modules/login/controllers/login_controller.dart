import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
  }

  // Implement Firebase Authentication login
  Future<bool> login() async {
    try {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          print('Logged in user: ${user.email} with UID: ${user.uid}');
          return true; // Login successful
        }
      } else {
        Get.snackbar('Error', 'Email and password cannot be empty.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided.');
      } else {
        Get.snackbar('Error', 'Login failed: ${e.message}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
    }
    return false; // Login failed
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
