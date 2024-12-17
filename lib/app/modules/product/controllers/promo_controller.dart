import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import '../../services/connectivity_service.dart';


class PromoItem {
  String? id;
  String imageUrl;
  String titleText;
  String contentText;
  String promoLabelText;
  String promoDescriptionText;

  PromoItem({
    this.id,
    required this.imageUrl,
    required this.titleText,
    required this.contentText,
    required this.promoLabelText,
    required this.promoDescriptionText,
  });
}

class PromoController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  final promoItems = <PromoItem>[].obs;
  late PageController pageController;
  Timer? timer;

  final ConnectivityService _connectivityService = Get.find();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    fetchPromos();

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
      promoItems.value = snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
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

    if (await _connectivityService.checkConnection()) {
      DocumentReference docRef = await firestore.collection('promos').add({
        'imageUrl': imageUrl,
        'titleText': promoItem.titleText,
        'contentText': promoItem.contentText,
        'promoLabelText': promoItem.promoLabelText,
        'promoDescriptionText': promoItem.promoDescriptionText,
      });

      promoItem.id = docRef.id;
      promoItems.add(promoItem);
      Get.snackbar("Success", "Promo added successfully.");
    } else {
      // Save promo data locally if no connection
      final box = GetStorage();
      box.write('pendingPromo', {
        'imageUrl': imageUrl,
        'titleText': promoItem.titleText,
        'contentText': promoItem.contentText,
        'promoLabelText': promoItem.promoLabelText,
        'promoDescriptionText': promoItem.promoDescriptionText,
      });
      Get.snackbar("Offline", "Promo saved locally, will upload when connected.");
    }
  }

  Future<void> uploadPendingPromo() async {
    final box = GetStorage();
    if (box.hasData('pendingPromo')) {
      var pendingPromo = box.read('pendingPromo');
      DocumentReference docRef = await firestore.collection('promos').add(pendingPromo);
      String promoId = docRef.id;
      promoItems.add(PromoItem(
        id: promoId,
        imageUrl: pendingPromo['imageUrl'],
        titleText: pendingPromo['titleText'],
        contentText: pendingPromo['contentText'],
        promoLabelText: pendingPromo['promoLabelText'],
        promoDescriptionText: pendingPromo['promoDescriptionText'],
      ));
      box.remove('pendingPromo');
      Get.snackbar("Uploaded", "Promo uploaded successfully.");
    }
  }

  Future<String> _uploadImageToStorage(File imageFile, String folder) async {
    Reference storageReference = storage.ref().child(
        '$folder/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> editPromo(String promoId, PromoItem promoItem, File? imageFile) async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _uploadImageToStorage(imageFile, 'promo_images');
    }

    Map<String, dynamic> updatedData = {
      'titleText': promoItem.titleText,
      'contentText': promoItem.contentText,
      'promoLabelText': promoItem.promoLabelText,
      'promoDescriptionText': promoItem.promoDescriptionText,
    };

    if (imageUrl != null) {
      updatedData['imageUrl'] = imageUrl;
    }

    await firestore.collection('promos').doc(promoId).update(updatedData);

    // Update the local list
    int index = promoItems.indexWhere((item) => item.id == promoId);
    if (index != -1) {
      promoItems[index] = PromoItem(
        id: promoId,
        imageUrl: imageUrl ?? promoItems[index].imageUrl,
        titleText: promoItem.titleText,
        contentText: promoItem.contentText,
        promoLabelText: promoItem.promoLabelText,
        promoDescriptionText: promoItem.promoDescriptionText,
      );
    }

    Get.snackbar("Success", "Promo updated successfully.");
  }

  Future<void> deletePromo(String promoId) async {
    await firestore.collection('promos').doc(promoId).delete();
    promoItems.removeWhere((item) => item.id == promoId);
    Get.snackbar("Success", "Promo deleted successfully.");
  }
}