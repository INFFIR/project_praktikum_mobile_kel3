// lib/app/modules/promo/controllers/promo_controller.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/promo_model.dart';

class PromoController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  final promoItems = <PromoModel>[].obs;
  late PageController pageController;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    fetchPromos();
    // Timer untuk auto-slide
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients &&
          pageController.page != null &&
          promoItems.isNotEmpty) {
        int nextPage = (pageController.page!.round() + 1) % promoItems.length;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void fetchPromos() {
    firestore.collection('promos').snapshots().listen((snapshot) {
      final list = <PromoModel>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final promo = PromoModel.fromMap(doc.id, data);
        list.add(promo);
      }
      promoItems.value = list;
    });
  }

  Future<void> addPromo(PromoModel promo, File? imageFile) async {
    String imageUrl = '';
    if (imageFile != null) {
      imageUrl = await _uploadImageToStorage(imageFile, 'promo_images');
    }
    final docRef = await firestore.collection('promos').add({
      'imageUrl': imageUrl,
      'titleText': promo.titleText,
      'contentText': promo.contentText,
      'promoLabelText': promo.promoLabelText,
      'promoDescriptionText': promo.promoDescriptionText,
    });
    final newPromo = PromoModel(
      id: docRef.id,
      imageUrl: imageUrl,
      titleText: promo.titleText,
      contentText: promo.contentText,
      promoLabelText: promo.promoLabelText,
      promoDescriptionText: promo.promoDescriptionText,
    );
    promoItems.add(newPromo);
  }

  Future<void> editPromo(String promoId, PromoModel updatedPromo, File? imageFile) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImageToStorage(imageFile, 'promo_images');
    }
    final dataUpdate = {
      'titleText': updatedPromo.titleText,
      'contentText': updatedPromo.contentText,
      'promoLabelText': updatedPromo.promoLabelText,
      'promoDescriptionText': updatedPromo.promoDescriptionText,
    };
    if (imageUrl != null) {
      dataUpdate['imageUrl'] = imageUrl;
    }
    await firestore.collection('promos').doc(promoId).update(dataUpdate);

    final idx = promoItems.indexWhere((p) => p.id == promoId);
    if (idx != -1) {
      final oldItem = promoItems[idx];
      promoItems[idx] = PromoModel(
        id: promoId,
        imageUrl: imageUrl ?? oldItem.imageUrl,
        titleText: updatedPromo.titleText,
        contentText: updatedPromo.contentText,
        promoLabelText: updatedPromo.promoLabelText,
        promoDescriptionText: updatedPromo.promoDescriptionText,
      );
    }
  }

  Future<void> deletePromo(String promoId) async {
    await firestore.collection('promos').doc(promoId).delete();
    promoItems.removeWhere((p) => p.id == promoId);
  }

  Future<String> _uploadImageToStorage(File imageFile, String folder) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
    final ref = storage.ref().child('$folder/$fileName');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }

  @override
  void onClose() {
    pageController.dispose();
    timer?.cancel();
    super.onClose();
  }
}
