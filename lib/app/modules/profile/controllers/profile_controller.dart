// profile_controller.dart
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Rx<File?> imageFile = Rx<File?>(null);
  RxString imageUrl = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final user = _auth.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';
      // Load profile picture if exists
      _loadProfilePicture(user.uid);
    }
  }

  Future<void> _loadProfilePicture(String uid) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$uid');
      imageUrl.value = await ref.getDownloadURL();
    } catch (e) {
      print('No profile picture found');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      await uploadProfilePicture();
    }
  }

  Future<void> uploadProfilePicture() async {
    if (imageFile.value == null) return;

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      final ref = _storage.ref().child('profile_pictures/${user.uid}');
      await ref.putFile(imageFile.value!);
      imageUrl.value = await ref.getDownloadURL();

      Get.snackbar(
        'Success',
        'Profile picture updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile picture',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      if (passwordController.text.isNotEmpty) {
        await user.updatePassword(passwordController.text);
      }

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login'); // Navigate to login page
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
