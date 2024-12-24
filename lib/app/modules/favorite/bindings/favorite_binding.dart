// lib/app/favorite/bindings/favorite_binding.dart
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../../product/controllers/product_controller.dart';

class FavoriteBinding extends Bindings {
  @override
  void dependencies() {
    // Inisialisasi ProductController secara langsung jika belum diinisialisasi
    if (!Get.isRegistered<ProductController>()) {
      Get.put<ProductController>(ProductController(), permanent: true);
      print("ProductController telah diinisialisasi dalam FavoriteBinding");
    }

    // Inisialisasi FavoriteController
    if (!Get.isRegistered<FavoriteController>()) {
      Get.put<FavoriteController>(FavoriteController());
      print("FavoriteController telah diinisialisasi dalam FavoriteBinding");
    }
  }
}
