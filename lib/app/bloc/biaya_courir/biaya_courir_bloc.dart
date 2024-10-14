import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/raja_ongkir_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/courir_response_model.dart';

part 'biaya_courir_event.dart';
part 'biaya_courir_state.dart';

class BiayaCourirBloc extends Bloc<BiayaCourirEvent, BiayaCourirState> {
  final RajaOngkirDatasource datasource;
  BiayaCourirBloc(this.datasource) : super(BiayaCourirInitial()) {
    on<DoGetBiayaCourirEvent>((event, emit) async {
      emit(BiayaCourirLoading());
      final result = await datasource.getCostCourir(
        event.origin,
        event.destination,
        event.weight,
        event.courier,
      );
      result.fold(
        (l) => emit(BiayaCourirError(error: l)),
        (r) => emit(BiayaCourirLoaded(dataCourir: r)),
      );
    });

    on<DoRemoveBiayaCourirEvent>((event, emit) {
      emit(BiayaCourirInitial());
    });
  }
}
