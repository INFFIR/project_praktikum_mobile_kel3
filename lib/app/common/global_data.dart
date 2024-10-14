import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/account/account_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/home_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/my_cart/my_cart.dart';

Color colorWhite = const Color(0xffffffff);
Color colorBlack = const Color(0xff000000);

TextStyle poppinsBlack = GoogleFonts.poppins(
  fontWeight: FontWeight.w400,
  color: colorBlack,
);
TextStyle poppinsWhite = GoogleFonts.poppins(
  fontWeight: FontWeight.w400,
  color: colorWhite,
);

class CurrencyFormat {
  static String convertToIdr(int number, int decimalDigit) {
    NumberFormat currencFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp. ',
      decimalDigits: decimalDigit,
    );
    return currencFormat.format(number);
  }
}

const String urlBase = 'https://fic6-strapi.opwarnet.my.id';
// const String urlBase = 'http://192.168.0.29:1337';

class GlobalData {
  static final List widgetOptions = [
    const HomePage(),
    SafeArea(
      child: Center(
        child: Text(
          'Index 1: Favorito',
          style: poppinsBlack.copyWith(fontSize: 40),
        ),
      ),
    ),
    const SafeArea(
      child: MyCart(),
    ),
    const AccountPage(),
  ];
}
