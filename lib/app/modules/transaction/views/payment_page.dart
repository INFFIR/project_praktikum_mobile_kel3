// lib/app/modules/transaction/views/payment_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_praktikum_mobile_kel3/app/routes/app_routes.dart';
import '../controllers/payment_controller.dart';
import '../../product/controllers/product_controller.dart'; // Adjust the path as per your project structure

class PaymentPage extends StatelessWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.find<PaymentController>();
    final TextEditingController paymentMethodController =
        TextEditingController();

    // Retrieve arguments passed from the previous page
    final String productId = Get.arguments['productId'];
    final double amount = Get.arguments['amount'];

    // Assuming userId is obtained from ProductController or an AuthController
    final String userId = Get.find<ProductController>().currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Amount: Rp ${amount.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: paymentMethodController,
                decoration: const InputDecoration(
                  labelText: "Payment Method",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String paymentMethod = paymentMethodController.text.trim();
                  if (paymentMethod.isEmpty) {
                    Get.snackbar("Error", "Please enter a payment method",
                        snackPosition: SnackPosition.BOTTOM);
                    return;
                  }

                  // Initiate payment
                  controller
                      .makePayment(
                        userId: userId,
                        productId: productId,
                        amount: amount,
                        paymentMethod: paymentMethod,
                      )
                      .then((paymentId) {
                    if (paymentId != null) {
                      // Navigate to invoice page after payment
                      Get.toNamed(Routes.invoice, arguments: {
                        'transactionId': paymentId,
                      });
                    }
                  });
                },
                child: const Text("Pay Now"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
