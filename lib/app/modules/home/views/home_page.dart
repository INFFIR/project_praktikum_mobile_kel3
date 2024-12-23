// lib/app/modules/home/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// Controller
import '../../product/controllers/product_controller.dart';
import '../../promo/controllers/promo_controller.dart';

// Widget
import '../../components/bottom_navbar.dart';
import '../../product/widgets/product_card.dart';
import '../../promo/widgets/promo_card.dart'; // Pastikan jalur impor benar

// Lain-lain
import '../../../routes/app_routes.dart';
import '../../services/notification_list_page.dart';
import '../../open_product/view/open_product_page.dart'; // Pastikan jalurnya benar

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil controller
    final promoController = Get.find<PromoController>();
    final productController = Get.find<ProductController>();

    // Controller text
    final TextEditingController searchController = TextEditingController();

    // Speech to text
    final stt.SpeechToText speechToText = stt.SpeechToText();
    bool isListening = false;

    // Inisialisasi BottomNavController
    Get.put(BottomNavController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Menu popup
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              onSelected: (String value) {
                if (value == 'Admin Panel') {
                  Get.toNamed('/home_admin');
                } else if (value == 'Settings') {
                  Get.toNamed(Routes.settings);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'Admin Panel',
                  child: Text('Admin Panel'),
                ),
                const PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
              ],
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
      body: Obx(() {
        // Jika products kosong dan filtered juga kosong
        if (productController.filteredProducts.isEmpty &&
            productController.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Greetings
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

              // Promo Section (1 item per geser), gambar menyesuaikan box
              SizedBox(
                height: 200, // Tinggi area promo (bisa disesuaikan)
                child: PageView.builder(
                  controller: PageController(viewportFraction: 1),
                  scrollDirection: Axis.horizontal,
                  itemCount: promoController.promoItems.length,
                  itemBuilder: (context, index) {
                    final promo = promoController.promoItems[index];
                    return PromoCard(
                      imageUrl: promo.imageUrl,
                      title: promo.titleText,
                      content: promo.contentText,
                      promoLabel: promo.promoLabelText,
                    );
                  },
                ),
              ),

              // Input Pencarian
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) =>
                      productController.filterProducts(value),
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
                              onStatus: (status) =>
                                  debugPrint('STT Status: $status'),
                              onError: (error) =>
                                  debugPrint('STT Error: ${error.errorMsg}'),
                            );
                            if (available) {
                              isListening = true;
                              speechToText.listen(
                                onResult: (result) {
                                  searchController.text =
                                      result.recognizedWords;
                                  productController
                                      .filterProducts(result.recognizedWords);
                                },
                              );
                            }
                          } else {
                            isListening = false;
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
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
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

              // Grid Produk Terfilter
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
                  itemCount: productController.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productController.filteredProducts[index];
                    final productId = product.id;
                    final isFavorited =
                        productController.isFavorited[productId]?.value ??
                            false;

                    return ProductCard(
                      imageUrl: product.imageUrl,
                      name: product.name,
                      price: 'Rp ${product.price}',
                      likes: product.likes,
                      isFavorited: isFavorited,
                      onFavoriteToggle: () {
                        productController.toggleFavorite(index);
                      },
                      onTap: () {
                        // Buka halaman detail product custom
                        Get.to(() => OpenProductPage(productIndex: index));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
