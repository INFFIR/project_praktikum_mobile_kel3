import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/data_checkout/data_checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/my_cart/widgets/bottom_nav_bar_my_cart.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/my_cart/widgets/product_item.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/my_cart/widgets/top_bar_my_cart.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Column(
            children: [
              const TopBarMyCart(),
              const SizedBox(
                height: 20,
              ),
              // CONTAINER CART
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BlocBuilder<CheckoutBloc, CheckoutState>(
                        builder: (context, state) {
                          if (state is CheckoutLoaded) {
                            final uniqueItem = state.items.toSet().length;
                            final dataSet = state.items.toSet();
                            final subTotal = state.items.fold(
                                0,
                                (previousValue, element) =>
                                    previousValue +
                                    element.attributes.productPrice);
                            context.read<DataCheckoutBloc>().add(
                                GetDataCheckoutEvent(
                                    key: 'subTotal', value: subTotal));
                            context.read<DataCheckoutBloc>().add(
                                GetDataCheckoutEvent(
                                    key: 'total', value: subTotal + 1000));

                            if (state.items.isEmpty) {
                              return SizedBox(
                                height: 600,
                                child: Center(
                                  child: Text(
                                    'Cart is Empty',
                                    style: poppinsBlack.copyWith(
                                      fontSize: 35,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: uniqueItem,
                                  itemBuilder: (context, index) {
                                    return ProductItem(
                                      dataProduct: dataSet.elementAt(index),
                                    );
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                  child: Divider(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                  ),
                                  child: BlocBuilder<DataCheckoutBloc,
                                      DataCheckoutState>(
                                    builder: (context, state) {
                                      if (state is DataCheckoutLoaded) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Sub-total',
                                                    style:
                                                        poppinsBlack.copyWith(
                                                      fontSize: 16,
                                                      color: colorBlack
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  CurrencyFormat.convertToIdr(
                                                      state.dataCheckout[
                                                              'subTotal'] ??
                                                          0,
                                                      0),
                                                  style: poppinsBlack.copyWith(
                                                    fontSize: 16,
                                                    color: colorBlack,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Discount (%)',
                                                    style:
                                                        poppinsBlack.copyWith(
                                                      fontSize: 16,
                                                      color: colorBlack
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  CurrencyFormat.convertToIdr(
                                                      state.dataCheckout[
                                                          'discount'],
                                                      0),
                                                  style: poppinsBlack.copyWith(
                                                    fontSize: 16,
                                                    color: colorBlack,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Shipping fee',
                                                    style:
                                                        poppinsBlack.copyWith(
                                                      fontSize: 16,
                                                      color: colorBlack
                                                          .withOpacity(0.4),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  CurrencyFormat.convertToIdr(
                                                      state.dataCheckout[
                                                          'shopping_fee'],
                                                      0),
                                                  style: poppinsBlack.copyWith(
                                                    fontSize: 16,
                                                    color: colorBlack,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Total',
                                                    style:
                                                        poppinsBlack.copyWith(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  CurrencyFormat.convertToIdr(
                                                      state.dataCheckout[
                                                              'total'] ??
                                                          0,
                                                      0),
                                                  style: poppinsBlack.copyWith(
                                                    fontSize: 18,
                                                    color: colorBlack,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        );
                                      }
                                      return const Center(
                                        child: Text('Data Kosong'),
                                      );
                                    },
                                  ),
                                )
                              ],
                            );
                          }
                          return const Column(
                            children: [
                              Center(
                                child: Text('data tidak ada'),
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarMyCart(),
    );
  }
}
