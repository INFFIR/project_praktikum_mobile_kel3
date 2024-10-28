import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/bottom_navbar.dart';
import '../../open_product/view/open_product_page.dart';
import '../../product/controllers/product_controller.dart';
import '../../product/controllers/promo_controller.dart';
import '../../product/widgets/product_card.dart';
import '../../product/widgets/promo_card.dart';
import 'home_admin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PromoController promoController = Get.put(PromoController());
  final ProductController productController = Get.put(ProductController());
  int _currentIndex = 0;

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
                onPressed: () {
                  Get.to(() => const HomeAdminPage());
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => Get.toNamed('/profile'),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
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
              const PromoSection(), 

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () => GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      var product = productController.products[index];
                      return ProductCard(
                        imageUrl: product['imageUrl'] ?? '',
                        name: product['name'] ?? 'Nama Produk Tidak Tersedia',
                        price: 'Rp ${product['price'] ?? 'Harga Tidak Tersedia'}',
                        likes: RxInt(product['likes'] ?? 0),
                        isFavorited: productController.isFavorited[index],
                        onFavoriteToggle: () {
                          final userId = 'current_user_id';
                          productController.toggleFavorite(index, userId);
                        },
                        onTap: () {
                          Get.to(
                            () => OpenProductPage(
                              productIndex: index,
                            ),
                          );
                        },
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
