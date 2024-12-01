import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/controllers/detail_product_controller.dart';

class DetailProductBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailProductController>(() => DetailProductController());
  }
}
