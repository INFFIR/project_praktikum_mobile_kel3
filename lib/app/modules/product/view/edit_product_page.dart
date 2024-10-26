// edit_product_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../product/controllers/product_controller.dart';

class EditProductPage extends StatelessWidget {
  final int productIndex;
  EditProductPage({super.key, required this.productIndex});

  final ProductController productController = Get.find();

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  // Tambahkan controller lain jika diperlukan

  @override
  Widget build(BuildContext context) {
    final product = productController.products[productIndex];

    nameController = TextEditingController(text: product['name']);
    priceController = TextEditingController(text: product['price']);
    // Inisialisasi controller lain jika diperlukan

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
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
                // Update produk di controller
                productController.editProduct(
                  productIndex,
                  name: nameController.text,
                  price: priceController.text,
                  image: productController.productImages[
                      productIndex], // Gunakan gambar yang sama atau implementasi upload gambar
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
