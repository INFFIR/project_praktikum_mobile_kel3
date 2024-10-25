import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpenProductPage extends StatelessWidget {
  final String productName;
  final String productPrice;
  final int productLikes;

  const OpenProductPage({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productLikes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            IconData(0xe094, fontFamily: 'MaterialIcons', matchTextDirection: true),
            color: Colors.black,
          ),
          onPressed: () {
            Get.back(); // Menggunakan GetX untuk kembali ke halaman sebelumnya
          },
        ),
        title: const Text('Splash Some Color'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Times New Roman',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              print('Favorite icon pressed');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/promo/promo1.jpg'), // Ganti dengan jalur aset gambar Anda
                  fit: BoxFit.cover,
                ),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 16),
            Text(
              productPrice,
              style: const TextStyle(fontSize: 40, color: Colors.black, fontFamily: 'Times New Roman'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Specifications',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              '\t\t\t\t Attractive design and colors\n'
              '\t\t\t\t Battery built-in 800mah battery\n'
              '\t\t\t\t Airflow adjustable\n'
              '\t\t\t\t Type C fast charging productnation',
              style: TextStyle(fontSize: 17, color: Colors.black, fontFamily: 'Times New Roman'),
            ),
            const SizedBox(height: 60),
ElevatedButton(
  onPressed: () {
    // Tambahkan tindakan yang ingin dilakukan saat tombol ditekan di sini.
    Get.toNamed("/detail_product"); // Use Get.to() for navigation
   
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    backgroundColor: Colors.black, // Ubah warna tombol sesuai kebutuhan
    side: const BorderSide(color: Colors.black54), // Warna border
  ),
  child: const Text(
    'Buy Now',
    style: TextStyle(
      fontSize: 18,
      color: Colors.white, // Ubah warna teks sesuai kebutuhan
      fontWeight: FontWeight.bold,
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
