import 'package:flutter/material.dart';

class OpenProductPage extends StatelessWidget {
  const OpenProductPage({super.key});

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
            Navigator.pop(context);
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
            // Static Image instead of ImagePicker
            Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/promo/promo1.jpg'), // Replace with your image asset path
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
            const Text(
              'Rp.330.000,-',
              style: TextStyle(fontSize: 40, color: Colors.black, fontFamily: 'Times New Roman'),
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
            Container(
              width: 250,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.0),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black54),
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
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
