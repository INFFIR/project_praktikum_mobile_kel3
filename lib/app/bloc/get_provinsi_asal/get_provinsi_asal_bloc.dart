import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/raja_ongkir_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/provinsi_response_model.dart';

part 'get_provinsi_asal_event.dart';
part 'get_provinsi_asal_state.dart';

class GetProvinsiAsalBloc
    extends Bloc<GetProvinsiAsalEvent, GetProvinsiAsalState> {
  final RajaOngkirDatasource datasource;
  GetProvinsiAsalBloc(this.datasource) : super(GetProvinsiAsalInitial()) {
    on<DoGetProvinsiAsalEvent>((event, emit) async {
      emit(GetProvinsiAsalLoading());
      final result = await datasource.getAllProvinsi();
      result.fold(
        (l) => emit(GetProvinsiAsalError(error: l)),
        (r) => emit(GetProvinsiAsalLoaded(dataProvinsi: r)),
      );
    });
  }
}
