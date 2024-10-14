// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';

import 'package:project_praktikum_mobile_kel3/app/data/models/responses/product_detail_response_model.dart';

class ProductItemCart extends StatelessWidget {
  final ProductDetailResponseModelData dataProduct;

  const ProductItemCart({
    super.key,
    required this.dataProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Container(
        height: 103,
        decoration: BoxDecoration(
          color: const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 79,
                width: 83,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      '$urlBase${dataProduct.attributes.productCover.data.attributes.url}',
                    ),
                  ),
                  border: Border.all(
                    width: 1,
                    color: colorBlack,
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
              const SizedBox(
                width: 17,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataProduct.attributes.productName,
                          style: poppinsBlack.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          CurrencyFormat.convertToIdr(
                              dataProduct.attributes.productPrice, 0),
                          style: poppinsBlack.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' x ',
                          style: poppinsBlack.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        BlocBuilder<CheckoutBloc, CheckoutState>(
                          builder: (context, state) {
                            if (state is CheckoutLoaded) {
                              final countItem = state.items
                                  .where(
                                      (element) => element.id == dataProduct.id)
                                  .length;

                              return Text(
                                '${countItem.toString()} Item (${dataProduct.attributes.productWeight} gr)',
                                style: poppinsBlack.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            return Text(
                              '',
                              style: poppinsBlack.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
