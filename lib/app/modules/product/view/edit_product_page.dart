// lib/app/product/views/edit_product_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/product_controller.dart';

class EditProductPage extends StatefulWidget {
  final String productId;
  const EditProductPage({super.key, required this.productId});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ProductController productController = Get.find<ProductController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  File? _image;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  void fetchProductData() async {
    try {
      final doc = await productController.firestore
          .collection('products')
          .doc(widget.productId)
          .get();
      final data = doc.data();
      if (data != null) {
        nameController.text = data['name'] ?? '';
        priceController.text = data['price']?.toString() ?? '';
        setState(() {
          imageUrl = data['imageUrl'];
        });
      } else {
        Get.snackbar(
          "Error",
          "Produk tidak ditemukan.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,
        );
        Get.back();
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan saat mengambil data produk.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedFile != null ? File(pickedFile.path) : null;
      });
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan saat memilih gambar.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (_image != null) {
      imageWidget = Image.file(
        _image!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      imageWidget = Image.network(
        imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) {
          return Image.asset(
            'assets/product/default.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      );
    } else {
      imageWidget = Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
          size: 50,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tampilan Gambar
              GestureDetector(
                onTap: _pickImage,
                child: imageWidget,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Harga Produk',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty ||
                      priceController.text.trim().isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Nama dan harga produk tidak boleh kosong.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.5),
                      colorText: Colors.white,
                    );
                    return;
                  }

                  try {
                    await productController.editProduct(
                      widget.productId,
                      name: nameController.text.trim(),
                      price: priceController.text.trim(),
                      imageFile: _image,
                    );
                    Get.snackbar(
                      "Berhasil",
                      "Produk Diperbarui",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.withOpacity(0.5),
                      colorText: Colors.white,
                    );
                    Get.back();
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Terjadi kesalahan saat memperbarui produk.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.withOpacity(0.5),
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
