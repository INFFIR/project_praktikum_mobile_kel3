// lib/app/modules/transaction/controllers/invoice_controller.dart

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invoice_model.dart';

class InvoiceController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observable invoice
  var invoice = Rxn<InvoiceModel>();

  // Observable for loading state
  var isLoading = false.obs;

  // Function to fetch an invoice by transactionId
  Future<void> fetchInvoice(String transactionId) async {
    isLoading.value = true;

    try {
      // Query invoices by transactionId
      QuerySnapshot snapshot = await firestore
          .collection('invoices')
          .where('transactionId', isEqualTo: transactionId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming one invoice per transaction
        var doc = snapshot.docs.first;
        invoice.value =
            InvoiceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Get.snackbar("Error", "Invoice not found",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch invoice: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Future function to fetch invoices (for history)
  void fetchInvoices() {
    // Implement fetching invoices from Firestore
  }
}
