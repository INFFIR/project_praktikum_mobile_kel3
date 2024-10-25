import 'package:flutter/material.dart';

class DetailProductPage extends StatefulWidget {
  const DetailProductPage({super.key});

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  // Image is now a static asset instead of being picked
  final String _imageAssetPath = 'assets/product/product0.jpg';

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
              child: Image.asset(
                _imageAssetPath,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              children: [
                Text(
                  '4.5',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  '/5',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(width: 16),
                Icon(Icons.star, color: Colors.yellow, size: 30),
                Icon(Icons.star, color: Colors.yellow, size: 30),
                Icon(Icons.star, color: Colors.yellow, size: 30),
                Icon(Icons.star, color: Colors.yellow, size: 30),
                Icon(Icons.star_half, color: Colors.yellow, size: 30),
              ],
            ),
            const SizedBox(height: 8),
            const Text('999+ reviews', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            const Text(
              'Most Mentioned:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTag('Comfortable'),
                const SizedBox(width: 8),
                _buildTag('Best'),
                const SizedBox(width: 8),
                _buildTag('Fast Delivery'),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildReview('4.2', 'Amat', '1 Jan 2024', 'Recommended item and according to order'),
                  _buildReview('4.7', 'Amat', '10 Jan 2024', 'Best stuff!!!'),
                  _buildReview('4.4', 'Agus', '17 Jan 2024', 'Very Fast Shipping!'),
                  _buildReview('4.0', 'Ijay', '30 Jan 2024', 'The courier was not friendly, but the goods arrived safely!'),
                  _buildReview('3.0', 'Asrul', '5 Apr 2024', 'The expedition was very long and unfriendly'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.black,
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildReview(String rating, String reviewer, String date, String comment) {
    return Column(
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
        const SizedBox(height: 24),
      ],
    );
  }
}
