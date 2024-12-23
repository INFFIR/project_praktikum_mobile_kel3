// lib/app/modules/open_product/view/open_product_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/bindings/detail_product_binding.dart';
import '../../product/controllers/product_controller.dart';
import '../../../routes/app_routes.dart';
// import '../../components/bottom_navbar.dart'; // Hapus jika tidak digunakan

// Controller untuk OpenProductPage
class OpenProductController extends GetxController {
  final String productId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observable untuk menyimpan data produk
  var product = Rxn<DocumentSnapshot>();

  // Observable untuk status favorit
  var isFavorited = false.obs;

  // ID pengguna saat ini
  final String currentUserId = Get.find<ProductController>().currentUserId;

  OpenProductController(this.productId);

  @override
  void onInit() {
    super.onInit();
    // Mendengarkan perubahan data produk secara real-time
    firestore.collection('products').doc(productId).snapshots().listen((doc) {
      product.value = doc;
      if (doc.exists) {
        // Update status favorit
        firestore
            .collection('products')
            .doc(productId)
            .collection('favorites')
            .doc(currentUserId)
            .get()
            .then((favDoc) {
          isFavorited.value = favDoc.exists;
        });
      }
    });
  }

  // Fungsi untuk toggle favorit
  Future<void> toggleFavorite() async {
    if (product.value == null || !product.value!.exists) return;

    try {
      final favRef = firestore
          .collection('products')
          .doc(productId)
          .collection('favorites')
          .doc(currentUserId);

      if (isFavorited.value) {
        await favRef.delete();
        await firestore.collection('products').doc(productId).update({
          'likes': FieldValue.increment(-1),
        });
        isFavorited.value = false;
        Get.snackbar("Info", "Favorit Dihapus",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        await favRef.set({'userId': currentUserId});
        await firestore.collection('products').doc(productId).update({
          'likes': FieldValue.increment(1),
        });
        isFavorited.value = true;
        Get.snackbar("Info", "Favorit Ditambahkan",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui favorit",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class OpenProductPage extends StatelessWidget {
  final int productIndex;
  const OpenProductPage({super.key, required this.productIndex});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();

    // Validasi productIndex
    if (productIndex < 0 || productIndex >= productController.products.length) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Produk Tidak Ditemukan"),
        ),
        body: const Center(
          child: Text("Produk yang Anda cari tidak ditemukan."),
        ),
      );
    }

    // Mendapatkan productId dari productIndex
    final productId = productController.products[productIndex].id;

    // Inisialisasi controller dengan productId
    final OpenProductController controller =
        Get.put(OpenProductController(productId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          // Pastikan data produk sudah ada sebelum mengaksesnya
          String title = controller.product.value?.data() != null
              ? (controller.product.value!.data() as Map<String, dynamic>)['name'] ?? 'Produk'
              : 'Produk';
          return Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Times New Roman',
            ),
          );
        }),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(
                controller.isFavorited.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.isFavorited.value ? Colors.red : Colors.black,
              ),
              onPressed: () {
                controller.toggleFavorite();
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.product.value!.exists) {
          return const Center(child: Text("Produk tidak ditemukan."));
        }

        final data = controller.product.value!.data() as Map<String, dynamic>;

        final String name = data['name'] ?? 'Nama Produk Tidak Tersedia';
        final int price = data['price'] ?? 0;
        final String imageUrl = data['imageUrl'] ?? '';
        final int likes = data['likes'] ?? 0;
        final String description =
            data['description'] ?? 'Tidak ada deskripsi';

        // Tentukan widget image
        Widget imageWidget;
        if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
          imageWidget = Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stack) {
              return Image.asset(
                'assets/product/default.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          );
        } else if (imageUrl.isNotEmpty && imageUrl.startsWith('assets/')) {
          imageWidget = Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stack) {
              return Image.asset(
                'assets/product/default.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          );
        } else {
          // Jika kosong, atau file lokal
          imageWidget = Image.asset(
            'assets/product/default.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        }

        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Gambar
                Container(
                  width: 240,
                  height: 240,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageWidget,
                ),
                const SizedBox(height: 30),
                // Nama
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontFamily: 'Times New Roman',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Harga
                Text(
                  'Rp $price,-',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontFamily: 'Times New Roman',
                  ),
                ),
                const SizedBox(height: 20),
                // Likes
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: controller.isFavorited.value
                          ? Colors.red
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$likes likes',
                      style: const TextStyle(
                          fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Deskripsi
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontFamily: 'Times New Roman',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                // Tombol
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Review
                    ElevatedButton(
                      onPressed: () {
                        // Pergi ke detail product dengan mengirimkan productId
                        Get.toNamed(
                          Routes.detailProduct,
                          arguments: {'productId': productId},
                          // binding: DetailProductBindings(), // Hapus atau definisikan di route
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Review',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Buy Now
                    ElevatedButton(
                      onPressed: () {
                        // Ensure product data is available
                        if (controller.product.value != null && controller.product.value!.exists) {
                          final String productId = controller.product.value!.id;
                          final Map<String, dynamic> data = controller.product.value!.data() as Map<String, dynamic>;
                          final int priceInt = data['price'] ?? 0;
                          final double amount = priceInt.toDouble();

                          // Navigate to the Payment page with arguments
                          Get.toNamed(
                            Routes.payment,
                            arguments: {
                              'productId': productId,
                              'amount': amount,
                            },
                          );
                        } else {
                          Get.snackbar(
                            "Error",
                            "Product data is not available.",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black54),
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }), // Tutup Obx
    ); // Tutup Scaffold
  }
}
