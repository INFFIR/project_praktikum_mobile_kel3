import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/checkout/checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/data_checkout/data_checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/checkout/widgets/courir_destination.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/checkout/widgets/product_item_cart.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerAlamat = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Checkout Page'),
        backgroundColor: colorWhite,
        forceMaterialTransparency: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          context
              .read<DataCheckoutBloc>()
              .add(GetDataCheckoutEvent(key: 'discount_persen', value: 0));
          context
              .read<DataCheckoutBloc>()
              .add(GetDataCheckoutEvent(key: 'ongkir', value: 0));
          context
              .read<DataCheckoutBloc>()
              .add(GetDataCheckoutEvent(key: 'shipping_address', value: ''));
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shopping Cart',
                        style: poppinsBlack.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.blue[400],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Keep Shoping',
                            style: poppinsBlack.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      if (state is CheckoutLoaded) {
                        final uniqItem = state.items.toSet().length;
                        final dataSet = state.items.toSet();
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: uniqItem,
                          itemBuilder: (context, index) {
                            return ProductItemCart(
                                dataProduct: dataSet.elementAt(index));
                          },
                        );
                      }
                      return Center(
                          child: Text(
                        'Data anda kosong',
                        style: poppinsBlack,
                      ));
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping Address',
                        style: poppinsBlack.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Change',
                            style: poppinsBlack.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    style: poppinsBlack,
                    controller: controllerAlamat,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Masukkan alamat anda',
                      hintStyle: poppinsBlack.copyWith(
                        color: colorBlack.withOpacity(0.4),
                      ),
                    ),
                    onSubmitted: (value) {
                      context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                          key: 'shipping_address', value: value));
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Courir and Destination',
                        style: poppinsBlack.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const CourirDestination(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
