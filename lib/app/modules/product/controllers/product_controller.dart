// lib/app/product/controllers/product_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import '../../services/connectivity_service.dart'; // Import ConnectivityService

class ProductController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Menggunakan FirebaseAuth untuk mendapatkan currentUserId
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get currentUserId => _auth.currentUser?.uid ?? '';

  final products = <Map<String, dynamic>>[].obs;
  final filteredProducts = <Map<String, dynamic>>[].obs; // Produk hasil filter
  final isFavorited = <String, RxBool>{}.obs; // Menggunakan Map untuk isFavorited

  // Untuk debounce snackbar
  final _snackbarLastShown = DateTime.now().subtract(Duration(seconds: 1)).obs;

  // GetStorage instance
  final GetStorage _storage = GetStorage();

  // Keys untuk operasi pending
  final String _pendingAddsKey = 'pending_adds';
  final String _pendingEditsKey = 'pending_edits';

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() {
    firestore.collection('products').snapshots().listen((snapshot) {
      products.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      // Sinkronisasi produk terfilter dengan semua produk
      filteredProducts.assignAll(products);

      // Inisialisasi status favorit berdasarkan user saat ini
      _initializeFavorites();
    });
  }

  Future<void> _initializeFavorites() async {
    // Clear isFavorited sebelum menginisialisasi
    isFavorited.clear();

    // Mendapatkan semua productIds
    List<String> productIds = products.map((product) => product['id'] as String).toList();

    // Ambil semua favorit sekaligus menggunakan Future.wait
    List<Future<void>> futures = productIds.map((productId) async {
      DocumentSnapshot favDoc = await firestore
          .collection('products')
          .doc(productId)
          .collection('favorites')
          .doc(currentUserId)
          .get();
      isFavorited[productId] = (favDoc.exists).obs;
    }).toList();

    await Future.wait(futures);
  }

  // Fungsi untuk memfilter produk berdasarkan pencarian (teks atau suara)
  void filterProducts(String query) {
    final cleanedQuery = query.trim().toLowerCase();
    if (cleanedQuery.isEmpty) {
      filteredProducts.assignAll(products);
      _showSnackbar("Pencarian Reset");
    } else {
      filteredProducts.assignAll(
        products.where((product) {
          final name = product['name']?.toLowerCase() ?? '';
          return name.contains(cleanedQuery);
        }).toList(),
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
      int? parsedPrice = int.tryParse(price);
      if (parsedPrice == null) {
        throw Exception("Harga harus berupa angka.");
      }

      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
      }

      // Buat data produk
      Map<String, dynamic> productData = {
        'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
        'price': parsedPrice,
        'imageUrl': imageUrl,
        'likes': 0,
      };

      // Coba tambahkan ke Firestore
      await firestore.collection('products').add(productData);
      _showSnackbar("Produk berhasil ditambahkan.");
    } on FirebaseException catch (e) {
      print("FirebaseException in addProduct: $e");
      if (e.code == 'unavailable') {
        // Masalah konektivitas
        if (!isConnected()) {
          // Simpan ke pending adds
          _savePendingAdd({
            'name': name,
            'price': price,
            'imagePath': imageFile?.path ?? '',
          });
          Get.snackbar(
            "Offline",
            "Produk akan ditambahkan saat koneksi kembali.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withOpacity(0.5),
            colorText: Colors.white,
          );
        } else {
          // Rethrow untuk ditangani di halaman
          throw e;
        }
      } else {
        // Tangani exception lain jika perlu
        throw e;
      }
    } catch (e) {
      print("Error in addProduct: $e");
      // Tangani exception lain jika perlu
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).delete();
      _showSnackbar("Produk berhasil dihapus.");
    } catch (e) {
      print("Error in deleteProduct: $e");
      throw e; // Rethrow untuk ditangani di halaman
    }
  }

  Future<void> editProduct(
    String productId, {
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    try {
      int? parsedPrice = int.tryParse(price);
      if (parsedPrice == null) {
        throw Exception("Harga harus berupa angka.");
      }

      Map<String, dynamic> updatedData = {
        'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
        'price': parsedPrice,
      };

      if (imageFile != null) {
        String imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
        updatedData['imageUrl'] = imageUrl;
      }

      // Coba update Firestore
      await firestore.collection('products').doc(productId).update(updatedData);
      _showSnackbar("Produk berhasil diperbarui.");
    } on FirebaseException catch (e) {
      print("FirebaseException in editProduct: $e");
      if (e.code == 'unavailable') {
        // Masalah konektivitas
        if (!isConnected()) {
          // Simpan ke pending edits
          _savePendingEdit({
            'productId': productId,
            'name': name,
            'price': price,
            'imagePath': imageFile?.path ?? '',
          });
          Get.snackbar(
            "Offline",
            "Perubahan produk akan disimpan saat koneksi kembali.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.withOpacity(0.5),
            colorText: Colors.white,
          );
        } else {
          // Rethrow untuk ditangani di halaman
          throw e;
        }
      } else {
        // Tangani exception lain jika perlu
        throw e;
      }
    } catch (e) {
      print("Error in editProduct: $e");
      // Tangani exception lain jika perlu
      throw e;
    }
  }

  Future<String> _uploadImageToStorage(File imageFile, String folder) async {
    Reference storageReference = storage.ref().child(
        '$folder/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  void toggleFavorite(int index) async {
    try {
      final product = products[index];
      final productId = product['id'] as String;
      final favRef = firestore
          .collection('products')
          .doc(productId)
          .collection('favorites')
          .doc(currentUserId);

      final favDoc = await favRef.get();

      if (favDoc.exists) {
        await favRef.delete();
        product['likes'] = (product['likes'] ?? 1) - 1;
        isFavorited[productId]?.value = false;
        Get.snackbar("Favorit Dihapus", "Favorit Dihapus");
      } else {
        await favRef.set({'userId': currentUserId});
        product['likes'] = (product['likes'] ?? 0) + 1;
        isFavorited[productId]?.value = true;
        Get.snackbar("Favorit Ditambahkan", "Favorit Ditambahkan");
      }

      await firestore.collection('products').doc(productId).update({
        'likes': product['likes'],
      });
    } on FirebaseException catch (e) {
      print("FirebaseException in toggleFavorite: $e");
      throw e; // Rethrow untuk ditangani di halaman
    } catch (e) {
      print("Error in toggleFavorite: $e");
      throw e; // Rethrow untuk ditangani di halaman
    }
  }

  // Fungsi untuk mereset hasil pencarian
  void resetSearch() {
    filteredProducts.assignAll(products);
    _showSnackbar("Pencarian Reset");
  }

  // Fungsi untuk menampilkan snackbar dengan debounce
  void _showSnackbar(String message) {
    final now = DateTime.now();
    if (now.difference(_snackbarLastShown.value).inSeconds >= 1) {
      Get.snackbar("Info", message, snackPosition: SnackPosition.BOTTOM);
      _snackbarLastShown.value = now;
    }
  }

  // Helper untuk mengecek status koneksi
  bool isConnected() {
    try {
      var connectivityService = Get.find<ConnectivityService>();
      return connectivityService.isConnected.value;
    } catch (e) {
      // Jika ConnectivityService tidak ditemukan, anggap terhubung
      return true;
    }
  }

  // Simpan operasi add yang pending ke GetStorage
  void _savePendingAdd(Map<String, dynamic> data) {
    List<dynamic> pendingAdds = _storage.read<List<dynamic>>(_pendingAddsKey) ?? [];
    pendingAdds.add(data);
    _storage.write(_pendingAddsKey, pendingAdds);
  }

  // Simpan operasi edit yang pending ke GetStorage
  void _savePendingEdit(Map<String, dynamic> data) {
    List<dynamic> pendingEdits = _storage.read<List<dynamic>>(_pendingEditsKey) ?? [];
    pendingEdits.add(data);
    _storage.write(_pendingEditsKey, pendingEdits);
  }

  // Fungsi untuk mengupload operasi add dan edit yang pending
  Future<void> uploadPendingProducts() async {
    List<dynamic> pendingAdds = _storage.read<List<dynamic>>(_pendingAddsKey) ?? [];
    List<dynamic> pendingEdits = _storage.read<List<dynamic>>(_pendingEditsKey) ?? [];

    // Proses pending adds
    for (var addData in pendingAdds) {
      try {
        String name = addData['name'];
        String price = addData['price'];
        String imagePath = addData['imagePath'];

        File? imageFile = imagePath.isNotEmpty ? File(imagePath) : null;
        int? parsedPrice = int.tryParse(price);
        if (parsedPrice == null) continue; // Lewati jika harga tidak valid

        String imageUrl = '';
        if (imageFile != null && await imageFile.exists()) {
          imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
        }

        // Buat data produk
        Map<String, dynamic> productData = {
          'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
          'price': parsedPrice,
          'imageUrl': imageUrl,
          'likes': 0,
        };

        // Tambahkan ke Firestore
        await firestore.collection('products').add(productData);

        // Opsional: hapus file gambar setelah upload
        if (imageFile != null) {
          await imageFile.delete();
        }
      } catch (e) {
        print("Error uploading pending add product: $e");
        // Jika terjadi error, simpan kembali untuk percobaan selanjutnya
        continue;
      }
    }

    // Hapus pending adds setelah berhasil diupload
    _storage.remove(_pendingAddsKey);

    // Proses pending edits
    for (var editData in pendingEdits) {
      try {
        String productId = editData['productId'];
        String name = editData['name'];
        String price = editData['price'];
        String imagePath = editData['imagePath'];

        File? imageFile = imagePath.isNotEmpty ? File(imagePath) : null;
        int? parsedPrice = int.tryParse(price);
        if (parsedPrice == null) continue; // Lewati jika harga tidak valid

        Map<String, dynamic> updatedData = {
          'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
          'price': parsedPrice,
        };

        if (imageFile != null && await imageFile.exists()) {
          String imageUrl = await _uploadImageToStorage(imageFile, 'product_images');
          updatedData['imageUrl'] = imageUrl;
        }

        // Coba update Firestore
        await firestore.collection('products').doc(productId).update(updatedData);

        // Update list lokal jika diperlukan
        int index = products.indexWhere((item) => item['id'] == productId);
        if (index != -1) {
          products[index]['name'] = updatedData['name'];
          products[index]['price'] = updatedData['price'];
          if (updatedData.containsKey('imageUrl')) {
            products[index]['imageUrl'] = updatedData['imageUrl'];
          }
        }

        // Opsional: hapus file gambar setelah upload
        if (imageFile != null) {
          await imageFile.delete();
        }
      } catch (e) {
        print("Error uploading pending edit product: $e");
        // Jika terjadi error, simpan kembali untuk percobaan selanjutnya
        continue;
      }
    }

    // Hapus pending edits setelah berhasil diupload
    _storage.remove(_pendingEditsKey);
  }
}
