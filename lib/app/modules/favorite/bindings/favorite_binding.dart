// lib/app/favorite/bindings/favorite_binding.dart
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../../product/controllers/product_controller.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    // Inisialisasi ProductController jika belum diinisialisasi
    if (!Get.isRegistered<ProductController>()) {
      Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    }
    
    // Inisialisasi FavoriteController
    Get.lazyPut<FavoriteController>(() => FavoriteController());
  }
}
