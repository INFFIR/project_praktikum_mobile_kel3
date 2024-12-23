// lib/app/modules/detail_produk/controllers/detail_product_controller.dart

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class DetailProductController extends GetxController {
  final String productId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Observable for product data
  var product = Rxn<DocumentSnapshot>();

  // Observables for reviews and average rating
  var reviews = <Map<String, dynamic>>[].obs;
  var averageRating = 0.0.obs;

  // ID of the current user
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Image and video handling
  var productImages = <XFile>[].obs;

  // Speech-to-text
  final stt.SpeechToText _speech = stt.SpeechToText();
  var isListening = false.obs;
  var commentText = "".obs;
  final TextEditingController commentController = TextEditingController();

  // Snackbar throttle
  final _snackbarLastShown = DateTime.now().subtract(const Duration(seconds: 1)).obs;

  DetailProductController(this.productId);

  @override
  void onInit() {
    super.onInit();
    _fetchProductDetails();
    _fetchReviews();
    _initSpeech();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  // Fetch product details from Firestore
  void _fetchProductDetails() {
    firestore.collection('products').doc(productId).snapshots().listen((doc) {
      product.value = doc;
      if (doc.exists) {
        _calculateAverageRating();
      }
    });
  }

  // Fetch reviews from Firestore
  void _fetchReviews() {
    firestore.collection('products').doc(productId).collection('reviews').snapshots().listen((snapshot) {
      final tempList = <Map<String, dynamic>>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        tempList.add({
          'rating': data['rating']?.toDouble() ?? 0.0,
          'reviewer': data['reviewer'] ?? 'Anonymous',
          'date': data['date'] ?? '',
          'comment': data['comment'] ?? '',
          'imageUrl': data['imageUrl'] ?? '',
          'videoUrl': data['videoUrl'] ?? '',
        });
      }
      reviews.assignAll(tempList);
      _calculateAverageRating();
    });
  }

  // Calculate the average rating from reviews
  void _calculateAverageRating() {
    if (reviews.isEmpty) {
      averageRating.value = 0.0;
    } else {
      double sum = 0.0;
      for (var review in reviews) {
        sum += review['rating'] as double;
      }
      averageRating.value = sum / reviews.length;
    }
  }

  // Initialize speech-to-text
  void _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      print('Speech initialization error: $e');
    }
  }

  // Toggle listening for speech-to-text
  void toggleListening() async {
    if (isListening.value) {
      stopListening();
    } else {
      await checkMicrophonePermission();
      if (await Permission.microphone.isGranted) {
        isListening.value = true;
        await _speech.listen(onResult: (result) {
          // Append recognized words to the comment
          commentController.text += result.recognizedWords;
          commentController.selection = TextSelection.fromPosition(
            TextPosition(offset: commentController.text.length),
          );
          commentText.value = commentController.text;
        });
      } else {
        print("Microphone permission denied.");
        Get.snackbar(
          "Microphone Permission Denied",
          "The app requires microphone access for this feature.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Stop listening
  void stopListening() async {
    isListening.value = false;
    await _speech.stop();
  }

  // Check and request microphone permission
  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  // Pick image using ImagePicker
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      productImages.add(pickedFile);
      update();
    }
  }

  // Pick video using ImagePicker
  Future<void> pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      print('Picked video path: ${pickedFile.path}');
      // Handle video as needed
    }
  }

  // Add a new review to Firestore
  Future<void> addReview(double rating, String reviewer, String comment, XFile? image, XFile? video) async {
    try {
      String imageUrl = '';
      String videoUrl = '';

      // Upload image if provided
      if (image != null) {
        imageUrl = await _uploadFileToStorage(image, 'review_images');
      }

      // Upload video if provided
      if (video != null) {
        videoUrl = await _uploadFileToStorage(video, 'review_videos');
      }

      // Add review to Firestore
      await firestore.collection('products').doc(productId).collection('reviews').add({
        'rating': rating,
        'reviewer': reviewer,
        'date': _getCurrentDate(),
        'comment': comment,
        'imageUrl': imageUrl,
        'videoUrl': videoUrl,
      });

      _showSnackbar("Review Added Successfully");
    } catch (e) {
      _showSnackbar("Failed to add review");
      print('Error adding review: $e');
    }
  }

  // Upload file (image/video) to Firebase Storage and return the download URL
  Future<String> _uploadFileToStorage(XFile file, String folder) async {
    final Reference storageRef = storage.ref().child('$folder/${DateTime.now().millisecondsSinceEpoch}_${file.name}');
    final UploadTask uploadTask = storageRef.putFile(File(file.path));
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Get current date in a readable format
  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    return '${now.day} ${_monthToString(now.month)} ${now.year}';
  }

  // Convert month number to string
  String _monthToString(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Show snackbar with throttle
  void _showSnackbar(String message) {
    final now = DateTime.now();
    if (now.difference(_snackbarLastShown.value).inSeconds >= 1) {
      Get.snackbar("Info", message, snackPosition: SnackPosition.BOTTOM);
      _snackbarLastShown.value = now;
    }
  }
}
