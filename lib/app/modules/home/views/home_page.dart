// home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../open_product/view/open_product_page.dart';
import '../../product/widgets/product_card.dart';
import '../../product/widgets/promo_card.dart';
import '../../components/bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Daftar promo dengan gambar dan teks yang dapat disesuaikan
  final List<PromoItem> _promoItems = [
    PromoItem(
      image: 'assets/promo/promo1.jpg',
      titleText: 'Promo 1 Detail',
      contentText: 'Enjoy our first promo!',
      promoLabelText: 'Promo 1',
      promoDescriptionText: 'Discount up to 50%',
    ),
    PromoItem(
      image: 'assets/promo/promo2.jpg',
      titleText: 'Promo 2 Detail',
      contentText: 'Don\'t miss our second promo!',
      promoLabelText: 'Promo 2',
      promoDescriptionText: 'Buy 1 Get 1 Free',
    ),
    PromoItem(
      image: 'assets/promo/promo3.jpg',
      titleText: 'Promo 3 Detail',
      contentText: 'Limited time offer!',
      promoLabelText: 'Promo 3',
      promoDescriptionText: 'Free Shipping',
    ),
  ];

  final List<String> _productImages = [
    'assets/product/product0.jpg',
    'assets/product/product1.jpg',
    'assets/product/product2.jpg',
    'assets/product/product3.jpg',
    'assets/product/product4.jpg',
    'assets/product/product5.jpg',
    'assets/product/product0.jpg',
  ];

  final List<Map<String, dynamic>> _products = [
    {'name': 'Splash some color (pink)', 'price': '330K', 'likes': 100},
    {'name': 'Splash some color (white)', 'price': '330K', 'likes': 200},
    {'name': 'Splash some color (yellow)', 'price': '330K', 'likes': 150},
    {'name': 'Splash all color', 'price': '900K', 'likes': 300},
    {'name': 'Splash some color (pink)', 'price': '330K', 'likes': 100},
    {'name': 'Splash some color (white)', 'price': '330K', 'likes': 200},
    {'name': 'Splash some color (pink)', 'price': '330K', 'likes': 100},
  ];

  List<bool> _isFavorited = [];
  late PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0; // Untuk navigasi bottom navbar



  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _isFavorited = List<bool>.filled(_products.length, false);

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && _pageController.page != null) {
        int nextPage = (_pageController.page!.round() + 1) % _promoItems.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
          Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Bagian Hello There
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello There 👋',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'We have what you need!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ),

              // Bagian Promo
              PromoSection(
                promoItems: _promoItems,
                pageController: _pageController,
              ),

              // Bagian Popular Choices
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Popular Choices 🔥',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              // GridView produk
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _products.length,
                  itemBuilder: (context, index) => ProductCard(
                    image: _productImages[index],
                    name: _products[index]['name'],
                    price: 'Rp ${_products[index]['price']}',
                    likes: _products[index]['likes'],
                    isFavorited: _isFavorited[index],
                    onFavoriteToggle: () {
                      setState(() {
                        _isFavorited[index] = !_isFavorited[index];
                        if (_isFavorited[index]) {
                          _products[index]['likes']++;
                        } else {
                          _products[index]['likes']--;
                        }
                      });
                    },
                    onTap: () {
                      Get.to(
                        () => OpenProductPage(
                          productName: _products[index]['name'],
                          productPrice: 'Rp ${_products[index]['price']},-',
                          productLikes: _products[index]['likes'],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),

      );
}
