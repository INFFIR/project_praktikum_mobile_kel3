// lib/app/favorite/views/favorite_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../home/views/home_admin_page.dart';
import '../../open_product/view/open_product_page.dart';
import '../../product/widgets/product_card.dart';
import '../../services/notification_list_page.dart';
import '../controllers/favorite_controller.dart';
import '../../components/bottom_navbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.find();

    // Controller untuk input pencarian
    final TextEditingController searchController = TextEditingController();

    // Inisialisasi speech_to_text
    final stt.SpeechToText speechToText = stt.SpeechToText();

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
        // Cek apakah favoriteProducts kosong
        if (favoriteController.favoriteProducts.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada produk favorit.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hello There 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
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
              // Tidak ada PromoSection

              // Input Pencarian dengan speech-to-text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    favoriteController.filterFavoriteProducts(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: Obx(() => IconButton(
                          icon: Icon(
                            favoriteController.isListening.value ? Icons.mic : Icons.mic_none,
                            color: favoriteController.isListening.value ? Colors.red : Colors.grey,
                          ),
                          onPressed: () async {
                            if (await Permission.microphone.request().isGranted) {
                              if (!favoriteController.isListening.value) {
                                bool available = await speechToText.initialize(
                                  onStatus: (status) {
                                    print('SpeechToText Status: $status');
                                  },
                                  onError: (error) {
                                    print('SpeechToText Error: ${error.errorMsg}');
                                  },
                                );

                                if (available) {
                                  favoriteController.isListening.value = true;
                                  speechToText.listen(
                                    onResult: (result) {
                                      searchController.text = result.recognizedWords;
                                      favoriteController.filterFavoriteProducts(result.recognizedWords);
                                    },
                                  );
                                }
                              } else {
                                favoriteController.isListening.value = false;
                                speechToText.stop();
                              }
                            } else {
                              Get.snackbar(
                                'Permission Denied',
                                'Microphone permission is required to use voice search.',
                              );
                            }
                          },
                        )),
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
                      'Your Favorites ❤️',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),

              // Grid Produk Favorit yang Difilter
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
                  itemCount: favoriteController.filteredFavoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = favoriteController.filteredFavoriteProducts[index];
                    return ProductCard(
                      imageUrl: product['imageUrl'] ?? '',
                      name: product['name'] ?? 'Nama Produk Tidak Tersedia',
                      price: product['price'] != null
                          ? 'Rp ${product['price'].toString()}'
                          : 'Harga Tidak Tersedia',
                      likes: product['likes'] ?? 0,
                      isFavorited: true, // Produk di sini sudah difavoritkan
                      onFavoriteToggle: () {
                        favoriteController.removeFavorite(product['id']);
                      },
                      onTap: () {
                        // Navigasi ke detail produk jika diperlukan
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
      // Hapus Obx dari bottomNavigationBar
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Set currentIndex ke 1 untuk Favorite
        onTap: (index) {
          // Navigasi berdasarkan index yang dipilih
          switch (index) {
            case 0:
              Get.offNamed(Routes.home);
              break;
            case 1:
              // Sudah di Favorite, tidak perlu navigasi
              break;
            case 2:
              Get.offNamed(Routes.location);
              break;
            case 3:
              Get.offNamed(Routes.profile);
              break;
          }
        },
      ),
    );
  }
}
