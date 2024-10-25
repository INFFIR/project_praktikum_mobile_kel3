import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:project_praktikum_mobile_kel3/app/modules/open_product/view/open_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _promoImages = [
    'assets/promo/promo1.jpg',
    'assets/promo/promo2.jpg',
    'assets/promo/promo3.jpg',
  ];

  final List<String> _productImages = [
    'assets/product/product0.jpg',
    'assets/product/product1.jpg',
    'assets/product/product2.jpg',
    'assets/product/product3.jpg',
    'assets/product/product4.jpg',
    'assets/product/product5.jpg',
  ];

  final List<Map<String, dynamic>> _products = [
    {'name': 'Produk A', 'price': 'Rp 50.000', 'likes': 100},
    {'name': 'Produk B', 'price': 'Rp 75.000', 'likes': 200},
    {'name': 'Produk C', 'price': 'Rp 100.000', 'likes': 150},
    {'name': 'Produk D', 'price': 'Rp 125.000', 'likes': 300},
    {'name': 'Produk E', 'price': 'Rp 150.000', 'likes': 250},
    {'name': 'Produk F', 'price': 'Rp 200.000', 'likes': 400},
  ];

  final List<bool> _isFavorited = List<bool>.filled(6, false);
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.page!.round() < _promoImages.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.jumpToPage(0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Mobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Profile button action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPromoSection(),
            _buildProductGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Hello there",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        _buildPromoBanner(),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Popular choice",
            style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _promoImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showPromoDetails();
            },
            child: Image.asset(
              _promoImages[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }

Widget _buildProductGrid() {
  return GridView.builder(
    padding: const EdgeInsets.all(20.0), // Padding untuk GridView
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
    ),
    itemCount: _productImages.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(5.0), // Padding di sekitar setiap kartu
        child: GestureDetector(
          onTap: () {
            _showProductDetails(index);
          },
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    _productImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(_products[index]['name']),
                      Text(_products[index]['price']),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isFavorited[index]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorited[index] ? Colors.red : null,
                            ),
                            onPressed: () {
                              setState(() {
                                _isFavorited[index] = !_isFavorited[index];
                                if (_isFavorited[index]) {
                                  _products[index]['likes']++;
                                } else {
                                  _products[index]['likes']--;
                                }
                              });
                            },
                          ),
                          Text('${_products[index]['likes']}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}



  void _showPromoDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Promo Detail"),
          content: const Text("This is a special promo just for you!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

void _showProductDetails(int index) {
  Get.to(
    () => OpenProductPage(
      productName: _products[index]['name'],
      productPrice: 'Rp.${_products[index]['price']},-',
      productLikes: _products[index]['likes'],
    ),
  );
}
}
