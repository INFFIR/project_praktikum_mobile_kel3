import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  // Implement Firebase Authentication login
  Future<bool> login() async {
  try {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Firebase Authentication sign-in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Dapatkan informasi pengguna setelah login berhasil
      User? user = userCredential.user;
      if (user != null) {
        print('Logged in user: ${user.email} with UID: ${user.uid}');
      }

      // Login successful
      return true;
    }
  } on FirebaseAuthException catch (e) {
    // Handle Firebase Authentication errors
    if (e.code == 'user-not-found') {
      Get.snackbar('Error', 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      Get.snackbar('Error', 'Wrong password provided.');
    }
  }
  return false;
}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
