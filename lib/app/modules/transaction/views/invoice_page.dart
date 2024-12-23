// lib/app/modules/transaction/views/invoice_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';
import '../controllers/invoice_controller.dart';


class InvoicePage extends StatelessWidget {
  InvoicePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InvoiceController controller = Get.find<InvoiceController>();

    // Retrieve arguments passed from the PaymentPage
    final String transactionId = Get.arguments['transactionId'];

    // Fetch invoice when the page is built
    controller.fetchInvoice(transactionId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoice"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.invoice.value == null) {
          return const Center(child: Text("Invoice not found."));
        }

        final invoice = controller.invoice.value!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Invoice ID: ${invoice.invoiceId}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Transaction ID: ${invoice.transactionId}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Amount: Rp ${invoice.amount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Details: ${invoice.details}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                "Status: ${invoice.status}",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Additional invoice details can be added here
              ElevatedButton(
                onPressed: () {
                  // Navigate back to home or any other desired page
                  Get.offAllNamed(Routes.home);
                },
                child: const Text("Back to Home"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
