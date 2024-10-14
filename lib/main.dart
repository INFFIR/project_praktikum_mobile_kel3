import 'package:flutter/material.dart';
import './app/modules/home/views/home_page.dart'; // Import halaman utama dari file home_page.dart

// Fungsi utama aplikasi
void main() {
  runApp(const MyApp());
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Mobile', // Judul aplikasi
      theme: ThemeData(primarySwatch: Colors.blue), // Tema aplikasi
      home: const MyHomePage(), // Halaman awal aplikasi diambil dari home_page.dart
    );
  }
}
