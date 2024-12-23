// lib/app/modules/transaction/bindings/invoice_binding.dart

import 'package:get/get.dart';
import '../controllers/invoice_controller.dart';

class InvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceController>(() => InvoiceController());
  }
}
