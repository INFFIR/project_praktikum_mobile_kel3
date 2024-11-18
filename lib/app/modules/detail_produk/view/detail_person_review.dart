import 'package:flutter/material.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class DetailPersonReview extends StatelessWidget {
  final String rating;
  final String reviewer;
  final String date;
  final String comment;
  final File? image;
  final File? video;

  const DetailPersonReview({
    super.key,
    required this.rating,
    required this.reviewer,
    required this.date,
    required this.comment,
    this.image,
    this.video,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Detail'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
            Text(
              comment,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 120), // Increased space before the image or video
            if (image != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Image.file(
                  image!,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16), // Add space between image and video
            if (video != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0), // Increased space before video
                child: Container(
                  alignment: Alignment.center,
                  child: VideoPlayerWidget(file: video!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File file;

  const VideoPlayerWidget({super.key, required this.file});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              const SizedBox(height: 12), // More space between the video and controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                        isPlaying = !isPlaying;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop, size: 40, color: Colors.red),
                    onPressed: () {
                      _controller.seekTo(Duration.zero);
                      setState(() {
                        isPlaying = false;
                      });
                    },
                  ),
                ],
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
