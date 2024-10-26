import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/sign_up/controllers/auth_controller.dart.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
