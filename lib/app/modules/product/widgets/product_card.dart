import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final RxInt likes;
  final RxBool isFavorited;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.likes,
    required this.isFavorited,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Gambar default jika gambar tidak ditemukan
    final String displayImage = image.isNotEmpty ? image : 'assets/product/default.jpg';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                displayImage,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  // Menampilkan gambar default jika terjadi error
                  return Image.asset(
                    'assets/product/default.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price.isNotEmpty ? price : 'Harga Tidak Tersedia',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorited.value ? Icons.favorite : Icons.favorite_border,
                            color: isFavorited.value ? Colors.red : null,
                          ),
                          onPressed: onFavoriteToggle,
                        ),
                        Text('${likes.value}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
