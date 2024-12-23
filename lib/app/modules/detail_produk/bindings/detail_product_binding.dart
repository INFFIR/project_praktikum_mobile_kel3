// lib/app/modules/detail_produk/bindings/detail_product_binding.dart

import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/controllers/detail_product_controller.dart';

class DetailProductBindings extends Bindings {
  @override
  void dependencies() {
    // Extract productId from navigation arguments
    final args = Get.arguments as Map<String, dynamic>;
    final productId = args['productId'] as String;

    // Bind DetailProductController with the provided productId
    Get.lazyPut<DetailProductController>(() => DetailProductController(productId));
  }
}
