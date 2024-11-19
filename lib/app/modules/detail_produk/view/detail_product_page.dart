import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/detail_product_controller.dart';
import '../widget/video_player.dart';
import 'detail_person_review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final DetailProductController controller = Get.find();

  void _addReview(double rating, String reviewer, String comment, File? image, File? video) {
    controller.addReview(rating, reviewer, comment, image, video);
  }

  void _showAddReviewDialog(BuildContext context) {
    final TextEditingController reviewerController = TextEditingController();
    double rating = 3.0;
    File? selectedImage;
    File? selectedVideo;

    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    }

    Future<void> _pickVideo() async {
      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          selectedVideo = File(pickedFile.path);
        });
      }
    }

    // Reset comment sebelum membuka dialog
    controller.commentController.clear();
    controller.commentText.value = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Review',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Rating',
                        style: TextStyle(fontSize: 16),
                      ),
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        maxRating: 5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (newRating) {
                          setState(() {
                            rating = newRating;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: reviewerController,
                        decoration: InputDecoration(
                          labelText: 'Reviewer Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(() => TextField(
                            controller: controller.commentController,
                            onChanged: (value) {
                              controller.commentText.value = value;
                            },
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Comment',
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
                          )),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text('Pick Image'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _pickVideo,
                        child: const Text('Pick Video'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (reviewerController.text.isNotEmpty &&
                              controller.commentController.text.isNotEmpty) {
                            _addReview(
                              rating,
                              reviewerController.text,
                              controller.commentController.text,
                              selectedImage,
                              selectedVideo,
                            );
                            Navigator.pop(context);
                          } else {
                            Get.snackbar(
                              "Informasi Tidak Lengkap",
                              "Harap isi nama reviewer dan komentar.",
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: const Text('Submit Review'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReview(
      double rating,
      String reviewer,
      String date,
      String comment,
      File? image,
      File? video,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPersonReview(
              rating: rating.toString(),
              reviewer: reviewer,
              date: date,
              comment: comment,
              image: image,
              video: video,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RatingBarIndicator(
                    rating: rating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 24.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$rating/5',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    'By $reviewer',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(date, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(comment),
              if (image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(
                    image,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              if (video != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: VideoPlayerWidget(file: video),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Splash some color',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text('White', style: TextStyle(color: Colors.grey, fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
              'Rp.330.000,-',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    controller.imageAssetPath,
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                return ListView(
                  children: controller.reviews.map((review) {
                    return _buildReview(
                      review['rating'] as double,
                      review['reviewer'],
                      review['date'],
                      review['comment'],
                      review['image'],
                      review['video'],
                      context,
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReviewDialog(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
