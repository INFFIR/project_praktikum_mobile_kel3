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
import '../../product/widgets/product_card.dart'; // Pastikan impor benar
import 'home_admin_page.dart';
import '../../services/notification_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoController promoController = Get.put(PromoController());
    final ProductController productController = Get.put(ProductController());
    final RxInt _currentIndex = 0.obs; // Menggunakan RxInt untuk state

    // Controller untuk input pencarian
    final TextEditingController searchController = TextEditingController();

    // State untuk speech-to-text
    late stt.SpeechToText speechToText;
    bool isListening = false;

    // Init speech-to-text
    speechToText = stt.SpeechToText();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu), // Ikon menu tiga garis
              onSelected: (String value) {
                if (value == 'Admin Panel') {
                  Get.to(() => const HomeAdminPage());
                } else if (value == 'Settings') {
                  // Gunakan rute bernama untuk memastikan binding diterapkan
                  Get.toNamed(Routes.settings);
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
      body: Obx(() {
        // Cek apakah products dan isFavorited sudah terisi
        if (productController.filteredProducts.isEmpty &&
            productController.products.isEmpty) {
          // Tampilkan indikator pemuatan jika data belum dimuat
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
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

              // Input Pencarian dengan speech-to-text
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
                    var product = productController.filteredProducts[index];
                    String productId = product['id'] as String;
                    return ProductCard(
                      imageUrl: product['imageUrl'] ?? '',
                      name: product['name'] ?? 'Nama Produk Tidak Tersedia',
                      price: 'Rp ${product['price'] ?? 'Harga Tidak Tersedia'}',
                      likes: product['likes'] ?? 0,
                      isFavorited:
                          productController.isFavorited[productId]?.value ?? false,
                      onFavoriteToggle: () {
                        productController.toggleFavorite(index);
                      },
                      onTap: () {
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
      bottomNavigationBar: Obx(
        () => BottomNavBar(
          currentIndex: _currentIndex.value, // Gunakan .value untuk RxInt
          onTap: (index) {
            _currentIndex.value = index; // Update currentIndex dengan RxInt
          },
        ),
      ),
    );
  }
}