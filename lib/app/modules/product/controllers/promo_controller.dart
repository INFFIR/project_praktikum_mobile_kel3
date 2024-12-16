// lib/app/product/controllers/promo_controller.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import '../../services/connectivity_service.dart'; // Import ConnectivityService

// Definisikan kelas PromoItem jika belum ada
class PromoItem {
  String? id; // id dibuat nullable
  final String imageUrl;
  final String titleText;
  final String contentText;
  final String promoLabelText;
  final String promoDescriptionText;

  PromoItem({
    this.id, // id menjadi opsional
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

  // GetStorage instance
  final GetStorage _storage = GetStorage();

  // Keys untuk operasi pending
  final String _pendingAddsKey = 'pending_promo_adds';
  final String _pendingEditsKey = 'pending_promo_edits';

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
    try {
      String imageUrl = '';
      if (imageFile != null) {
        imageUrl = await _uploadImageToStorage(imageFile, 'promo_images');
      }

      // Simpan data promo ke Firestore
      Map<String, dynamic> promoData = {
        'imageUrl': imageUrl,
        'titleText': promoItem.titleText,
        'contentText': promoItem.contentText,
        'promoLabelText': promoItem.promoLabelText,
        'promoDescriptionText': promoItem.promoDescriptionText,
      };

      // Coba tambahkan ke Firestore
      DocumentReference docRef = await firestore.collection('promos').add(promoData);

      // Update promoItem dengan ID dokumen yang baru dibuat
      promoItem.id = docRef.id;

      // Tambahkan promo ke list lokal
      promoItems.add(promoItem);
    } catch (e) {
      print("Error in addPromo: $e");
      // Cek jika ini masalah konektivitas
      if (!isConnected()) {
        // Simpan ke pending adds
        _savePendingAdd({
          'titleText': promoItem.titleText,
          'contentText': promoItem.contentText,
          'promoLabelText': promoItem.promoLabelText,
          'promoDescriptionText': promoItem.promoDescriptionText,
          'imagePath': imageFile?.path ?? '',
        });
        Get.snackbar(
          "Offline",
          "Promo akan ditambahkan saat koneksi kembali.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.5),
          colorText: Colors.white,
        );
      } else {
        // Rethrow untuk ditangani di halaman
        throw e;
      }
    }
  }

  Future<void> editPromo(
      String promoId, PromoItem promoItem, File? imageFile) async {
    try {
      Map<String, dynamic> updatedData = {
        'titleText': promoItem.titleText,
        'contentText': promoItem.contentText,
        'promoLabelText': promoItem.promoLabelText,
        'promoDescriptionText': promoItem.promoDescriptionText,
      };

      if (imageFile != null) {
        String imageUrl = await _uploadImageToStorage(imageFile, 'promo_images');
        updatedData['imageUrl'] = imageUrl;
      }

      // Coba update Firestore
      await firestore.collection('promos').doc(promoId).update(updatedData);

      // Update item di list lokal jika diperlukan
      int index = promoItems.indexWhere((item) => item.id == promoId);
      if (index != -1) {
        promoItems[index] = PromoItem(
          id: promoId,
          imageUrl: updatedData['imageUrl'] ?? promoItems[index].imageUrl,
          titleText: promoItem.titleText,
          contentText: promoItem.contentText,
          promoLabelText: promoItem.promoLabelText,
          promoDescriptionText: promoItem.promoDescriptionText,
        );
      }
    } catch (e) {
      print("Error in editPromo: $e");
      // Cek jika ini masalah konektivitas
      if (!isConnected()) {
        // Simpan ke pending edits
        _savePendingEdit({
          'promoId': promoId,
          'titleText': promoItem.titleText,
          'contentText': promoItem.contentText,
          'promoLabelText': promoItem.promoLabelText,
          'promoDescriptionText': promoItem.promoDescriptionText,
          'imagePath': imageFile?.path ?? '',
        });
        Get.snackbar(
          "Offline",
          "Perubahan promo akan disimpan saat koneksi kembali.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.5),
          colorText: Colors.white,
        );
      } else {
        // Rethrow untuk ditangani di halaman
        throw e;
      }
    }
  }

  Future<void> deletePromo(String promoId) async {
    try {
      await firestore.collection('promos').doc(promoId).delete();
    } catch (e) {
      print("Error in deletePromo: $e");
      throw e; // Rethrow untuk ditangani di halaman
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

  // Helper untuk mengecek status koneksi
  bool isConnected() {
    try {
      var connectivityService = Get.find<ConnectivityService>();
      return connectivityService.isConnected.value;
    } catch (e) {
      // Jika ConnectivityService tidak ditemukan, anggap terhubung
      return true;
    }
  }

  // Simpan operasi add yang pending ke GetStorage
  void _savePendingAdd(Map<String, dynamic> data) {
    List<dynamic> pendingAdds = _storage.read<List<dynamic>>(_pendingAddsKey) ?? [];
    pendingAdds.add(data);
    _storage.write(_pendingAddsKey, pendingAdds);
  }

  // Simpan operasi edit yang pending ke GetStorage
  void _savePendingEdit(Map<String, dynamic> data) {
    List<dynamic> pendingEdits = _storage.read<List<dynamic>>(_pendingEditsKey) ?? [];
    pendingEdits.add(data);
    _storage.write(_pendingEditsKey, pendingEdits);
  }

  // Fungsi untuk mengupload operasi add dan edit yang pending
  Future<void> uploadPendingPromos() async {
    List<dynamic> pendingAdds = _storage.read<List<dynamic>>(_pendingAddsKey) ?? [];
    List<dynamic> pendingEdits = _storage.read<List<dynamic>>(_pendingEditsKey) ?? [];

    // Proses pending adds
    for (var addData in pendingAdds) {
      try {
        String titleText = addData['titleText'];
        String contentText = addData['contentText'];
        String promoLabelText = addData['promoLabelText'];
        String promoDescriptionText = addData['promoDescriptionText'];
        String imagePath = addData['imagePath'];

        File? imageFile = imagePath.isNotEmpty ? File(imagePath) : null;
        String imageUrl = '';
        if (imageFile != null && await imageFile.exists()) {
          imageUrl = await _uploadImageToStorage(imageFile, 'promo_images');
        }

        // Buat data promo
        Map<String, dynamic> promoData = {
          'imageUrl': imageUrl,
          'titleText': titleText.isNotEmpty ? titleText : 'Judul Promo',
          'contentText': contentText.isNotEmpty ? contentText : 'Konten Promo',
          'promoLabelText': promoLabelText.isNotEmpty ? promoLabelText : 'Label Promo',
          'promoDescriptionText': promoDescriptionText.isNotEmpty
              ? promoDescriptionText
              : 'Deskripsi Promo',
        };

        // Tambahkan ke Firestore
        DocumentReference docRef = await firestore.collection('promos').add(promoData);

        // Buat PromoItem dan tambahkan ke list lokal
        PromoItem newPromo = PromoItem(
          id: docRef.id,
          imageUrl: imageUrl,
          titleText: titleText,
          contentText: contentText,
          promoLabelText: promoLabelText,
          promoDescriptionText: promoDescriptionText,
        );

        promoItems.add(newPromo);

        // Opsional: hapus file gambar setelah upload
        if (imageFile != null) {
          await imageFile.delete();
        }
      } catch (e) {
        print("Error uploading pending add promo: $e");
        // Jika terjadi error, simpan kembali untuk percobaan selanjutnya
        continue;
      }
    }

    // Hapus pending adds setelah berhasil diupload
    _storage.remove(_pendingAddsKey);

    // Proses pending edits
    for (var editData in pendingEdits) {
      try {
        String promoId = editData['promoId'];
        String titleText = editData['titleText'];
        String contentText = editData['contentText'];
        String promoLabelText = editData['promoLabelText'];
        String promoDescriptionText = editData['promoDescriptionText'];
        String imagePath = editData['imagePath'];

        File? imageFile = imagePath.isNotEmpty ? File(imagePath) : null;

        Map<String, dynamic> updatedData = {
          'titleText': titleText.isNotEmpty ? titleText : 'Judul Promo',
          'contentText': contentText.isNotEmpty ? contentText : 'Konten Promo',
          'promoLabelText':
              promoLabelText.isNotEmpty ? promoLabelText : 'Label Promo',
          'promoDescriptionText': promoDescriptionText.isNotEmpty
              ? promoDescriptionText
              : 'Deskripsi Promo',
        };

        if (imageFile != null && await imageFile.exists()) {
          String imageUrl = await _uploadImageToStorage(imageFile, 'promo_images');
          updatedData['imageUrl'] = imageUrl;
        }

        // Update Firestore
        await firestore.collection('promos').doc(promoId).update(updatedData);

        // Update list lokal jika diperlukan
        int index = promoItems.indexWhere((item) => item.id == promoId);
        if (index != -1) {
          promoItems[index] = PromoItem(
            id: promoId,
            imageUrl: updatedData['imageUrl'] ?? promoItems[index].imageUrl,
            titleText: titleText,
            contentText: contentText,
            promoLabelText: promoLabelText,
            promoDescriptionText: promoDescriptionText,
          );
        }

        // Opsional: hapus file gambar setelah upload
        if (imageFile != null) {
          await imageFile.delete();
        }
      } catch (e) {
        print("Error uploading pending edit promo: $e");
        // Jika terjadi error, simpan kembali untuk percobaan selanjutnya
        continue;
      }
    }

    // Hapus pending edits setelah berhasil diupload
    _storage.remove(_pendingEditsKey);
  }
}
