// lib/app/modules/detail_produk/views/detail_person_review.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_produk/widget/video_player.dart';

class DetailPersonReview extends StatelessWidget {
  final String rating;
  final String reviewer;
  final String date;
  final String comment;
  final String imageUrl;
  final String videoUrl;

  const DetailPersonReview({
    super.key,
    required this.rating,
    required this.reviewer,
    required this.date,
    required this.comment,
    this.imageUrl = '',
    this.videoUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    double parsedRating = double.tryParse(rating) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Detail'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
                  'By $reviewer',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              comment,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (imageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Image failed to load.");
                    },
                  ),
                ),
              ),
            if (videoUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: VideoPlayerWidget(videoUrl: videoUrl),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
