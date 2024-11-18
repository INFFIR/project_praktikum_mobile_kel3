import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/view/detail_product_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/bindings/home_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/views/home_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/login/bindings/login_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/login/view/login_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/welcome/bindings/welcome_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/setting/view/settings_page.dart';
import '../modules/sign_up/bindings/auth_binding.dart.dart';
import '../modules/sign_up/view/sign_up_screen.dart.dart';
import '../modules/welcome/view/welcome_page.dart';

class AppPages {
  static const initial = Routes.welcome;

  static final routes = [
    GetPage(
      name: Routes.welcome,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
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
      page: () => SignUpScreen(),
      binding: AuthBinding(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    GetPage(
      name: Routes.detailProduct,
      page: () => const DetailProductPage(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    GetPage(
      name: '/profile',
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    // New route for SettingsPage
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      // binding: SettingsBinding(),
    ),
  ];
}
