import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/views/home_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/login/bindings/login_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/login/view/login_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/sign_up/view/sign_up_page.dart';
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';
import '../modules/welcome/view/welcome_page.dart'; // Ensure this path is correct based on your folder structure

class AppPages {
  static const initial = Routes.welcome;

  static final routes = [
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    // Add more routes here as needed
      GetPage(
      name: Routes.login,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signUp,
      page: () => signUpPage(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),    
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
  ];
}
