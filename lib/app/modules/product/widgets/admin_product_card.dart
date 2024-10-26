// admin_product_card.dart
import 'package:flutter/material.dart';

class AdminProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String displayImage =
        image.isNotEmpty ? image : 'assets/product/default.jpg';

    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              displayImage,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
