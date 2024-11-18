
import 'package:flutter/material.dart'; // Impor yang diperlukan untuk TextEditingController, TextPosition, TextSelection
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class RatingController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();

  var isListening = false.obs;
  var commentText = "".obs; // Untuk komentar dari user
  var rating = 0.obs; // Rating yang diberikan user
  final commentController = TextEditingController(); // Controller global untuk TextField

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      await _speech.initialize();
    } catch (e) {
      print(e);
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
      }
    }
  }

  void stopListening() async {
    isListening.value = false;
    await _speech.stop();
  }

  void submitFeedback() {
    Get.snackbar(
      "Feedback Submitted",
      "Thank You for the Rating",
      snackPosition: SnackPosition.TOP,
    );
    Future.delayed(Duration(seconds: 1), () {
      Get.offNamed('/home');
    });
  }
}
