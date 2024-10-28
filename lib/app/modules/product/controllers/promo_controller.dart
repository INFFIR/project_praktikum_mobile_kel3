// promo_controller.dart
import 'package:flutter/material.dart'; // Tambahkan ini untuk PageController
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';

import '../widgets/promo_card.dart';

class PromoController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final promoItems = <PromoItem>[].obs;
  late PageController pageController;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    fetchPromos();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.hasClients && pageController.page != null) {
        int nextPage =
            (pageController.page!.round() + 1) % promoItems.length;
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
      promoItems.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id; // Menyimpan ID dokumen
        return PromoItem(
          id: data['id'],
          imageUrl: data['imageUrl'] ?? '',
          titleText: data['titleText'] ?? 'Judul Promo',
          contentText: data['contentText'] ?? 'Konten Promo',
          promoLabelText: data['promoLabelText'] ?? 'Label Promo',
          promoDescriptionText:
              data['promoDescriptionText'] ?? 'Deskripsi Promo',
        );
      }).toList();
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    timer?.cancel();
    super.onClose();
  }

  Future<void> addPromo(PromoItem promoItem, File? imageFile) async {
    String imageUrl = '';
    if (imageFile != null) {
      imageUrl = await _uploadImageToStorage(imageFile, 'promo_images');
    }

    await firestore.collection('promos').add({
      'imageUrl': imageUrl,
      'titleText': promoItem.titleText.isNotEmpty
          ? promoItem.titleText
          : 'Judul Promo',
      'contentText': promoItem.contentText.isNotEmpty
          ? promoItem.contentText
          : 'Konten Promo',
      'promoLabelText': promoItem.promoLabelText.isNotEmpty
          ? promoItem.promoLabelText
          : 'Label Promo',
      'promoDescriptionText':
          promoItem.promoDescriptionText.isNotEmpty
              ? promoItem.promoDescriptionText
              : 'Deskripsi Promo',
    });
  }

  Future<void> editPromo(
      String promoId, PromoItem promoItem, File? imageFile) async {
    Map<String, dynamic> updatedData = {
      'titleText': promoItem.titleText.isNotEmpty
          ? promoItem.titleText
          : 'Judul Promo',
      'contentText': promoItem.contentText.isNotEmpty
          ? promoItem.contentText
          : 'Konten Promo',
      'promoLabelText': promoItem.promoLabelText.isNotEmpty
          ? promoItem.promoLabelText
          : 'Label Promo',
      'promoDescriptionText':
          promoItem.promoDescriptionText.isNotEmpty
              ? promoItem.promoDescriptionText
              : 'Deskripsi Promo',
    };

    if (imageFile != null) {
      String imageUrl =
          await _uploadImageToStorage(imageFile, 'promo_images');
      updatedData['imageUrl'] = imageUrl;
    }

    await firestore.collection('promos').doc(promoId).update(updatedData);
  }

  Future<void> deletePromo(String promoId) async {
    await firestore.collection('promos').doc(promoId).delete();
  }

  Future<String> _uploadImageToStorage(
      File imageFile, String folder) async {
    Reference storageReference = storage.ref().child(
        '$folder/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
