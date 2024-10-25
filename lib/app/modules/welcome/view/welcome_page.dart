import 'package:flutter/material.dart';
import 'package:get/get.dart';
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Static Image instead of Image Picker
              Image.asset(
                'assets/promo/promo1.jpg', // Replace with your image asset path
                height: 150,
              ),
              const SizedBox(height: 20),

              // Store Name
              const Text(
                'SM Vape Store',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              // Location
              const Text(
                'Malang',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),

              // Catchphrase
              const Text(
                'IM NOT SMOKING\nIM VAPING\nNO NIC NO LIFE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Vape Store kami adalah toko yang menyediakan beragam produk vape berkualitas...',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 40),

              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  // Add navigation logic or other actions here
                  Get.toNamed("/login");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: const Text(
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
