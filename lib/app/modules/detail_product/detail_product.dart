// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/detail_product/detail_product_bloc.dart';

import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/product_detail_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_product/widgets/bottom_nav_bar_detail_product.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_product/widgets/detail_image_product.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_product/widgets/top_bar_detail_product.dart';

class DetailProduct extends StatefulWidget {
  final int idProduct;
  const DetailProduct({
    super.key,
    required this.idProduct,
  });

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  void initState() {
    context
        .read<DetailProductBloc>()
        .add(DoGetDetailProduct(id: widget.idProduct));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Column(
            children: [
              const TopBarDetailProduct(),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocBuilder<DetailProductBloc, DetailProductState>(
                  builder: (context, state) {
                    if (state is DetailProductError) {
                      return Center(
                        child: Text(state.hasilError),
                      );
                    }

                    if (state is DetailProductLoaded) {
                      final ProductDetailResponseModelData product =
                          state.data.data;
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailImageProduct(
                                  urlImage: product.attributes.productCover.data
                                      .attributes.url),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                product.attributes.productName,
                                style: poppinsBlack.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 24,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '4.5/5',
                                        style: poppinsBlack.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '(45 reviews)',
                                        style: poppinsBlack.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: colorBlack.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 21,
                              ),
                              Text(
                                product.attributes.productDescription,
                                style: poppinsBlack.copyWith(
                                  fontSize: 16,
                                  color: colorBlack.withOpacity(0.4),
                                ),
                              ),
                              const SizedBox(
                                height: 21,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<DetailProductBloc, DetailProductState>(
        builder: (context, state) {
          if (state is DetailProductLoaded) {
            return BottomNavBarDetailProduct(
                dataProduct: state.data.data,
                price: state.data.data.attributes.productPrice);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
