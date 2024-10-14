import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';

import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/product_detail_response_model.dart';

class ProductItem extends StatelessWidget {
  final ProductDetailResponseModelData dataProduct;
  const ProductItem({
    super.key,
    required this.dataProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        right: 25,
        bottom: 25,
        left: 25,
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
                    Text(
                      CurrencyFormat.convertToIdr(
                          dataProduct.attributes.productPrice, 0),
                      style: poppinsBlack.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context
                          .read<CheckoutBloc>()
                          .add(RemoveAllByIDFromCart(id: dataProduct.id));
                    },
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      color: Color(0xffF60000),
                    ),
                  ),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      if (state is CheckoutLoaded) {
                        final countItem = state.items
                            .where((element) => element.id == dataProduct.id)
                            .length;
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<CheckoutBloc>().add(
                                    RemoveFromCartEvent(data: dataProduct));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: colorBlack.withOpacity(0.4),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 9),
                              child: Text(
                                countItem.toString(),
                                style: poppinsBlack.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<CheckoutBloc>()
                                    .add(AddToCartEvent(data: dataProduct));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: colorBlack.withOpacity(0.4),
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.add,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: colorBlack.withOpacity(0.4),
                              ),
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                            child: const Icon(
                              Icons.remove,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 9),
                            child: Text(
                              '2',
                              style: poppinsBlack.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: colorBlack.withOpacity(0.4),
                              ),
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
