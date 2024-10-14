import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/first_page.dart';

class PaymentSuccessPage extends StatefulWidget {
  const PaymentSuccessPage({super.key});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Payment Success',
        desc: 'Selamat Pembayaran Berhasil dilakukan',
        btnOkOnPress: () {
          context.read<CheckoutBloc>().add(RemoveAllFromCartEvent());
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FirstPage(),
              ));
        },
      ).show();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
