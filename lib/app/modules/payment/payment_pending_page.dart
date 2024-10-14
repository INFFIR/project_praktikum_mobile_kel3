import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/first_page.dart';

class PaymentPendingPage extends StatefulWidget {
  const PaymentPendingPage({super.key});

  @override
  State<PaymentPendingPage> createState() => _PaymentPendingPageState();
}

class _PaymentPendingPageState extends State<PaymentPendingPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: 'Payment Pending',
        desc: 'Mohon selesaikan pembayaran anda',
        btnCancelOnPress: () {
          context.read<CheckoutBloc>().add(RemoveAllFromCartEvent());
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FirstPage(),
              ));
        },
        btnCancelColor: Colors.amber,
        btnCancelText: 'List Order',
        btnOkOnPress: () {
          context.read<CheckoutBloc>().add(RemoveAllFromCartEvent());
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FirstPage(),
              ));
        },
        btnOkColor: Colors.red,
        btnOkText: 'Close',
      ).show();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
