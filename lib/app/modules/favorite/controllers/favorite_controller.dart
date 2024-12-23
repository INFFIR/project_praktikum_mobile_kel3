// lib/app/favorite/controllers/favorite_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../product/controllers/product_controller.dart';
import 'package:flutter/material.dart';

class FavoriteController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ProductController productController = Get.find();

  // Daftar produk favorit
  final favoriteProducts = <Map<String, dynamic>>[].obs;

  // Daftar produk favorit yang sudah difilter berdasarkan pencarian
  final filteredFavoriteProducts = <Map<String, dynamic>>[].obs;

  // Status untuk mendengarkan (speech-to-text)
  final isListening = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoriteProducts();

    // Mendengarkan perubahan pada produk dan status favorit
    productController.products.listen((_) => fetchFavoriteProducts());
    productController.isFavorited.listen((_) => fetchFavoriteProducts());
  }

  void fetchFavoriteProducts() {
    // Memfilter produk yang di favoritkan oleh pengguna saat ini
    // favoriteProducts.value = productController.products.where((product) {
    //   String productId = product['id'] as String;
    //   return productController.isFavorited[productId]?.value ?? false;
    // }).toList();

    // Secara awal, tampilkan semua produk favorit
    filteredFavoriteProducts.assignAll(favoriteProducts);
  }

  // Fungsi untuk memfilter produk favorit berdasarkan query pencarian
  void filterFavoriteProducts(String query) {
    final cleanedQuery = query.trim().toLowerCase();
    if (cleanedQuery.isEmpty) {
      filteredFavoriteProducts.assignAll(favoriteProducts);
    } else {
      filteredFavoriteProducts.assignAll(
        favoriteProducts.where((product) {
          final name = product['name']?.toLowerCase() ?? '';
          return name.contains(cleanedQuery);
        }).toList(),
      );
    }
  }

  // Fungsi untuk menghapus favorit
  void removeFavorite(String productId) async {
    try {
      await productController.toggleFavoriteById(productId);
      Get.snackbar(
        "Favorit Dihapus",
        "Produk telah dihapus dari favorit.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan saat menghapus favorit.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    }
  }
}
