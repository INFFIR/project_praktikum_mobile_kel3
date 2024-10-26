// product_controller.dart
import 'package:get/get.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProductController extends GetxController {
  final productImages = <String>[].obs;
  final products = <Map<String, dynamic>>[].obs;
  final isFavorited = <RxBool>[].obs;

  @override
  void onInit() {
    super.onInit();

    productImages.assignAll([
      'assets/product/product0.jpg',
      'assets/product/product1.jpg',
      'assets/product/product2.jpg',
      '',
      'assets/product/product4.jpg',
      'assets/product/product5.jpg',
      'assets/product/nonexistent.jpg',
    ]);

    products.assignAll([
      {
        'name': 'Splash some color (pink)',
        'price': '330K',
        'likes': 100.obs,
      },
      {
        'name': '',
        'price': '330K',
        'likes': 200.obs,
      },
      {
        'name': 'Splash some color (yellow)',
        'price': null,
        'likes': 150.obs,
      },
      {
        'name': 'Splash all color',
        'price': '900K',
        'likes': null,
      },
      {
        'name': 'Splash some color (pink)',
        'price': '330K',
        'likes': 100.obs,
      },
      {
        'name': 'Splash some color (white)',
        'price': '330K',
        'likes': 200.obs,
      },
      {
        'name': null,
        'price': '330K',
        'likes': 100.obs,
      },
    ]);

    isFavorited.assignAll(
      List<RxBool>.generate(products.length, (_) => false.obs),
    );

    // Menangani nilai null atau hilang
    for (var i = 0; i < products.length; i++) {
      products[i]['name'] ??= 'Nama Produk Tidak Tersedia';
      products[i]['price'] ??= 'Harga Tidak Tersedia';
      products[i]['likes'] ??= 0.obs;
      productImages[i] = productImages[i].isNotEmpty
          ? productImages[i]
          : 'assets/product/default.jpg'; // Gambar default
    }
  }

  void toggleFavorite(int index) {
    if (index >= 0 && index < isFavorited.length) {
      isFavorited[index].value = !isFavorited[index].value;
      if (isFavorited[index].value) {
        products[index]['likes']++;
      } else {
        products[index]['likes']--;
      }
    }
  }

  Future<String> _saveImage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    final savedImage = await imageFile.copy('${directory.path}/$fileName');
    return savedImage.path;
  }

  void addProduct({
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    String imagePath = 'assets/product/default.jpg';
    if (imageFile != null) {
      imagePath = await _saveImage(imageFile);
    }

    products.add({
      'name': name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia',
      'price': price.isNotEmpty ? price : 'Harga Tidak Tersedia',
      'likes': 0.obs,
    });
    productImages.add(imagePath);
    isFavorited.add(false.obs);
  }

  void deleteProduct(int index) {
    if (index >= 0 && index < products.length) {
      products.removeAt(index);
      productImages.removeAt(index);
      isFavorited.removeAt(index);
    }
  }

  void editProduct(
    int index, {
    required String name,
    required String price,
    required File? imageFile,
  }) async {
    if (index >= 0 && index < products.length) {
      products[index]['name'] = name.isNotEmpty ? name : 'Nama Produk Tidak Tersedia';
      products[index]['price'] = price.isNotEmpty ? price : 'Harga Tidak Tersedia';

      if (imageFile != null) {
        String imagePath = await _saveImage(imageFile);
        productImages[index] = imagePath;
      }
    }
  }
}
