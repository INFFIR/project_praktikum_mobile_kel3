import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/voucher_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/voucher_response_model.dart';

part 'add_voucher_event.dart';
part 'add_voucher_state.dart';

class AddVoucherBloc extends Bloc<AddVoucherEvent, AddVoucherState> {
  VoucherDatasource datasource;
  AddVoucherBloc(this.datasource) : super(AddVoucherInitial()) {
    on<DoAddVoucherEvent>((event, emit) async {
      emit(AddVoucherLoading());
      final result = await datasource.getVoucher(event.kodeVoucher);
      result.fold(
        (l) => emit(AddVoucherError(error: l)),
        (r) => emit(AddVoucherLoaded(dataVoucer: r)),
      );
    });
    on<RemoveVoucherEvent>((event, emit) {
      return emit(AddVoucherLoading());
    });
  }
}
