// edit_product_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../product/controllers/product_controller.dart';
import 'dart:io';

class EditProductPage extends StatefulWidget {
  final int productIndex;
  const EditProductPage({super.key, required this.productIndex});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final ProductController productController = Get.find();

  late final TextEditingController nameController;
  late final TextEditingController priceController;
  File? _image;

  @override
  void initState() {
    super.initState();
    final product = productController.products[widget.productIndex];

    nameController = TextEditingController(text: product['name']);
    priceController = TextEditingController(text: product['price']);
    // Inisialisasi gambar
    _image = null;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = productController.products[widget.productIndex];
    final String currentImage = productController.productImages[widget.productIndex];

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
                child: _image != null
                    ? Image.file(
                        _image!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        currentImage,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 50,
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
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
                    widget.productIndex,
                    name: nameController.text,
                    price: priceController.text,
                    imageFile: _image,
                  );
                  Get.back();
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
