import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class DetailProductController extends GetxController {
  var imageAssetPath = 'assets/product/product0.jpg';
  var productImages = <XFile>[];

  // List review dinamis
  var reviews = [
    {
      'rating': '4.2',
      'reviewer': 'Amat',
      'date': '1 Jan 2024',
      'comment': 'Recommended item and according to order',
    },
    // Add other reviews
  ].obs;

  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar menggunakan kamera
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      productImages.add(pickedFile);
      update(); // Memperbarui UI setelah gambar ditambahkan
    }
  }

  // Fungsi untuk memilih video menggunakan kamera
  Future<void> pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      // Lakukan sesuatu dengan video, misalnya menyimpannya atau memutarnya
      print('Picked video path: ${pickedFile.path}');
    }
  }
}
