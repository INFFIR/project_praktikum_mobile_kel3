import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/search/search_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/list_product_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/detail_product/detail_product.dart';

class SearchPage extends StatefulWidget {
  final String search;
  const SearchPage({
    super.key,
    required this.search,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchC = TextEditingController();

  @override
  void initState() {
    searchC.text = widget.search;
    context.read<SearchBloc>().add(SearchEvent.search(widget.search));
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: 53,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xffF2F2F2),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 12,
                            ),
                            child: TextField(
                              controller: searchC,
                              onSubmitted: (value) {
                                if (value.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please enter some text')));
                                } else {
                                  context
                                      .read<SearchBloc>()
                                      .add(SearchEvent.search(searchC.text));
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintStyle: poppinsBlack.copyWith(
                                  color: colorBlack.withOpacity(0.4),
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                hintText: 'Search anything',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    Container(
                      height: 53,
                      width: 53,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorBlack,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.filter_list_rounded,
                          color: colorWhite,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 24,
                            ),
                            BlocBuilder<SearchBloc, SearchState>(
                              builder: (context, state) {
                                return state.maybeWhen(
                                  orElse: () {
                                    return const Center(
                                      child: Text('Data Not Found'),
                                    );
                                  },
                                  loaded: (model) {
                                    if (model.data!.isEmpty) {
                                      return const Center(
                                        child: Text('Data Not Found'),
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
                                      itemCount: model.data!
                                          .length, // Atur jumlah item di GridView
                                      itemBuilder: (context, index) {
                                        final Product product =
                                            model.data![index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailProduct(
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
                                                      color: const Color(
                                                          0xffF2F2F2),
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
                                                            BorderRadius
                                                                .circular(10),
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
                                                product
                                                    .attributes!.productName!,
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
                                                    product.attributes!
                                                        .productPrice!,
                                                    0),
                                                style: poppinsBlack.copyWith(
                                                  fontSize: 12,
                                                  color: colorBlack
                                                      .withOpacity(0.4),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  loading: () {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
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
        ),
      ),
    );
  }
}
