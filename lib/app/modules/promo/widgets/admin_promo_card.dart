import 'package:flutter/material.dart';

class AdminPromoCard extends StatelessWidget {
  final String image; // URL gambar promo
  final String title; // Judul promo
  final String description; // Deskripsi promo
  final VoidCallback onEdit; // Fungsi yang dipanggil saat mengedit
  final VoidCallback onDelete; // Fungsi yang dipanggil saat menghapus

  const AdminPromoCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Menentukan widget gambar
    Widget imageWidget;

    if (image.startsWith('http')) {
      imageWidget = Image.network(
        image,
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

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Column(
        children: [
          // Gambar Promo
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: imageWidget,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Promo
                Text(
                  title.isNotEmpty ? title : 'Judul Promo Tidak Tersedia',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                // Deskripsi Promo
                Text(
                  description.isNotEmpty
                      ? description
                      : 'Deskripsi Tidak Tersedia',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Tombol Edit
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: onEdit,
                    ),
                    // Tombol Hapus
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
