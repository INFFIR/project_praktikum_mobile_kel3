// lib/app/promo/views/edit_promo_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/promo_controller.dart';
import '../models/promo_model.dart';

class EditPromoPage extends StatefulWidget {
  final String promoId;
  const EditPromoPage({super.key, required this.promoId});

  @override
  _EditPromoPageState createState() => _EditPromoPageState();
}

class _EditPromoPageState extends State<EditPromoPage> {
  final PromoController promoController = Get.find<PromoController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _image;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    fetchPromoData();
  }

  void fetchPromoData() async {
    final doc = await promoController.firestore
        .collection('promos')
        .doc(widget.promoId)
        .get();
    final data = doc.data();
    if (data != null) {
      titleController.text = data['titleText'] ?? '';
      contentController.text = data['contentText'] ?? '';
      labelController.text = data['promoLabelText'] ?? '';
      descriptionController.text = data['promoDescriptionText'] ?? '';
      setState(() {
        imageUrl = data['imageUrl'];
      });
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
      // Tangani error
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
        title: const Text('Edit Promo'),
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
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Promo',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Konten Promo',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: labelController,
                decoration: const InputDecoration(
                  labelText: 'Label Promo',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Promo',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty ||
                      contentController.text.isEmpty ||
                      labelController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Semua field harus diisi.',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  await promoController.editPromo(
                    widget.promoId,
                    PromoModel(
                      id: widget.promoId,
                      imageUrl: '', // akan di-replace kalau ada upload
                      titleText: titleController.text,
                      contentText: contentController.text,
                      promoLabelText: labelController.text,
                      promoDescriptionText: descriptionController.text,
                    ),
                    _image,
                  );
                  Get.snackbar(
                    'Sukses',
                    'Promo berhasil diperbarui.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
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
