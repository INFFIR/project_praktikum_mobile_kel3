import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Pastikan import ini
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';
import '../controllers/payment_controller.dart';
import '../../product/controllers/product_controller.dart'; // Sesuaikan path Anda

class PaymentPage extends StatelessWidget {
  PaymentPage({Key? key}) : super(key: key);

  /// Fungsi untuk menghasilkan link atau data teks yang akan dijadikan QR
  String generatePaymentLink({
    required String userId,
    required String productId,
    required double amount,
  }) {
    // Contoh format link: https://mywebsite.com/pay?user=xxx&product=xxx&amount=xxx
    // Silakan ubah sesuai kebutuhan Anda.
    // return "https://mywebsite.com/pay?user=$userId&product=$productId&amount=$amount";
    return "https://youtu.be/ZPt9w-p6q9I?si=LXFDS-PkiBqFshsd";
  }

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.find<PaymentController>();

    // Data yang diterima dari halaman sebelumnya
    final String productId = Get.arguments['productId'];
    final double amount = Get.arguments['amount'];

    // Contoh: Mendapatkan userId dari ProductController (atau AuthController)
    final String userId = Get.find<ProductController>().currentUserId;

    // Buat link atau teks yang akan diubah menjadi QR
    final String paymentData =
        generatePaymentLink(userId: userId, productId: productId, amount: amount);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF2F2F2), Color(0xFFECECEC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bagian atas: informasi total pembayaran
                    Text(
                      "Total Payment",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Rp ${amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Petunjuk
                    Text(
                      "Scan this QR to Pay",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Generate QR code menggunakan QrImageView (versi terbaru qr_flutter)
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: QrImageView(
                          // Data/link yang akan dijadikan QR
                          data: paymentData,
                          version: QrVersions.auto,  // Otomatis menyesuaikan
                          size: 180.0,              // Ukuran QR
                          gapless: true,            // QR tanpa jarak putih antar blok
                          // foregroundColor: Colors.black, // Ubah warna jika ingin
                          // embeddedImage: AssetImage('assets/logo.png'), // Jika mau ada logo
                          // embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Tombol Pay Now
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Jalankan proses pembayaran
                          controller
                              .makePayment(
                                userId: userId,
                                productId: productId,
                                amount: amount,
                                paymentMethod: "QR Payment",
                              )
                              .then((paymentId) {
                            if (paymentId != null) {
                              // Setelah berhasil, navigasi ke halaman Invoice
                              Get.toNamed(
                                Routes.invoice,
                                arguments: {'transactionId': paymentId},
                              );
                            }
                          });
                        },
                        child: const Text(
                          "Pay Now",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
