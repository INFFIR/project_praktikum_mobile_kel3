// lib/app/modules/transaction/controllers/payment_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_model.dart';

class PaymentController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observable list of payments (for future history feature)
  var payments = <PaymentModel>[].obs;

  // Observable for loading state
  var isLoading = false.obs;

  // Function to initiate a payment
  Future<String?> makePayment({
    required String userId,
    required String productId,
    required double amount,
    required String paymentMethod,
  }) async {
    isLoading.value = true;

    try {
      // Create a new payment document
      DocumentReference docRef = await firestore.collection('payments').add({
        'userId': userId,
        'productId': productId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'status': 'completed', // Change to 'pending' if integrating with payment gateways
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Optionally, create an invoice linked to this payment
      await firestore.collection('invoices').add({
        'userId': userId,
        'transactionId': docRef.id,
        'amount': amount,
        'details': 'Payment for product $productId',
        'status': 'paid',
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Payment Successful",
          snackPosition: SnackPosition.BOTTOM);

      return docRef.id;
    } catch (e) {
      Get.snackbar("Error", "Payment Failed: $e",
          snackPosition: SnackPosition.BOTTOM);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Future function to fetch payments (for history)
  void fetchPayments() {
    // Implement fetching payments from Firestore
  }
}
