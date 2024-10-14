import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import untuk menggunakan tipe data File

// Widget Stateful untuk halaman utama
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// State untuk MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker(); // Instance ImagePicker untuk memilih gambar

  // List untuk menyimpan gambar promo, dimulai dengan nilai null sebagai placeholder
  final List<File?> _promoImages = List<File?>.filled(3, null);

  // List untuk menyimpan gambar produk, dimulai dengan nilai null sebagai placeholder
  final List<File?> _productImages = List<File?>.filled(6, null);

  // Daftar produk dengan nama dan harga
  final List<Map<String, dynamic>> _products = [
    {'name': 'Produk A', 'price': 'Rp 50.000', 'likes': 100},
    {'name': 'Produk B', 'price': 'Rp 75.000', 'likes': 200},
    {'name': 'Produk C', 'price': 'Rp 100.000', 'likes': 150},
    {'name': 'Produk D', 'price': 'Rp 125.000', 'likes': 300},
    {'name': 'Produk E', 'price': 'Rp 150.000', 'likes': 250},
    {'name': 'Produk F', 'price': 'Rp 200.000', 'likes': 400},
  ];

  // Status apakah produk difavoritkan
  final List<bool> _isFavorited = List<bool>.filled(6, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Mobile'), // Judul di AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Tambahkan aksi untuk tombol profile jika diperlukan
            },
          ),
        ],
      ),
      // Isi utama halaman menggunakan SingleChildScrollView untuk scrollable layout
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPromoBanner(), // Membangun bagian promo banner
            _buildProductGrid(), // Membangun bagian grid produk
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun widget promo banner
  Widget _buildPromoBanner() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        itemCount: _promoImages.length, // Jumlah halaman sesuai dengan panjang _promoImages
        itemBuilder: (context, index) {
          return Stack(
            children: [
              // Menampilkan gambar promo, baik dari file atau gambar default
              _promoImages[index] != null
                  ? Image.file(
                      _promoImages[index]!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.asset(
                      'assets/promo/promo${index + 1}.jpg',
                    ),
              // Tombol untuk mengganti gambar promo
              Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                  onPressed: () => _pickImage(index), // Memanggil fungsi _pickImage
                  child: const Text('Ganti Gambar'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Fungsi untuk membangun grid produk
  Widget _buildProductGrid() {
    return GridView.builder(
      shrinkWrap: true, // Agar GridView mengikuti konten
      physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scroll di dalam GridView
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Jumlah kolom dalam grid
        childAspectRatio: 1, // Rasio aspek untuk item grid
      ),
      itemCount: _productImages.length, // Jumlah item produk
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Expanded(
                // Menampilkan gambar produk, baik dari file atau gambar default
                child: _productImages[index] != null
                    ? Image.file(
                        _productImages[index]!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Image.asset(
                        'assets/product/product$index.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
              Text(_products[index]['name']), // Nama produk dari daftar
              Text(_products[index]['price']), // Harga produk dari daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isFavorited[index] ? Icons.favorite : Icons.favorite_border, // Ikon berubah saat ditekan
                      color: _isFavorited[index] ? Colors.red : null, // Ubah warna jika difavoritkan
                    ),
                    onPressed: () {
                      setState(() {
                        _isFavorited[index] = !_isFavorited[index]; // Toggle status favorit
                        if (_isFavorited[index]) {
                          _products[index]['likes']++; // Tambah jumlah like
                        } else {
                          _products[index]['likes']--; // Kurangi jumlah like
                        }
                      });
                    },
                  ),
                  Text('${_products[index]['likes']}'), // Jumlah like produk
                ],
              ),
              // Tombol untuk mengganti gambar produk
              ElevatedButton(
                onPressed: () => _pickProductImage(index), // Memanggil fungsi _pickProductImage
                child: const Text('Ganti Gambar'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk memilih gambar promo dari galeri
  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _promoImages[index] = File(pickedFile.path); // Menyimpan gambar ke list _promoImages
      });
    }
  }

  // Fungsi untuk memilih gambar produk dari galeri
  Future<void> _pickProductImage(int index) async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productImages[index] = File(pickedFile.path); // Menyimpan gambar ke list _productImages
      });
    }
  }
}
