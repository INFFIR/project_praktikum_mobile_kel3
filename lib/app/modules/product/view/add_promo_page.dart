// add_promo_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../product/controllers/promo_controller.dart';
import '../widgets/promo_card.dart';

class AddPromoPage extends StatelessWidget {
  AddPromoPage({super.key});

  final PromoController promoController = Get.find();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController labelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // Tambahkan controller lain jika diperlukan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Promo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            // Tambahkan input lain jika diperlukan
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan promo baru ke controller
                promoController.addPromo(
                  PromoItem(
                    image:
                        'assets/promo/default.jpg', // Gunakan gambar default atau implementasi upload gambar
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
    );
  }
}
