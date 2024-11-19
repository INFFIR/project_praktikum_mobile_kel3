import 'package:flutter/material.dart'; // Ditambahkan untuk TextEditingController, TextSelection, TextPosition
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class DetailProductController extends GetxController {
  var imageAssetPath = 'assets/product/product0.jpg';
  var productImages = <XFile>[].obs;

  var reviews = <Map<String, dynamic>>[
    {
      'rating': 4.2,
      'reviewer': 'Amat',
      'date': '1 Jan 2024',
      'comment': 'Recommended item and according to order',
    },
    {
      'rating': 4.7,
      'reviewer': 'Amat',
      'date': '10 Jan 2024',
      'comment': 'Best stuff!!!',
    },
  ].obs;

  final ImagePicker _picker = ImagePicker();

  // Inisialisasi SpeechToText
  final stt.SpeechToText _speech = stt.SpeechToText();
  var isListening = false.obs;
  var commentText = "".obs; // Untuk komentar dari user
  final TextEditingController commentController = TextEditingController(); // Controller global untuk TextField

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      print('Speech initialization error: $e');
    }
  }

  Future<void> checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void toggleListening() async {
    if (isListening.value) {
      stopListening();
    } else {
      await checkMicrophonePermission();
      if (await Permission.microphone.isGranted) {
        isListening.value = true;
        await _speech.listen(onResult: (result) {
          // Gabungkan teks dari mikrofon dengan teks yang sudah ada
          commentController.text += result.recognizedWords;
          commentController.selection = TextSelection.fromPosition(
            TextPosition(offset: commentController.text.length),
          );
          commentText.value = commentController.text; // Sinkronkan dengan commentText
        });
      } else {
        print("Izin mikrofon ditolak.");
        Get.snackbar(
          "Izin Mikrofon Ditolak",
          "Aplikasi memerlukan izin mikrofon untuk fitur ini.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  void stopListening() async {
    isListening.value = false;
    await _speech.stop();
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      productImages.add(pickedFile);
      update();
    }
  }

  Future<void> pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    if (pickedFile != null) {
      print('Picked video path: ${pickedFile.path}');
      // Anda dapat menangani video yang dipilih sesuai kebutuhan
    }
  }

  void addReview(double rating, String reviewer, String comment, File? image, File? video) {
    reviews.insert(0, {
      'rating': rating,
      'reviewer': reviewer,
      'date': _getCurrentDate(),
      'comment': comment,
      'image': image,
      'video': video,
    });
  }

  String _getCurrentDate() {
    final DateTime now = DateTime.now();
    return '${now.day} ${_monthToString(now.month)} ${now.year}';
  }

  String _monthToString(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Opsional: Fitur Submit Feedback
  void submitFeedback() {
    Get.snackbar(
      "Feedback Submitted",
      "Thank You for the Rating",
      snackPosition: SnackPosition.TOP,
    );
    Future.delayed(const Duration(seconds: 1), () {
      Get.offNamed('/home');
    });
  }

  @override
  void onClose() {
    commentController.dispose(); // Dispose controller untuk membebaskan sumber daya
    super.onClose();
  }
}
