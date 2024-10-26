// product_card.dart
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final int likes;
  final bool isFavorited;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap; // Parameter baru untuk navigasi

  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.likes,
    required this.isFavorited,
    required this.onFavoriteToggle,
    required this.onTap, // Parameter baru
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Menggunakan onTap untuk navigasi
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
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
