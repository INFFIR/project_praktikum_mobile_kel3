import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/add_voucher/add_voucher_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/biaya_courir/biaya_courir_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/data_checkout/data_checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/detail_product/detail_product_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_kota_asal/get_kota_asal_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_kota_tujuan/get_kota_tujuan_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_products/get_products_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_provinsi_asal/get_provinsi_asal_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_provinsi_tujuan/get_provinsi_tujuan_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/list_order/list_order_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/login/login_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/order/order_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/register/register_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/search/search_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/order_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/product_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/raja_ongkir_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/voucher_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/first_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetProductsBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DetailProductBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => GetProvinsiAsalBloc(RajaOngkirDatasource()),
        ),
        BlocProvider(
          create: (context) => GetKotaAsalBloc(RajaOngkirDatasource()),
        ),
        BlocProvider(
          create: (context) => GetProvinsiTujuanBloc(RajaOngkirDatasource()),
        ),
        BlocProvider(
          create: (context) => GetKotaTujuanBloc(RajaOngkirDatasource()),
        ),
        BlocProvider(
          create: (context) => BiayaCourirBloc(RajaOngkirDatasource()),
        ),
        BlocProvider(
          create: (context) => DataCheckoutBloc(),
        ),
        BlocProvider(
          create: (context) => AddVoucherBloc(VoucherDatasource()),
        ),
        BlocProvider(
          create: (context) => OrderBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SearchBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ListOrderBloc(OrderRemoteDatasource()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const FirstPage(),
      ),
    );
  }
}
