// lib/app/modules/home_admin_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller & Model
import 'package:project_praktikum_mobile_kel3/app/modules/product/controllers/product_controller.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/promo/controllers/promo_controller.dart';

// Widgets
import 'package:project_praktikum_mobile_kel3/app/modules/product/widgets/admin_product_card.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/promo/widgets/admin_promo_card.dart';

// Services
import 'package:project_praktikum_mobile_kel3/app/modules/services/notification_list_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/services/notification_service.dart';

// Routes
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  final productController = Get.find<ProductController>();
  final promoController = Get.find<PromoController>();
  final notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.init();
  }

  void _addNewProduct() {
    // Panggil route '/product-add'
    Get.toNamed(Routes.productAdd);
    // atau langsung string: Get.toNamed('/product-add');
  }

  void _addNewPromo() {
    // Jika Anda punya route untuk menambah promo, misalnya '/promo-add':
    Get.toNamed('/promo-add');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Get.to(() => const NotificationListPage()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tombol notifikasi
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => notificationService.triggerForegroundNotification(),
                    child: const Text('Trigger Notifikasi Foreground'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      notificationService.triggerBackgroundNotification();
                      Get.snackbar(
                        'Notifikasi Background Dijadwalkan',
                        'Minimalkan aplikasi untuk menguji notifikasi background.',
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                    child: const Text('Trigger Notifikasi Background'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      notificationService.triggerTerminatedNotification();
                      Get.snackbar(
                        'Notifikasi Terminated Dijadwalkan',
                        'Tutup aplikasi untuk menguji notifikasi terminated.',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    },
                    child: const Text('Trigger Notifikasi Terminated'),
                  ),
                ],
              ),
            ),

            // Manage Products
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Manage Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Grid Products
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
                  itemCount: productController.products.length,
                  itemBuilder: (context, index) {
                    final product = productController.products[index];
                    return AdminProductCard(
                      image: product.imageUrl,
                      name: product.name,
                      price: 'Rp ${product.price}',
                      onEdit: () {
                        // Panggil route '/product-edit?productId=xxx'
                        Get.toNamed('${Routes.productEdit}?productId=${product.id}');
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Hapus Produk'),
                            content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  productController.deleteProduct(product.id);
                                  Get.back();
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),

            // Manage Promotions
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Manage Promotions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Grid Promo
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
                  itemCount: promoController.promoItems.length,
                  itemBuilder: (context, index) {
                    final promo = promoController.promoItems[index];
                    return AdminPromoCard(
                      image: promo.imageUrl,
                      title: promo.titleText,
                      description: promo.promoDescriptionText,
                      onEdit: () {
                        // Misal route '/promo-edit?promoId=xxx'
                        Get.toNamed('/promo-edit?promoId=${promo.id}');
                      },
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Hapus Promo'),
                            content: const Text('Apakah Anda yakin ingin menghapus promo ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  promoController.deletePromo(promo.id);
                                  Get.back();
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pilihan: tambah produk atau tambah promo
          showModalBottomSheet(
            context: context,
            builder: (ctx) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.add_box),
                  title: const Text('Tambah Produk'),
                  onTap: () {
                    Get.back();
                    _addNewProduct();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_offer),
                  title: const Text('Tambah Promo'),
                  onTap: () {
                    Get.back();
                    _addNewPromo();
                  },
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
