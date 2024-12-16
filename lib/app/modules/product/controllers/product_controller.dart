import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

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

      await firestore.collection('products').add({
        'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
        'price': parsedPrice,
        'imageUrl': imageUrl,
        'likes': 0,
      });
    } catch (e) {
      print("Error in addProduct: $e");
      throw e; // Rethrow untuk ditangani di halaman
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await firestore.collection('products').doc(productId).delete();
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

      await firestore.collection('products').doc(productId).update(updatedData);
    } catch (e) {
      print("Error in editProduct: $e");
      throw e; // Rethrow untuk ditangani di halaman
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
}
