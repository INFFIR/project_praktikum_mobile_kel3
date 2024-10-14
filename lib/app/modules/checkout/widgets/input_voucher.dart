import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/add_voucher/add_voucher_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/data_checkout/data_checkout_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/order_request_model.dart';

class InputVoucher extends StatelessWidget {
  const InputVoucher({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerKodeVoucer = TextEditingController();

    return Container(
      height: 53,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          10,
        ),
        color: const Color(0xffF2F2F2),
      ),
      child: BlocConsumer<AddVoucherBloc, AddVoucherState>(
        listener: (context, state) {
          if (state is AddVoucherLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Selamat anda mendapatkan potongan sebesar ${state.dataVoucer[0].attributes.potonganPersen}%',
                ),
              ),
            );
          }
          if (state is AddVoucherError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Voucher salah')));
            context
                .read<DataCheckoutBloc>()
                .add(GetDataCheckoutEvent(key: 'discount_persen', value: 0));
            context.read<DataCheckoutBloc>().add(
                GetDataCheckoutEvent(key: 'voucher', value: VoucherData()));
          }
        },
        builder: (context, state) {
          if (state is AddVoucherLoaded) {
            context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                key: 'discount_persen',
                value: state.dataVoucer[0].attributes.potonganPersen));
            context.read<DataCheckoutBloc>().add(GetDataCheckoutEvent(
                key: 'voucher',
                value: VoucherData.fromJson(state.dataVoucer[0].toJson())));
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green[200]!,
                    offset: const Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 5.0,
                    spreadRadius: 5.0,
                  ), //BoxShadow
                  const BoxShadow(
                    color: Colors.white,
                  )
                ],
              ),
              child: TextField(
                controller: controllerKodeVoucer,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 15,
                  ),
                  hintText: 'Add a voucher anjas',
                  hintStyle: poppinsBlack.copyWith(
                    fontSize: 16,
                    color: colorBlack.withOpacity(0.4),
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  context.read<AddVoucherBloc>().add(DoAddVoucherEvent(
                      kodeVoucher: controllerKodeVoucer.text));
                },
              ),
            );
          }
          return TextField(
            controller: controllerKodeVoucer,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 15,
              ),
              hintText: 'Add a voucher',
              hintStyle: poppinsBlack.copyWith(
                fontSize: 16,
                color: colorBlack.withOpacity(0.4),
              ),
            ),
            onSubmitted: (value) {
              context.read<AddVoucherBloc>().add(
                  DoAddVoucherEvent(kodeVoucher: controllerKodeVoucer.text));
            },
          );
        },
      ),
    );
  }
}
