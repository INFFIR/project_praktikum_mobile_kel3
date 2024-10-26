// add_product_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../product/controllers/product_controller.dart';

class AddProductPage extends StatelessWidget {
  AddProductPage({super.key});

  final ProductController productController = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  // Tambahkan controller lain jika diperlukan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
              ),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Harga Produk',
              ),
              keyboardType: TextInputType.number,
            ),
            // Tambahkan input lain jika diperlukan
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan produk baru ke controller
                productController.addProduct(
                  name: nameController.text,
                  price: priceController.text,
                  image:
                      'assets/product/default.jpg', // Gunakan gambar default atau implementasi upload gambar
                );
                Get.back();
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
