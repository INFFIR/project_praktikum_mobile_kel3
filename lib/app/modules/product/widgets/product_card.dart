// lib/app/product/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'dart:io';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final int likes;
  final bool isFavorited;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.likes,
    required this.isFavorited,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (imageUrl.startsWith('assets/')) {
      // Memuat gambar dari assets
      imageWidget = Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/product/default.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      );
    } else if (imageUrl.startsWith('http')) {
      // Memuat gambar dari URL jaringan
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/product/default.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      );
    } else {
      // Memuat gambar dari file lokal
      imageWidget = Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/product/default.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        },
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Mengatur ukuran Column sesuai konten
          children: [
            Flexible(
              fit: FlexFit.loose, // Mengganti Expanded dengan Flexible
              child: imageWidget,
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
                    price.isNotEmpty ? price : 'Harga Tidak Detersedia',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : null,
                        ),
                        onPressed: onFavoriteToggle,
                      ),
                      Text('$likes'),
                    ],
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
