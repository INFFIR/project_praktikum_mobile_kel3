// home_admin_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../product/controllers/product_controller.dart';
import '../../product/view/add_product_page.dart';
import '../../product/view/add_promo_page.dart';
import '../../product/view/edit_product_page.dart';
import '../../product/widgets/admin_product_card.dart';
import '../../components/bottom_navbar.dart';
import '../../product/controllers/promo_controller.dart';


class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({super.key});

  @override
  _HomeAdminPageState createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  final PromoController promoController = Get.find();
  final ProductController productController = Get.find();
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _addNewProduct() {
    Get.to(() => AddProductPage());
  }

  void _addNewPromo() {
    Get.to(() => AddPromoPage());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Bagian Produk
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
              // GridView produk
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
                    itemBuilder: (context, index) => AdminProductCard(
                      image: productController.productImages[index],
                      name: productController.products[index]['name'],
                      price:
                          'Rp ${productController.products[index]['price']}',
                      onEdit: () {
                        // Navigasi ke halaman edit produk
                        Get.to(() => EditProductPage(productIndex: index));
                      },
                      onDelete: () {
                        // Konfirmasi sebelum menghapus
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Hapus Produk'),
                            content: const Text(
                                'Apakah Anda yakin ingin menghapus produk ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () {
                                  productController.deleteProduct(index);
                                  Get.back();
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Tampilkan dialog untuk memilih antara menambah produk atau promo
            showModalBottomSheet(
              context: context,
              builder: (context) => Column(
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
