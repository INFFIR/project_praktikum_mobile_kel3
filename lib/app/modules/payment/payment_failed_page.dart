import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/first_page.dart';

class PaymentFailedPage extends StatefulWidget {
  const PaymentFailedPage({super.key});

  @override
  State<PaymentFailedPage> createState() => _PaymentFailedPageState();
}

class _PaymentFailedPageState extends State<PaymentFailedPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Payment Failed',
        desc: 'Maaf Pembayaran anda gagal',
        btnOkOnPress: () {
          context.read<CheckoutBloc>().add(RemoveAllFromCartEvent());
          Navigator.push(
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
