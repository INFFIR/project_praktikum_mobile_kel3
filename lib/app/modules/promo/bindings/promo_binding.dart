// lib/app/promo/bindings/promo_binding.dart
import 'package:get/get.dart';
import '../controllers/promo_controller.dart';

class PromoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoController>(() => PromoController());
  }
}
