import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/list_order/list_order_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/daftar_order/widgets/card_order_item.dart';

class DaftarOrder extends StatelessWidget {
  const DaftarOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Center(
          child: Text(
            'Daftar Transaksi',
            style: poppinsBlack.copyWith(
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ListOrderBloc, ListOrderState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return const Center(child: CircularProgressIndicator());
              },
              loaded: (data) {
                if (data.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        'Anda belum melakukan transaksi apapun',
                        style: poppinsBlack.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final dataOrder = data.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: CardOrderItem(
                        dataOrderItem: dataOrder,
                      ),
                    );
                  },
                  itemCount: data.data!.length,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
