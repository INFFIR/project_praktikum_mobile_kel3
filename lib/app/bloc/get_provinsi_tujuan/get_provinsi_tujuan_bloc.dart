import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/raja_ongkir_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/provinsi_response_model.dart';

part 'get_provinsi_tujuan_event.dart';
part 'get_provinsi_tujuan_state.dart';

class GetProvinsiTujuanBloc
    extends Bloc<GetProvinsiTujuanEvent, GetProvinsiTujuanState> {
  final RajaOngkirDatasource datasource;
  GetProvinsiTujuanBloc(this.datasource) : super(GetProvinsiTujuanInitial()) {
    on<DoGetProvinsiTujuanEvent>((event, emit) async {
      emit(GetProvinsiTujuanLoading());
      final result = await datasource.getAllProvinsi();
      result.fold(
        (l) => emit(GetProvinsiTujuanError(error: l)),
        (r) => emit(GetProvinsiTujuanLoaded(dataProvinsi: r)),
      );
    });
  }
}
