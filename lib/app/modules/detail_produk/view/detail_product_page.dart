import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'detail_person_review.dart'; // Import halaman detail review

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  final String _imageAssetPath = 'assets/product/product0.jpg';

  // List review dinamis
  final List<Map<String, dynamic>> _reviews = [
    {
      'rating': '4.2',
      'reviewer': 'Amat',
      'date': '1 Jan 2024',
      'comment': 'Recommended item and according to order',
      'image': null,
      'video': null,
    },
    {
      'rating': '4.7',
      'reviewer': 'Amat',
      'date': '10 Jan 2024',
      'comment': 'Best stuff!!!',
      'image': null,
      'video': null,
    },
  ];

  void _addReview(String rating, String reviewer, String comment, File? image, File? video) {
    setState(() {
      _reviews.insert(0, {
        'rating': rating,
        'reviewer': reviewer,
        'date': _getCurrentDate(),
        'comment': comment,
        'image': image,
        'video': video,
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          '9:41',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
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
                    _imageAssetPath,
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
              child: ListView(
                children: _reviews.map((review) {
                  return _buildReview(
                    review['rating'],
                    review['reviewer'],
                    review['date'],
                    review['comment'],
                    review['image'],
                    review['video'],
                    context, // Pass context to navigate
                  );
                }).toList(),
              ),
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

  Widget _buildReview(String rating, String reviewer, String date, String comment, File? image, File? video, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the detail review page when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPersonReview(
              rating: rating,
              reviewer: reviewer,
              date: date,
              comment: comment,
              image: image,
              video: video, // Pass video to detail review page
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
                  Text(
                    rating,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    '/5',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
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
                    width: 100,
                    height: 100,
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

  void _showAddReviewDialog(BuildContext context) {
    final TextEditingController ratingController = TextEditingController();
    final TextEditingController reviewerController = TextEditingController();
    final TextEditingController commentController = TextEditingController();
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

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                TextField(
                  controller: ratingController,
                  decoration: const InputDecoration(labelText: 'Rating (1-5)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: reviewerController,
                  decoration: const InputDecoration(labelText: 'Reviewer Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: commentController,
                  decoration: const InputDecoration(labelText: 'Comment'),
                  maxLines: 3,
                ),
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
                    if (ratingController.text.isNotEmpty &&
                        reviewerController.text.isNotEmpty &&
                        commentController.text.isNotEmpty) {
                      _addReview(
                        ratingController.text,
                        reviewerController.text,
                        commentController.text,
                        selectedImage,
                        selectedVideo,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit Review'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VideoPlayerWidget extends StatelessWidget {
  final File file;
  const VideoPlayerWidget({required this.file, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Text('Video Player for ${file.path}'),
      ),
    );
  }
}
