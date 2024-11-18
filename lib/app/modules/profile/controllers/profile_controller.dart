import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  // Load user data from Firebase Auth and Firestore
  void loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      emailController.text = user.email ?? '';

      try {
        // Load additional profile data from Firestore
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          usernameController.text = userDoc['username'] ?? '';
          imageUrl.value = userDoc['profileImageUrl'] ?? '';
        }

        // Load profile picture if the URL exists
        if (imageUrl.value.isEmpty) {
          await _loadProfilePicture(user.uid);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to load profile data');
        print('Error loading profile data: $e');
      }
    } else {
      Get.snackbar('Error', 'User not logged in');
    }
  }

  // Load profile picture URL from Firebase Storage
  Future<void> _loadProfilePicture(String uid) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$uid');
      imageUrl.value = await ref.getDownloadURL();
    } catch (e) {
      print('No profile picture found or error loading picture: $e');
    }
  }

  // Pick an image from the gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 500, // Optional: Limit image size to reduce memory usage
        maxHeight: 500,
      );

      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        await uploadProfilePicture();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
      print('Error picking image: $e');
    }
  }

  // Upload profile picture to Firebase Storage and update Firestore
  Future<void> uploadProfilePicture() async {
    if (imageFile.value == null) return;

    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      // Upload to Firebase Storage
      final ref = _storage.ref().child('profile_pictures/${user.uid}');
      await ref.putFile(imageFile.value!);
      final downloadUrl = await ref.getDownloadURL();

      // Update Firestore with new image URL
      await _firestore.collection('users').doc(user.uid).update({
        'profileImageUrl': downloadUrl,
      });
      imageUrl.value = downloadUrl;

      Get.snackbar('Success', 'Profile picture updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile picture');
      print('Error uploading profile picture: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile information
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      if (passwordController.text.isNotEmpty) {
        await user.updatePassword(passwordController.text);
      }

      // Update additional information in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'username': usernameController.text,
        'email': emailController.text,
      });

      Get.snackbar('Success', 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
      print('Error updating profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/welcome'); // Navigate to login page
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout');
      print('Error logging out: $e');
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
