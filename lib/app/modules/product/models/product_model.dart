// lib/app/product/models/product_model.dart
class ProductModel {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final int likes;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.likes,
  });

  // Contoh helper untuk convert dari Firestore
  factory ProductModel.fromMap(String docId, Map<String, dynamic> data) {
    return ProductModel(
      id: docId,
      name: data['name'] ?? 'Nama Produk Tidak Tersedia',
      price: data['price'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      likes: data['likes'] ?? 0,
    );
  }
}
