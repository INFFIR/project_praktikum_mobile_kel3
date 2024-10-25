import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  var imageUrl = ''.obs;
  var userName = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var rePassword = ''.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      imageUrl.value = image.path;
    }
  }

  void updateProfile() {
    // Implement your update logic here
    if (password.value != rePassword.value) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: const Color(0xFF2C2C2C),
        colorText: Colors.white,
      );
      return;
    }
    
    // Add your API call or database update here
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: const Color(0xFF2C2C2C),
      colorText: Colors.white,
    );
  }
}
