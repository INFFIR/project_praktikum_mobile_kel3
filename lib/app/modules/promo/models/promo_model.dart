// lib/app/promo/models/promo_model.dart
class PromoModel {
  final String id;
  final String imageUrl;
  final String titleText;
  final String contentText;
  final String promoLabelText;
  final String promoDescriptionText;

  PromoModel({
    required this.id,
    required this.imageUrl,
    required this.titleText,
    required this.contentText,
    required this.promoLabelText,
    required this.promoDescriptionText,
  });

  factory PromoModel.fromMap(String docId, Map<String, dynamic> data) {
    return PromoModel(
      id: docId,
      imageUrl: data['imageUrl'] ?? '',
      titleText: data['titleText'] ?? 'Judul Promo',
      contentText: data['contentText'] ?? 'Konten Promo',
      promoLabelText: data['promoLabelText'] ?? 'Label Promo',
      promoDescriptionText: data['promoDescriptionText'] ?? 'Deskripsi Promo',
    );
  }
}
