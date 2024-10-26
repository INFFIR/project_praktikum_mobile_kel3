import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/promo_controller.dart';

class PromoItem {
  final String image;
  final String titleText;
  final String contentText;
  final String promoLabelText;
  final String promoDescriptionText;

  PromoItem({
    required this.image,
    required this.titleText,
    required this.contentText,
    required this.promoLabelText,
    required this.promoDescriptionText,
  });
}

class PromoSection extends StatelessWidget {
  const PromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoController promoController = Get.find();
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(25.0),
        child: SizedBox(
          height: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: PageView.builder(
              controller: promoController.pageController,
              itemCount: promoController.promoItems.length,
              itemBuilder: (context, index) {
                final promoItem = promoController.promoItems[index];

                // Menangani data yang hilang
                final String imagePath = promoItem.image.isNotEmpty
                    ? promoItem.image
                    : 'assets/promo/default.jpg'; // Gambar default promo
                final String titleText = promoItem.titleText.isNotEmpty
                    ? promoItem.titleText
                    : 'Promo Title';
                final String contentText = promoItem.contentText.isNotEmpty
                    ? promoItem.contentText
                    : 'Promo Content';
                final String promoLabelText = promoItem.promoLabelText.isNotEmpty
                    ? promoItem.promoLabelText
                    : 'Promo Label';
                final String promoDescriptionText = promoItem.promoDescriptionText.isNotEmpty
                    ? promoItem.promoDescriptionText
                    : 'Promo Description';

                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(titleText),
                          content: Text(contentText),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/promo/default.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          );
                        },
                      ),
                    ),
                    // Bagian promoLabelText
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        color: Colors.red,
                        child: Text(
                          promoLabelText,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    // Bagian promoDescriptionText dengan stroke hitam
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Stack(
                        children: [
                          // Teks dengan stroke hitam
                          Text(
                            promoDescriptionText,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 2
                                ..color = Colors.black,
                            ),
                          ),
                          // Teks isi berwarna putih
                          Text(
                            promoDescriptionText,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
