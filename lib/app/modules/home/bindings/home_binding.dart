import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/promo/controllers/promo_controller.dart';
import '../../product/controllers/product_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoController>(() => PromoController());
    Get.lazyPut<ProductController>(() => ProductController());
  }
}
