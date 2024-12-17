// lib/app/modules/product/controllers/product_controller.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';

import '../../services/connectivity_service.dart';

class ProductController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final products = <Map<String, dynamic>>[].obs;
  final filteredProducts = <Map<String, dynamic>>[].obs;
  final isFavorited = <String, RxBool>{}.obs;

  late String userId;

  // GetStorage instance untuk menyimpan data pending
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
      fetchProducts();
      // Mendengarkan perubahan konektivitas dan mengirim data pending saat online
      Get.find<ConnectivityService>().isConnected.listen((isConnected) {
        if (isConnected) {
          sendPendingData();
        }
      });
    } else {
      Get.snackbar(
        'Error',
        'User not logged in.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fungsi untuk mengambil data produk dari Firestore
  void fetchProducts() {
    firestore.collection('products').snapshots().listen((snapshot) async {
      products.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      filteredProducts.assignAll(products);

      await _initializeFavorites();
    });
  }

  // Fungsi untuk menginisialisasi status favorit
  Future<void> _initializeFavorites() async {
    Map<String, RxBool> favMap = {};

    for (var product in products) {
      String productId = product['id'] as String;
      DocumentSnapshot favDoc = await firestore
          .collection('products')
          .doc(productId)
          .collection('favorites')
          .doc(userId)
          .get();

      favMap[productId] = favDoc.exists.obs;
    }

    isFavorited.assignAll(favMap);
  }

  // Fungsi untuk memfilter produk berdasarkan pencarian
  void filterProducts(String query) {
    final cleanedQuery = query.trim().toLowerCase();

    if (cleanedQuery.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products.where((product) {
          final name = product['name']?.toLowerCase() ?? '';
          return name.contains(cleanedQuery);
        }).toList(),
      );
    }

    print('Filtered Products: ${filteredProducts.length} items found.');
  }

  // Fungsi untuk menambahkan produk baru dengan retry dan penyimpanan lokal saat offline
  Future<void> addProduct({
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    int? parsedPrice = int.tryParse(price);
    if (parsedPrice == null) {
      Get.snackbar("Error", "Price must be an integer value.");
      return;
    }

    String imageUrl = '';
    if (imageFile != null) {
      imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
    }

    Map<String, dynamic> productData = {
      'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
      'price': parsedPrice,
      'imageUrl': imageUrl,
      'likes': 0,
    };

    try {
      await _addDataWithRetry('products', productData);
      Get.snackbar(
        "Sukses",
        "Produk berhasil ditambahkan ke Firestore",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.5),
        colorText: Colors.white,
      );
    } catch (e) {
      // Jika gagal setelah retry, data telah disimpan secara lokal
      Get.snackbar(
        "Error",
        "Produk disimpan secara lokal dan akan disinkronkan saat online.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.5),
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk menambahkan data dengan retry menggunakan exponential backoff
  Future<void> _addDataWithRetry(String collection, Map<String, dynamic> data) async {
    int retryCount = 0;
    const int maxRetries = 5;
    const Duration initialDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        await firestore.collection(collection).add(data);
        print('Data berhasil disimpan ke Firestore');
        return;
      } catch (e) {
        if (e is FirebaseException && e.code == 'unavailable') {
          retryCount++;
          final delay = initialDelay * pow(2, retryCount).toInt();
          print('Firestore unavailable, retrying in ${delay.inSeconds} seconds...');
          await Future.delayed(delay);
        } else {
          print('Terjadi error: $e');
          rethrow;
        }
      }
    }

    // Jika mencapai maxRetries, simpan data secara lokal
    print('Gagal menyimpan data ke Firestore setelah $maxRetries percobaan');
    await _savePendingData(collection, data);
    throw Exception('Gagal menyimpan data ke Firestore setelah $maxRetries percobaan');
  }

  // Fungsi untuk menyimpan data ke local storage sebagai pending
  Future<void> _savePendingData(String collection, Map<String, dynamic> data) async {
    List<Map<String, dynamic>> pendingData =
        _storage.read<List<dynamic>>('pending_$collection')?.cast<Map<String, dynamic>>() ?? [];
    pendingData.add(data);
    await _storage.write('pending_$collection', pendingData);
    print('Data disimpan secara lokal untuk sinkronisasi nanti');
  }

  // Fungsi untuk mengirim data yang belum terkirim
  Future<void> sendPendingData() async {
    String collection = 'products';
    List<dynamic> pendingData = _storage.read<List<dynamic>>('pending_$collection') ?? [];

    for (var data in pendingData) {
      try {
        await firestore.collection(collection).add(Map<String, dynamic>.from(data));
        print('Data pending berhasil disinkronkan ke Firestore');
      } catch (e) {
        print('Gagal menyinkronkan data pending: $e');
        // Jika masih gagal, hentikan proses sinkronisasi
        return;
      }
    }

    // Jika semua data berhasil disinkronkan, hapus dari local storage
    await _storage.remove('pending_$collection');
    print('Semua data pending telah disinkronkan dan dihapus dari local storage');
  }

  // Fungsi untuk menghapus produk
  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
    isFavorited.remove(productId);
  }

  // Fungsi untuk mengedit produk
  Future<void> editProduct(
    String productId, {
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    int? parsedPrice = int.tryParse(price);
    if (parsedPrice == null) {
      Get.snackbar("Error", "Price must be an integer value.");
      return;
    }

    Map<String, dynamic> updatedData = {
      'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
      'price': parsedPrice,
    };

    if (imageFile != null) {
      String imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
      updatedData['imageUrl'] = imageUrl;
    }

    await firestore.collection('products').doc(productId).update(updatedData);
  }

  // Fungsi untuk meng-upload gambar produk ke Firebase Storage
  Future<String> _uploadImageToStorage(File imageFile, String folder) async {
    Reference storageReference = storage.ref().child(
        '$folder/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  // Fungsi untuk men-toggle status favorit produk
  void toggleFavorite(int index) async {
    if (index < 0 || index >= products.length) {
      Get.snackbar('Error', 'Invalid product index.');
      return;
    }

    final product = products[index];
    final productId = product['id'] as String;

    final favRef = firestore
        .collection('products')
        .doc(productId)
        .collection('favorites')
        .doc(userId);

    final favDoc = await favRef.get();

    if (favDoc.exists) {
      await favRef.delete();
      products[index]['likes'] = (products[index]['likes'] ?? 1) - 1;
      if (isFavorited.containsKey(productId)) {
        isFavorited[productId]?.value = false;
      }
    } else {
      await favRef.set({'userId': userId});
      products[index]['likes'] = (products[index]['likes'] ?? 0) + 1;
      if (isFavorited.containsKey(productId)) {
        isFavorited[productId]?.value = true;
      }
    }

    await firestore.collection('products').doc(productId).update({
      'likes': products[index]['likes'],
    });
  }

  // Fungsi untuk mereset pencarian dan menampilkan semua produk
  void resetSearch() {
    filteredProducts.assignAll(products);
  }
}
