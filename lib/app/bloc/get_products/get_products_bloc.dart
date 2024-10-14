// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

import 'package:project_praktikum_mobile_kel3/app/data/datasources/product_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/list_product_response_model.dart';

part 'get_products_event.dart';
part 'get_products_state.dart';

class GetProductsBloc extends Bloc<GetProductsEvent, GetProductsState> {
  final ProductRemoteDatasource datasource;
  GetProductsBloc(
    this.datasource,
  ) : super(GetProductsInitial()) {
    on<DoGetProductsEvent>((event, emit) async {
      emit(GetProductsLoading());
      final result = await datasource.getAllProduct();
      result.fold(
        (l) => emit(GetProductsError(hasil: l)),
        (r) => emit(GetProductsLoaded(data: r)),
      );
    });
  }
}
