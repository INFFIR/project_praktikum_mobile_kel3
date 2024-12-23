import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/components/bottom_navbar.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/open_product/view/open_product_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/product/controllers/product_controller.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/product/widgets/product_card.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/promo/controllers/promo_controller.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/promo/widgets/promo_card.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/services/notification_list_page.dart';
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final promoController = Get.find<PromoController>();
    final productController = Get.find<ProductController>();
    final searchController = TextEditingController();
    final speechToText = stt.SpeechToText();
    bool isListening = false;
    Get.put(BottomNavController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.menu, color: Colors.black87),
                offset: const Offset(0, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'Admin Panel',
                    child: Row(
                      children: [
                        const Icon(Icons.admin_panel_settings, size: 20),
                        const SizedBox(width: 12),
                        const Text('Admin Panel'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Settings',
                    child: Row(
                      children: [
                        const Icon(Icons.settings, size: 20),
                        const SizedBox(width: 12),
                        const Text('Settings'),
                      ],
                    ),
                  ),
                ],
                onSelected: (String value) {
                  if (value == 'Admin Panel') {
                    Get.toNamed('/home_admin');
                  } else if (value == 'Settings') {
                    Get.toNamed(Routes.settings);
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.black87),
                onPressed: () => Get.to(() => const NotificationListPage()),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (productController.filteredProducts.isEmpty && productController.products.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello There 👋',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We have what you need!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.93),
                  itemCount: promoController.promoItems.length,
                  itemBuilder: (context, index) {
                    final promo = promoController.promoItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: PromoCard(
                            imageUrl: promo.imageUrl,
                            title: promo.titleText,
                            content: promo.contentText,
                            promoLabel: promo.promoLabelText,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => productController.filterProducts(value),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isListening ? Icons.mic : Icons.mic_none,
                          color: isListening ? Colors.blue : Colors.grey[600],
                        ),
                        onPressed: () async {
                          if (await Permission.microphone.request().isGranted) {
                            if (!isListening) {
                              bool available = await speechToText.initialize(
                                onStatus: (status) => debugPrint('STT Status: $status'),
                                onError: (error) => debugPrint('STT Error: ${error.errorMsg}'),
                              );
                              if (available) {
                                isListening = true;
                                speechToText.listen(
                                  onResult: (result) {
                                    searchController.text = result.recognizedWords;
                                    productController.filterProducts(result.recognizedWords);
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
                              'Microphone permission is required for voice search.',
                              backgroundColor: Colors.red[100],
                              colorText: Colors.red[900],
                              margin: const EdgeInsets.all(16),
                            );
                          }
                        },
                      ),
                      hintText: 'Search products...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Row(
                  children: [
                    const Text(
                      'Popular Choices',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.local_fire_department, color: Colors.orange[700], size: 24),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = productController.filteredProducts[index];
                    final productId = product.id;
                    final isFavorited = productController.isFavorited[productId]?.value ?? false;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ProductCard(
                        imageUrl: product.imageUrl,
                        name: product.name,
                        price: 'Rp ${product.price}',
                        likes: product.likes,
                        isFavorited: isFavorited,
                        onFavoriteToggle: () => productController.toggleFavorite(index),
                        onTap: () => Get.to(() => OpenProductPage(productIndex: index)),
                      ),
                    );
                  },
                  childCount: productController.filteredProducts.length,
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
          ],
        );
      }),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}