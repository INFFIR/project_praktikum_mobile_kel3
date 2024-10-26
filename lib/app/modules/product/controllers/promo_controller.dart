// promo_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../widgets/promo_card.dart';

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

  @override
  void onClose() {
    pageController.dispose();
    timer?.cancel();
    super.onClose();
  }

  Future<String> _saveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    final savedImage = await imageFile.copy('${directory.path}/$fileName');
    return savedImage.path;
  }

  void addPromo(PromoItem promoItem) async {
    String imagePath = promoItem.image;

    if (!imagePath.startsWith('assets/') && File(imagePath).existsSync()) {
      // Jika gambar berasal dari file sistem, simpan ke direktori aplikasi
      imagePath = await _saveImage(File(imagePath));
    }

    promoItems.add(
      PromoItem(
        image: imagePath,
        titleText: promoItem.titleText.isNotEmpty ? promoItem.titleText : 'Judul Promo',
        contentText: promoItem.contentText.isNotEmpty ? promoItem.contentText : 'Konten Promo',
        promoLabelText: promoItem.promoLabelText.isNotEmpty ? promoItem.promoLabelText : 'Label Promo',
        promoDescriptionText: promoItem.promoDescriptionText.isNotEmpty ? promoItem.promoDescriptionText : 'Deskripsi Promo',
      ),
    );
  }

  void editPromo(int index, PromoItem promoItem) async {
    if (index >= 0 && index < promoItems.length) {
      String imagePath = promoItem.image;

      if (!imagePath.startsWith('assets/') && File(imagePath).existsSync()) {
        // Jika gambar berasal dari file sistem, simpan ke direktori aplikasi
        imagePath = await _saveImage(File(imagePath));
      }

      promoItems[index] = PromoItem(
        image: imagePath,
        titleText: promoItem.titleText.isNotEmpty ? promoItem.titleText : 'Judul Promo',
        contentText: promoItem.contentText.isNotEmpty ? promoItem.contentText : 'Konten Promo',
        promoLabelText: promoItem.promoLabelText.isNotEmpty ? promoItem.promoLabelText : 'Label Promo',
        promoDescriptionText: promoItem.promoDescriptionText.isNotEmpty ? promoItem.promoDescriptionText : 'Deskripsi Promo',
      );
    }
  }

  void deletePromo(int index) {
    if (index >= 0 && index < promoItems.length) {
      promoItems.removeAt(index);
    }
  }
}
