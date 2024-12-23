// lib/app/product/models/product_model.dart
class ProductModel {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final int likes;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.likes,
    required this.description,
  });

  factory ProductModel.fromMap(String docId, Map<String, dynamic> data) {
    return ProductModel(
      id: docId,
      name: data['name'] ?? 'Nama Produk Tidak Tersedia',
      price: data['price'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      likes: data['likes'] ?? 0,
      description: data['description'] ?? 'Tidak ada deskripsi',
    );
  }
}
