import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeController controller =
        Get.find<HomeController>(); // Ambil controller menggunakan Get.find()

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  controller.pickImage(); // Ambil gambar saat logo di-tap
                },
                child: Obx(() {
                  // Observer untuk perubahan gambar
                  return controller.image.value != null
                      ? Image.file(
                          controller.image.value!,
                          height: 150,
                        )
                      : Image.asset(
                          'assets/logo_vape_store.png', // Gambar default
                          height: 150,
                        );
                }),
              ),
              SizedBox(height: 20),

              // Nama Toko
              Text(
                'SM Vape Store',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),

              // Lokasi
              Text(
                'Malang',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),

              // Catchphrase
              Text(
                'IM NOT SMOKING\nIM VAPING\nNO NIC NO LIFE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Deskripsi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Vape Store kami adalah toko yang menyediakan beragam produk vape berkualitas...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              SizedBox(height: 40),

              // Tombol Get Started
              ElevatedButton(
                onPressed: () {
                  // Tambahkan logika untuk navigasi atau aksi lain
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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