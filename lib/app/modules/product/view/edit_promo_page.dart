// edit_promo_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../product/controllers/promo_controller.dart';
import 'dart:io';

import '../widgets/promo_card.dart';

class EditPromoPage extends StatefulWidget {
  final int promoIndex;
  const EditPromoPage({super.key, required this.promoIndex});

  @override
  _EditPromoPageState createState() => _EditPromoPageState();
}

class _EditPromoPageState extends State<EditPromoPage> {
  final PromoController promoController = Get.find();

  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final TextEditingController labelController;
  late final TextEditingController descriptionController;
  File? _image;

  @override
  void initState() {
    super.initState();
    final promo = promoController.promoItems[widget.promoIndex];

    titleController = TextEditingController(text: promo.titleText);
    contentController = TextEditingController(text: promo.contentText);
    labelController = TextEditingController(text: promo.promoLabelText);
    descriptionController = TextEditingController(text: promo.promoDescriptionText);
    _image = null;
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
    final promo = promoController.promoItems[widget.promoIndex];
    final String currentImage = promo.image;

    Widget imageWidget;

    if (_image != null) {
      imageWidget = Image.file(
        _image!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (currentImage.startsWith('assets/')) {
      imageWidget = Image.asset(
        currentImage,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Image.file(
        File(currentImage),
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
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
                onPressed: () {
                  // Update promo di controller
                  promoController.editPromo(
                    widget.promoIndex,
                    PromoItem(
                      image: _image != null
                          ? _image!.path
                          : promo.image,
                      titleText: titleController.text,
                      contentText: contentController.text,
                      promoLabelText: labelController.text,
                      promoDescriptionText: descriptionController.text,
                    ),
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
