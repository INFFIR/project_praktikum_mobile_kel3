// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../routes/app_routes.dart';
import '../../components/bottom_navbar.dart';
import '../../open_product/view/open_product_page.dart';
import '../../product/controllers/product_controller.dart';
import '../../product/controllers/promo_controller.dart';
import '../../product/widgets/promo_card.dart';
import '../../product/widgets/product_card.dart'; // Ensure correct import if needed
import 'home_admin_page.dart';
import '../../services/notification_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PromoController promoController = Get.put(PromoController());
  final ProductController productController = Get.put(ProductController());
  int _currentIndex = 0;

  // Controller untuk input pencarian
  final TextEditingController searchController = TextEditingController();

  // State untuk speech-to-text
  late stt.SpeechToText speechToText;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    speechToText = stt.SpeechToText();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu), // Three-line menu icon
              onSelected: (String value) {
                if (value == 'Admin Panel') {
                  Get.to(() => const HomeAdminPage());
                } else if (value == 'Settings') {
                  // Use named route to ensure bindings are applied
                  Get.toNamed(Routes.settings);
                  // Alternatively, you can use:
                  // Get.to(() => const SettingsPage(), binding: SettingsBinding());
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Admin Panel',
                    child: Text('Admin Panel'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Settings',
                    child: Text('Settings'),
                  ),
                ];
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Get.to(() => const NotificationListPage());
              },
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

            // Search Input with speech-to-text
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  productController.filterProducts(value);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      if (await Permission.microphone.request().isGranted) {
                        if (!isListening) {
                          bool available = await speechToText.initialize(
                            onStatus: (status) {
                              print('SpeechToText Status: $status');
                            },
                            onError: (error) {
                              print('SpeechToText Error: ${error.errorMsg}');
                            },
                          );

                          if (available) {
                            setState(() {
                              isListening = true;
                            });
                            speechToText.listen(
                              onResult: (result) {
                                setState(() {
                                  searchController.text =
                                      result.recognizedWords;
                                  productController
                                      .filterProducts(result.recognizedWords);
                                });
                              },
                            );
                          }
                        } else {
                          setState(() {
                            isListening = false;
                          });
                          speechToText.stop();
                        }
                      } else {
                        Get.snackbar(
                          'Permission Denied',
                          'Microphone permission is required to use voice search.',
                        );
                      }
                    },
                  ),
                  hintText: 'Search',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),

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

            // Filtered Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(
                () => GridView.builder(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: productController.filteredProducts.length,
                  itemBuilder: (context, index) {
                    var product = productController.filteredProducts[index];
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
                        Get.to(() => OpenProductPage(productIndex: index));
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
}
