// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/bindings/detail_product_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/view/detail_product_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/bindings/home_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/views/home_admin_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/views/home_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/login/bindings/login_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/login/view/login_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/product/bindings/product_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/product/view/add_product_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/product/view/edit_product_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/promo/bindings/promo_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/promo/view/add_promo_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/promo/view/edit_promo_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/sign_up/bindings/auth_binding.dart.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/sign_up/view/sign_up_screen.dart.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/transaction/bindings/invoice_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/transaction/bindings/payment_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/transaction/views/invoice_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/transaction/views/payment_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/welcome/bindings/welcome_binding.dart';
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';
import '../modules/connection/bindings/connection_binding.dart';
import '../modules/favorite/bindings/favorite_binding.dart';
import '../modules/favorite/views/favorite_page.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/location/bindings/location_binding.dart';
import '../modules/location/views/location_view.dart';
import '../modules/setting/view/settings_page.dart';
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
      bindings: [
        AuthBinding(),
        ConnectionBinding(),
      ],
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    GetPage(
      name: Routes.homeAdmin,
      page: () => const HomeAdminPage(),
      binding: HomeBinding(), // Pastikan binding yang tepat digunakan
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    GetPage(
      name: Routes.detailProduct,
      page: () => const DetailProductPage(),
      binding: DetailProductBindings(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    // New route for SettingsPage
    GetPage(
      name: Routes.settings,
      page: () => const SettingsPage(),
      // binding: SettingsBinding(), // Uncomment jika ada binding untuk Settings
    ),
    GetPage(
      name: Routes.location,
      page: () => LocationView(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: Routes.favorites,
      page: () => const FavoritePage(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: Routes.productAdd,
      page: () => const AddProductPage(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.productEdit,
      page: () {
        // Di contoh ini, kita asumsikan kita pass parameter productId via Get.parameters
        final productId = Get.parameters['productId'] ?? '';
        return EditProductPage(productId: productId);
      },
      binding: ProductBinding(),
    ),
    // Rute untuk Promo
    GetPage(
      name: Routes.promoAdd,
      page: () => const AddPromoPage(),
      binding: PromoBinding(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
    GetPage(
      name: Routes.promoEdit,
      page: () {
        // Pass parameter promoId via Get.parameters
        final promoId = Get.parameters['promoId'] ?? '';
        return EditPromoPage(promoId: promoId);
      },
      binding: PromoBinding(),
      transition: Transition.fadeIn, // Optional: Add transition effect
    ),
        GetPage(
      name: Routes.payment,
      page: () => PaymentPage(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: Routes.invoice,
      page: () => InvoicePage(),
      binding: InvoiceBinding(),
    ),
  ];
}
