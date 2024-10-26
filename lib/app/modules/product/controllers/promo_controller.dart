import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/promo_card.dart'; // Pastikan path ini sesuai dengan struktur folder Anda

class PromoController extends GetxController {
  final promoItems = <PromoItem>[].obs;
  late PageController pageController;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();

    promoItems.assignAll([
      PromoItem(
        image: 'assets/promo/promo1.jpg',
        titleText: 'Promo 1 Detail',
        contentText: 'Enjoy our first promo!',
        promoLabelText: 'Promo 1',
        promoDescriptionText: 'Discount up to 50%',
      ),
      PromoItem(
        image: 'assets/promo/promo2.jpg',
        titleText: 'Promo 2 Detail',
        contentText: 'Don\'t miss our second promo!',
        promoLabelText: 'Promo 2',
        promoDescriptionText: 'Buy 1 Get 1 Free',
      ),
      PromoItem(
        image: 'assets/promo/promo3.jpg',
        titleText: 'Promo 3 Detail',
        contentText: 'Limited time offer!',
        promoLabelText: 'Promo 3',
        promoDescriptionText: 'Free Shipping',
      ),
    ]);

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients && pageController.page != null) {
        int nextPage = (pageController.page!.round() + 1) % promoItems.length;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
    void addPromo(PromoItem promoItem) {
    promoItems.add(promoItem);
  }

  @override
  void onClose() {
    pageController.dispose();
    timer?.cancel();
    super.onClose();
  }
}
