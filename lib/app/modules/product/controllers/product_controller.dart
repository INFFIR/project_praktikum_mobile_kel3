// lib/app/product/controllers/product_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/product_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get currentUserId => _auth.currentUser?.uid ?? '';

  // Ubah jadi list of ProductModel
  final products = <ProductModel>[].obs;
  final filteredProducts = <ProductModel>[].obs;

  // Map productId -> RxBool
  final isFavorited = <String, RxBool>{}.obs;

  final _snackbarLastShown = DateTime.now().subtract(const Duration(seconds: 1)).obs;
  final isListening = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() {
    firestore.collection('products').snapshots().listen((snapshot) {
      final tempList = <ProductModel>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final product = ProductModel.fromMap(doc.id, data);
        tempList.add(product);
      }

      products.value = tempList;
      filteredProducts.assignAll(tempList);

      _initializeFavorites();
    });
  }

  Future<void> _initializeFavorites() async {
    isFavorited.clear();
    for (var product in products) {
      final favDoc = await firestore
          .collection('products')
          .doc(product.id)
          .collection('favorites')
          .doc(currentUserId)
          .get();
      isFavorited[product.id] = (favDoc.exists).obs;
    }
  }

  void filterProducts(String query) {
    final cleanedQuery = query.trim().toLowerCase();
    if (cleanedQuery.isEmpty) {
      filteredProducts.assignAll(products);
      _showSnackbar("Pencarian Reset");
    } else {
      filteredProducts.assignAll(
        products.where((p) => p.name.toLowerCase().contains(cleanedQuery)).toList(),
      );
      if (filteredProducts.isEmpty) {
        _showSnackbar("Pencarian Tidak Ditemukan");
      } else {
        _showSnackbar("Pencarian Diterapkan");
      }
    }
  }

  Future<void> addProduct({
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    try {
      final parsedPrice = int.tryParse(price);
      if (parsedPrice == null) {
        throw Exception("Harga harus berupa angka.");
      }

      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
      }

      await firestore.collection('products').add({
        'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
        'price': parsedPrice,
        'imageUrl': imageUrl,
        'likes': 0,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editProduct(
    String productId, {
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    try {
      final parsedPrice = int.tryParse(price);
      if (parsedPrice == null) {
        throw Exception("Harga harus berupa angka.");
      }

      final updatedData = {
        'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
        'price': parsedPrice,
      };

      if (imageFile != null) {
        final imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
        updatedData['imageUrl'] = imageUrl;
      }

      await firestore.collection('products').doc(productId).update(updatedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFavorite(int index) async {
    try {
      final product = products[index];
      final favRef = firestore
          .collection('products')
          .doc(product.id)
          .collection('favorites')
          .doc(currentUserId);

      final favDoc = await favRef.get();
      if (favDoc.exists) {
        await favRef.delete();
        final newLikes = (product.likes - 1) < 0 ? 0 : product.likes - 1;
        await firestore.collection('products').doc(product.id).update({
          'likes': newLikes,
        });
        isFavorited[product.id]?.value = false;
        _showSnackbar("Favorit Dihapus");
      } else {
        await favRef.set({'userId': currentUserId});
        final newLikes = product.likes + 1;
        await firestore.collection('products').doc(product.id).update({
          'likes': newLikes,
        });
        isFavorited[product.id]?.value = true;
        _showSnackbar("Favorit Ditambahkan");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFavoriteById(String productId) async {
    try {
      final favRef = firestore
          .collection('products')
          .doc(productId)
          .collection('favorites')
          .doc(currentUserId);
      final favDoc = await favRef.get();

      if (favDoc.exists) {
        await favRef.delete();
        await firestore.collection('products').doc(productId).update({
          'likes': FieldValue.increment(-1),
        });
        isFavorited[productId]?.value = false;
        _showSnackbar("Favorit Dihapus");
      } else {
        await favRef.set({'userId': currentUserId});
        await firestore.collection('products').doc(productId).update({
          'likes': FieldValue.increment(1),
        });
        isFavorited[productId]?.value = true;
        _showSnackbar("Favorit Ditambahkan");
      }
    } catch (e) {
      rethrow;
    }
  }

  void resetSearch() {
    filteredProducts.assignAll(products);
    _showSnackbar("Pencarian Reset");
  }

  void _showSnackbar(String message) {
    final now = DateTime.now();
    if (now.difference(_snackbarLastShown.value).inSeconds >= 1) {
      Get.snackbar("Info", message, snackPosition: SnackPosition.BOTTOM);
      _snackbarLastShown.value = now;
    }
  }

  Future<String> _uploadImageToStorage(File imageFile, String folder) async {
    final storageReference = storage.ref().child(
      '$folder/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}',
    );
    final uploadTask = storageReference.putFile(imageFile);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
