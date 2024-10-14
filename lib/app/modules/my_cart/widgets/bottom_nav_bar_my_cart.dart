import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/add_voucher/add_voucher_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/data_checkout/data_checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_kota_asal/get_kota_asal_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_kota_tujuan/get_kota_tujuan_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_provinsi_asal/get_provinsi_asal_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_provinsi_tujuan/get_provinsi_tujuan_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_local_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/order_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/product_detail_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/auth/login_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/checkout/checkout_page.dart';

class BottomNavBarMyCart extends StatelessWidget {
  const BottomNavBarMyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      padding: const EdgeInsets.all(0),
      height: 70,
      color: Colors.white,
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          if (state is CheckoutLoaded) {
            return GestureDetector(
              onTap: () async {
                final signIn = await AuthLocalDatasource().isLogin();
                // For IdProduct
                final idProduct =
                    state.items.map((e) => IdProduct(id: e.id)).toList();
                final items = state.items
                    .map((e) => ProductDetailResponseModelData(
                        id: e.id, attributes: e.attributes))
                    .toList();
                if (signIn && state.items.isNotEmpty) {
                  if (context.mounted) {
                    context
                        .read<GetProvinsiAsalBloc>()
                        .add(DoGetProvinsiAsalEvent());
                    context
                        .read<GetProvinsiTujuanBloc>()
                        .add(DoGetProvinsiTujuanEvent());
                    context
                        .read<GetKotaAsalBloc>()
                        .add(DoRemoveKotaAsalEvent());
                    context
                        .read<GetKotaTujuanBloc>()
                        .add(DoRemoveKotaTujuanEvent());
                    context.read<AddVoucherBloc>().add(RemoveVoucherEvent());
                    context.read<DataCheckoutBloc>().add(
                          GetDataCheckoutEvent(
                            key: 'id_products',
                            value: idProduct,
                          ),
                        );
                    context.read<DataCheckoutBloc>().add(
                          GetDataCheckoutEvent(
                            key: 'items',
                            value: items,
                          ),
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckoutPage(),
                      ),
                    );
                  }
                } else if (signIn && state.items.isEmpty) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Keranjang anda masih kosong'),
                    ),
                  );
                } else {
                  if (context.mounted) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
                child: Container(
                  height: 58,
                  width: 341,
                  decoration: BoxDecoration(
                    color: colorBlack,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Checkout',
                        style: poppinsWhite.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_outlined,
                        color: colorWhite,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
