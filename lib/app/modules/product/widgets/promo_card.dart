import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/promo_controller.dart';

// promo_item.dart
class PromoItem {
  final String? id; // id dibuat nullable
  final String imageUrl;
  final String titleText;
  final String contentText;
  final String promoLabelText;
  final String promoDescriptionText;

  PromoItem({
    this.id, // id menjadi opsional
    required this.imageUrl,
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

                final String imageUrl = promoItem.imageUrl;
                final String titleText = promoItem.titleText;
                final String contentText = promoItem.contentText;
                final String promoLabelText = promoItem.promoLabelText;
                final String promoDescriptionText = promoItem.promoDescriptionText;

                Widget imageWidget;

                if (imageUrl.isNotEmpty) {
                  imageWidget = Image.network(
                    imageUrl,
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
                  );
                } else {
                  imageWidget = Image.asset(
                    'assets/promo/default.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                }

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
                      child: imageWidget,
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        color: Colors.red,
                        child: Text(
                          promoLabelText,
                          style:
                              const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Stack(
                        children: [
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
