import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../product/controllers/product_controller.dart';

class OpenProductPage extends StatelessWidget {
  final int productIndex;
  final ProductController productController = Get.find();

  OpenProductPage({
    super.key,
    required this.productIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Mengambil data produk berdasarkan indeks
    final product = productController.products[productIndex];
    final isFavorited = productController.isFavorited[productIndex];
    final likes = RxInt(product['likes'] ?? 0);

    // Mengatur data produk dengan validasi untuk nama, harga, dan URL gambar
    final String name = product['name'] ?? 'Nama Produk Tidak Tersedia';
    final int price = product['price'] ?? 0; // Tampilkan sebagai int
    final String imageUrl = product['imageUrl'] ?? 'assets/product/default.jpg';

    // Menampilkan gambar berdasarkan apakah imageUrl adalah URL atau rute lokal
    Widget imageWidget;

    if (imageUrl.startsWith('http')) {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/product/default.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      );
    } else {
      imageWidget = Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/product/default.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Times New Roman',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                isFavorited.value ? Icons.favorite : Icons.favorite_border,
                color: isFavorited.value ? Colors.red : Colors.black,
              ),
              onPressed: () {
                const userId = 'current_user_id'; // ID pengguna
                productController.toggleFavorite(productIndex, userId);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Produk
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageWidget,
              ),
              const SizedBox(height: 30),
              // Nama Produk
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
              // Harga Produk sebagai int
              Text(
                'Rp $price,-',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontFamily: 'Times New Roman',
                ),
              ),
              const SizedBox(height: 20),
              // Jumlah Likes
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: isFavorited.value ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${likes.value} likes',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Spesifikasi Produk
              const Text(
                'Specifications',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Attractive design and colors\n'
                  'Battery built-in 800mah battery\n'
                  'Airflow adjustable\n'
                  'Type C fast charging productnation',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontFamily: 'Times New Roman',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 60),
              // Tombol Buy Now
              ElevatedButton(
                onPressed: () {
                  Get.toNamed("/detail_product");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
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
        ),
      ),
    );
  }
}
