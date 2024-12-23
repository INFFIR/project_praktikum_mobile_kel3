// lib/widgets/bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find<BottomNavController>();

    return Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favorites',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Location',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.black,
            ),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
        ));
  }
}
// lib/controllers/bottom_nav_controller.dart

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  final List<String> routes = ['/home', '/favorites', '/location', '/profile'];

  void onTap(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      Get.offNamed(routes[index]);
    }
  }

  @override
  void onInit() {
    super.onInit();
    String currentRoute = Get.currentRoute;
    int index = routes.indexOf(currentRoute);
    if (index != -1) {
      currentIndex.value = index;
    } else {
      currentIndex.value = 0;
    }
  }
}


