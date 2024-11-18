import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rating_controller.dart';

class RatingView extends GetView<RatingController> {
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedback",
          textAlign: TextAlign.center, // Tulisan di tengah
        ),
        centerTitle: true, // Posisi tengah
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Rate Your Experience",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Please Give Us Rating and Comment",
                style: TextStyle(fontSize: 17, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(5, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 230, 51, 69),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: IconButton(
                          icon: Icon(
                            index < controller.rating.value
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            controller.rating.value = index + 1;
                          },
                        ),
                      );
                    }),
                  )),
              const SizedBox(height: 50),
              const Text(
                "Fill The Comment",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.commentController, // Gunakan controller global
                onChanged: (value) {
                  controller.commentText.value = value; // Sinkronkan dengan commentText
                },
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: "Write Your Comment or Generate with Voice Memo",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isListening.value ? Icons.mic_off : Icons.mic,
                    ),
                    onPressed: () {
                      controller.toggleListening();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: controller.submitFeedback,
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
