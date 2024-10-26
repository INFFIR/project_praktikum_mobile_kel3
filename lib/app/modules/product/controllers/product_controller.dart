import 'package:get/get.dart';

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
      '', // Contoh gambar yang hilang
      'assets/product/product4.jpg',
      'assets/product/product5.jpg',
      'assets/product/nonexistent.jpg', // Contoh gambar yang tidak ada
    ]);

    products.assignAll([
      {
        'name': 'Splash some color (pink)',
        'price': '330K',
        'likes': 100.obs,
      },
      {
        'name': '', // Nama hilang
        'price': '330K',
        'likes': 200.obs,
      },
      {
        'name': 'Splash some color (yellow)',
        'price': null, // Harga hilang
        'likes': 150.obs,
      },
      {
        'name': 'Splash all color',
        'price': '900K',
        'likes': null, // Likes hilang
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
        'name': null, // Nama null
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

    void addProduct({
    required String name,
    required String price,
    required String image,
  }) {
    products.add({
      'name': name,
      'price': price,
      'likes': 0.obs,
    });
    productImages.add(image);
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
    required String image,
  }) {
    if (index >= 0 && index < products.length) {
      products[index]['name'] = name;
      products[index]['price'] = price;
      productImages[index] = image;
    }
  }
}
