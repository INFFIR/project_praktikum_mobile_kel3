// profile_binding.dart
import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/profile/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
