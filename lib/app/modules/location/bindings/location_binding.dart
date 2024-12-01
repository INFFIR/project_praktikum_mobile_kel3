import 'package:get/get.dart';
import '../controllers/location_controller.dart';


class RatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(() => LocationController());
  }
}
