import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/order_request_model.dart';

part 'data_checkout_event.dart';
part 'data_checkout_state.dart';

class DataCheckoutBloc extends Bloc<DataCheckoutEvent, DataCheckoutState> {
  DataCheckoutBloc()
      : super(DataCheckoutLoaded(dataCheckout: {
          'discount': 0,
          'shopping_fee': 1000,
          'discount_persen': 0,
          'ongkir': 0,
          'subTotal': 0,
          'total': 0,
          'berat_barang': 0,
          'provinsi_asal': {
            "province_id": 11,
            "province": "Jawa Timur",
          },
          "kota_asal": {
            "city_id": "409",
            "province_id": "11",
            "province": "Jawa Timur",
            "type": "Kabupaten",
            "city_name": "Sidoarjo",
            "postal_code": "61219"
          },
          'shipping_address': '',
          'voucher': VoucherData(),
          'provinsi_tujuan': {},
          'kota_tujuan': {},
          'courir_pilihan': {},
          'items': [],
          'id_products': [],
        })) {
    on<GetDataCheckoutEvent>((event, emit) {
      final currentState = state as DataCheckoutLoaded;
      emit(DataCheckoutLoading());
      if (currentState.dataCheckout.containsKey(event.key)) {
        return emit(DataCheckoutLoaded(dataCheckout: {
          ...currentState.dataCheckout,
          event.key: currentState.dataCheckout[event.key] = event.value
        }));
      } else {
        return emit(DataCheckoutLoaded(dataCheckout: {
          ...currentState.dataCheckout,
          event.key: event.value
        }));
      }
    });
  }
}
