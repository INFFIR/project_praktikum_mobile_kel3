import 'package:flutter/material.dart';

class PromoCard extends StatelessWidget {
  final String imageUrl;    // URL gambar promo
  final String title;       // Judul promo
  final String content;     // Konten / deskripsi singkat
  final String promoLabel;  // Label promo (misal "Diskon 50%")

  const PromoCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.promoLabel,
  });

  @override
  Widget build(BuildContext context) {
    // Pilih imageWidget sesuai URL
    final Widget imageWidget;
    if (imageUrl.startsWith('http')) {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover, // Memenuhi area
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/promo/default.jpg',
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      imageWidget = Image.asset(
        'assets/promo/default.jpg',
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      width: 300,     // Tetap definisikan lebar & tinggi luar (opsional)
      height: 180,    // Anda bisa mengganti ke AspectRatio untuk lebih responsif
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          // Stack untuk menumpuk gambar + label + judul
          child: Stack(
            children: [
              // Gambar menutupi seluruh card
              Positioned.fill(child: imageWidget),

              // Label promo di sisi atas
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  color: Colors.red,
                  child: Text(
                    promoLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // Judul di sisi bawah
              Positioned(
                bottom: 16,
                left: 16,
                right: 16, // Agar teks menyesuaikan lebar card
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
