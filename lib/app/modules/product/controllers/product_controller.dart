import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProductController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final products = <Map<String, dynamic>>[].obs; // Produk yang diambil dari Firestore
  final filteredProducts = <Map<String, dynamic>>[].obs; // Produk hasil filter
  final isFavorited = <RxBool>[].obs; // Status favorit untuk setiap produk

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fungsi untuk mengambil data produk dari Firestore
  void fetchProducts() {
    firestore.collection('products').snapshots().listen((snapshot) {
      // Menyimpan produk ke dalam 'products'
      products.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Menambahkan id produk
        return data;
      }).toList();

      // Menginisialisasi filteredProducts dengan semua produk
      filteredProducts.assignAll(products);

      // Menginisialisasi status favorit
      isFavorited.assignAll(
        List<RxBool>.generate(products.length, (_) => false.obs),
      );
    });
  }

  // Fungsi untuk memfilter produk berdasarkan pencarian
  void filterProducts(String query) {
    final cleanedQuery = query.trim().toLowerCase();

    // Cek apakah query kosong
    if (cleanedQuery.isEmpty) {
      filteredProducts.assignAll(products); // Tampilkan semua produk
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

  // Fungsi untuk menambahkan produk baru
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

    await firestore.collection('products').add({
      'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
      'price': parsedPrice,
      'imageUrl': imageUrl,
      'likes': 0,
    });
  }

  // Fungsi untuk menghapus produk
  Future<void> deleteProduct(String productId) async {
    await firestore.collection('products').doc(productId).delete();
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
      String imageUrl =
          await _uploadImageToStorage(imageFile, 'product_images');
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
  void toggleFavorite(int index, String userId) async {
    final productId = products[index]['id'];
    final favRef = firestore
        .collection('products')
        .doc(productId)
        .collection('favorites')
        .doc(userId);

    final favDoc = await favRef.get();

    if (favDoc.exists) {
      await favRef.delete();
      products[index]['likes'] = (products[index]['likes'] ?? 1) - 1;
      isFavorited[index].value = false;
    } else {
      await favRef.set({'userId': userId});
      products[index]['likes'] = (products[index]['likes'] ?? 0) + 1;
      isFavorited[index].value = true;
    }

    firestore.collection('products').doc(productId).update({
      'likes': products[index]['likes'],
    });
  }

  // Fungsi untuk mereset pencarian dan menampilkan semua produk
  void resetSearch() {
    filteredProducts.assignAll(products);
  }
}