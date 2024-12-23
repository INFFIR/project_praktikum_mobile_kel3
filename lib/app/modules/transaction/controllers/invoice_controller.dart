import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/invoice_model.dart';

class InvoiceController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Observable invoice
  var invoice = Rxn<InvoiceModel>();

  // Observable untuk loading state
  var isLoading = false.obs;

  // Fungsi untuk fetch invoice berdasarkan transactionId
  Future<void> fetchInvoice(String transactionId) async {
    isLoading.value = true;
    try {
      final QuerySnapshot snapshot = await firestore
          .collection('invoices')
          .where('transactionId', isEqualTo: transactionId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        invoice.value =
            InvoiceModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        Get.snackbar("Error", "Invoice not found",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to fetch invoice: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Contoh: Fungsi fetchInvoices (untuk history)
  void fetchInvoices() {
    // Implementasi jika dibutuhkan
  }
}
