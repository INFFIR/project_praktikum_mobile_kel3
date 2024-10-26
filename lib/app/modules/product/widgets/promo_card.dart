// promo_section.dart
import 'package:flutter/material.dart';

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
  final List<PromoItem> promoItems;
  final PageController pageController;

  const PromoSection({
    super.key,
    required this.promoItems,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Menambahkan margin 25 di segala sudut
      padding: const EdgeInsets.all(25.0),
      child: SizedBox(
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25), // Menambahkan border radius 25
          child: PageView.builder(
            controller: pageController,
            itemCount: promoItems.length,
            itemBuilder: (context, index) {
              final promoItem = promoItems[index];
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(promoItem.titleText),
                        content: Text(promoItem.contentText),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                    child: Image.asset(
                      promoItem.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity, // Pastikan gambar mengisi ruang
                    ),
                  ),
                  // Bagian promoLabelText tetap seperti semula
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      color: Colors.red,
                      child: Text(
                        promoItem.promoLabelText,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
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
                          promoItem.promoDescriptionText,
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
                          promoItem.promoDescriptionText,
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
    );
  }
}
