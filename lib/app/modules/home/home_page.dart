import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/get_products/get_products_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/list_product_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_product/detail_product.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/widgets/category_bar.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/home/widgets/top_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<GetProductsBloc>().add(DoGetProductsEvent());
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
            TopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CategoryBar(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          BlocBuilder<GetProductsBloc, GetProductsState>(
                            builder: (context, state) {
                              if (state is GetProductsError) {
                                return Center(
                                  child: Text(state.hasil),
                                );
                              }

                              if (state is GetProductsLoaded) {
                                if (state.data.data!.isEmpty) {
                                  return const Center(
                                    child: Text('Data Kosong'),
                                  );
                                }

                                return GridView.builder(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        2, // Atur sesuai kebutuhan Anda
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    mainAxisExtent: 260,
                                  ),
                                  itemCount: state.data.data!
                                      .length, // Atur jumlah item di GridView
                                  itemBuilder: (context, index) {
                                    final Product product =
                                        state.data.data![index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailProduct(
                                              idProduct: product.id!,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: 174,
                                                width: 161,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      '$urlBase${product.attributes!.productCover!.data!.attributes!.url}',
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                  color:
                                                      const Color(0xffF2F2F2),
                                                ),
                                              ),
                                              Positioned(
                                                right: 12,
                                                top: 12,
                                                child: Container(
                                                  height: 35,
                                                  width: 37,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: colorWhite,
                                                  ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons
                                                          .favorite_border_rounded,
                                                      size: 25,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            product.attributes!.productName!,
                                            style: poppinsBlack.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            CurrencyFormat.convertToIdr(
                                                product
                                                    .attributes!.productPrice!,
                                                0),
                                            style: poppinsBlack.copyWith(
                                              fontSize: 12,
                                              color:
                                                  colorBlack.withOpacity(0.4),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
