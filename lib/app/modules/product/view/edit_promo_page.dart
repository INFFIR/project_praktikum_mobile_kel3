// edit_promo_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../product/controllers/promo_controller.dart';
import 'dart:io';

import '../widgets/promo_card.dart';

class EditPromoPage extends StatefulWidget {
  final String promoId;

  const EditPromoPage({super.key, required this.promoId});

  @override
  _EditPromoPageState createState() => _EditPromoPageState();
}

class _EditPromoPageState extends State<EditPromoPage> {
  final PromoController promoController = Get.find();

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
    var doc = await promoController.firestore.collection('promos').doc(widget.promoId).get();
    var data = doc.data();
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
      // Tangani error jika terjadi
      print("Error picking image: $e");
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
                  // Update promo di controller
                  await promoController.editPromo(
                    widget.promoId,
                    PromoItem(
                      imageUrl: '', // Akan diisi setelah upload gambar
                      titleText: titleController.text,
                      contentText: contentController.text,
                      promoLabelText: labelController.text,
                      promoDescriptionText: descriptionController.text,
                    ),
                    _image, // Kirim file gambar
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
