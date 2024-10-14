// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/product_detail_response_model.dart';

class BottomNavBarDetailProduct extends StatelessWidget {
  final ProductDetailResponseModelData dataProduct;
  final int price;
  const BottomNavBarDetailProduct({
    Key? key,
    required this.dataProduct,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      padding: const EdgeInsets.all(0),
      height: 100,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.only(
          top: 22,
          left: 24,
          bottom: 21,
          right: 25,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: Colors.black.withOpacity(0.4),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price',
                  style: poppinsBlack.copyWith(
                    color: colorBlack.withOpacity(0.4),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  CurrencyFormat.convertToIdr(price, 0),
                  style: poppinsBlack.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                if (state is CheckoutLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CheckoutLoaded) {
                  final checkData = state.items
                      .any((element) => element.id == dataProduct.id);
                  if (checkData) {
                    return InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Product Data sudah ada di Cart!'),
                        ));
                      },
                      child: Container(
                        height: 58,
                        width: 191,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: colorBlack.withOpacity(0.4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_shopping_cart_outlined,
                              color: colorWhite,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Check Cart!',
                              style: poppinsWhite.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Product Berhasil Ditambahkan~'),
                        ));
                        context
                            .read<CheckoutBloc>()
                            .add(AddToCartEvent(data: dataProduct));
                      },
                      child: Container(
                        height: 58,
                        width: 191,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: colorBlack,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              color: colorWhite,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Add to Cart',
                              style: poppinsWhite.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }
                return const Center(
                  child: Text('Error'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
