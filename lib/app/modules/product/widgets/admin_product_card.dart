// lib/app/modules/product/widgets/admin_product_card.dart
import 'package:flutter/material.dart';
import 'dart:io';

class AdminProductCard extends StatelessWidget {
  final String image;
  final String name;
  final String price;
  final String description; // Menambahkan deskripsi
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminProductCard({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.description, // Menambahkan deskripsi
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (image.startsWith('assets/')) {
      // Memuat gambar dari assets
      imageWidget = Image.asset(
        image,
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
    } else if (image.startsWith('http')) {
      // Memuat gambar dari URL jaringan
      imageWidget = Image.network(
        image,
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
        File(image),
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

    return Card(
      child: Column(
        children: [
          Expanded(child: imageWidget),
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
                const SizedBox(height: 4),
                Text(
                  description.isNotEmpty ? description : 'Tidak ada deskripsi',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1, // Membatasi ke satu baris
                  overflow: TextOverflow.ellipsis, // Menambahkan elipsis
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
