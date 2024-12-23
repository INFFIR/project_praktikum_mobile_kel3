import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';

class PaymentController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observable list pembayaran (jika ingin menampilkan riwayat)
  var payments = <PaymentModel>[].obs;

  // Observable untuk loading state
  var isLoading = false.obs;

  // Fungsi untuk inisiasi pembayaran
  Future<String?> makePayment({
    required String userId,
    required String productId,
    required double amount,
    required String paymentMethod,
  }) async {
    isLoading.value = true;
    try {
      // Buat dokumen payment baru
      DocumentReference docRef = await firestore.collection('payments').add({
        'userId': userId,
        'productId': productId,
        'amount': amount,
        'paymentMethod': paymentMethod, // Diset ke "QR Payment"
        'status': 'completed', // Atau 'pending' jika terintegrasi gateway
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Buat invoice terhubung dengan payment ini
      await firestore.collection('invoices').add({
        'userId': userId,
        'transactionId': docRef.id,
        'amount': amount,
        'details': 'Payment for product $productId',
        'status': 'paid',
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Payment Successful",
        snackPosition: SnackPosition.BOTTOM,
      );
      return docRef.id;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Payment Failed: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Contoh: Fungsi fetchPayments (untuk history)
  void fetchPayments() {
    // Implementasi jika dibutuhkan
  }
}
