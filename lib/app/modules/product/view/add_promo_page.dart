// lib/app/product/view/add_promo_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/views/home_admin_page.dart';

import 'dart:io';

import '../controllers/promo_controller.dart';

class AddPromoPage extends StatefulWidget {
  const AddPromoPage({super.key});

  @override
  _AddPromoPageState createState() => _AddPromoPageState();
}

class _AddPromoPageState extends State<AddPromoPage> {
  final PromoController promoController = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = pickedFile != null ? File(pickedFile.path) : null;
      });
    } catch (e) {
      // Tangani error jika terjadi
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Promo'),
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
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Promo',
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Konten Promo',
                ),
              ),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'Label Promo',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Promo',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Validasi input
                  if (titleController.text.isEmpty ||
                      contentController.text.isEmpty ||
                      labelController.text.isEmpty ||
                      descriptionController.text.isEmpty ||
                      _image == null) {
                    Get.snackbar(
                      'Error',
                      'Semua field harus diisi dan gambar harus dipilih.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  // Tambahkan promo baru ke controller
                  await promoController.addPromo(
                    PromoItem(
                      imageUrl: '', // Akan diisi setelah upload gambar
                      titleText: titleController.text,
                      contentText: contentController.text,
                      promoLabelText: labelController.text,
                      promoDescriptionText: descriptionController.text,
                    ),
                    _image, // Kirim file gambar
                  );

                  // Tampilkan notifikasi snackbar
                  Get.snackbar(
                    'Sukses',
                    'Promo berhasil ditambahkan.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );

                  // Kembali ke halaman sebelumnya
                  Get.off(()=>const HomeAdminPage());
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
