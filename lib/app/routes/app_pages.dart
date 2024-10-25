import 'package:get/get.dart';
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
  ];
}
