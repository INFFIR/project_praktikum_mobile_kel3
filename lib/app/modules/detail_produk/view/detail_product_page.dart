// lib/app/modules/detail_produk/view/detail_product_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/controllers/detail_product_controller.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/view/detail_person_review.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/widget/video_player.dart';
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final DetailProductController controller = Get.find();

  // Function to add a review
  void _addReview(double rating, String reviewer, String comment, XFile? image, XFile? video) {
    controller.addReview(rating, reviewer, comment, image, video);
  }

  // Function to show the add review dialog
  void _showAddReviewDialog(BuildContext context) {
    final TextEditingController reviewerController = TextEditingController();
    double rating = 3.0;
    XFile? selectedImage;
    XFile? selectedVideo;

    // Function to pick image
    Future<void> _pickImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          selectedImage = pickedFile;
        });
      }
    }

    // Function to pick video
    Future<void> _pickVideo() async {
      final pickedFile = await ImagePicker().pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          selectedVideo = pickedFile;
        });
      }
    }

    // Reset comment before opening dialog
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
                              "Incomplete Information",
                              "Please fill in the reviewer name and comment.",
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

  // Function to build individual review widgets
  Widget _buildReview(Map<String, dynamic> review, BuildContext context) {
    double parsedRating = review['rating'] as double;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPersonReview(
              rating: parsedRating.toString(),
              reviewer: review['reviewer'],
              date: review['date'],
              comment: review['comment'],
              imageUrl: review['imageUrl'],
              videoUrl: review['videoUrl'],
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
                    rating: parsedRating,
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
                    '$parsedRating/5',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const Spacer(),
                  Text(
                    'By ${review['reviewer']}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(review['date'], style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(review['comment']),
              if (review['imageUrl'] != '')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.network(
                    review['imageUrl'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Image failed to load.");
                    },
                  ),
                ),
              if (review['videoUrl'] != '')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: VideoPlayerWidget(videoUrl: review['videoUrl']),
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
      body: Obx(() {
        if (controller.product.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.product.value!.exists) {
          return const Center(child: Text("Product not found."));
        }

        final data = controller.product.value!.data() as Map<String, dynamic>;

        final String name = data['name'] ?? 'Product Name Unavailable';
        final int price = data['price'] ?? 0;
        final String imageUrl = data['imageUrl'] ?? '';
        final String description = data['description'] ?? 'No description available';
        final int likes = data['likes'] ?? 0;

        // Widget to display product image
        Widget imageWidget;
        if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
          imageWidget = Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stack) {
              return Image.asset(
                'assets/product/default.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          );
        } else if (imageUrl.isNotEmpty && imageUrl.startsWith('assets/')) {
          imageWidget = Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stack) {
              return Image.asset(
                'assets/product/default.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          );
        } else {
          // If empty or local file
          imageWidget = Image.asset(
            'assets/product/default.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Product Image
              Container(
                width: 240,
                height: 240,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageWidget,
              ),
              const SizedBox(height: 30),
              // Product Name
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Price
              Text(
                'Rp $price,-',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontFamily: 'Times New Roman',
                ),
              ),
              const SizedBox(height: 20),
              // Likes and Average Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$likes likes',
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Obx(() => Row(
                        children: [
                          RatingBarIndicator(
                            rating: controller.averageRating.value,
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
                            controller.averageRating.value.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(height: 20),
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontFamily: 'Times New Roman',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Removed the Row containing Review and Buy Now buttons
              /*
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Review Button (Removed)
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(
                        Routes.detailProduct, // Adjust route as necessary
                        arguments: {'productId': controller.productId},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      'Review',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Buy Now Button (Removed from Row)
                  ElevatedButton(
                    onPressed: () {
                      Get.offNamed(Routes.home);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black54),
                    ),
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              */
              const SizedBox(height: 20),
              // Reviews Section
              const Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reviews',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.reviews.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("No reviews yet."),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.reviews.length,
                  itemBuilder: (context, index) {
                    return _buildReview(controller.reviews[index], context);
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
      // Implementing the bottomNavigationBar with the "Buy Now" button
 bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 60, // Adjust the height as needed
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Ensure product data is available
              if (controller.product.value != null && controller.product.value!.exists) {
                final String productId = controller.product.value!.id;
                final Map<String, dynamic> data = controller.product.value!.data() as Map<String, dynamic>;
                final int priceInt = data['price'] ?? 0;
                final double amount = priceInt.toDouble();

                // Navigate to the Payment page with arguments
                Get.toNamed(
                  Routes.payment,
                  arguments: {
                    'productId': productId,
                    'amount': amount,
                  },
                );
              } else {
                Get.snackbar(
                  "Error",
                  "Product data is not available.",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Rounded corners
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Buy Now',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white, // Icon color
                ),
              ],
            ),
          ),
        ),
      ),
      // Retain the Floating Action Button for adding reviews
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddReviewDialog(context);
        },
        child: const Icon(Icons.add_comment),
        backgroundColor: Colors.blue, // Customize as needed
        tooltip: 'Add Review',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
