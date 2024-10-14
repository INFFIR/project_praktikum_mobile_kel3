// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/product_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/product_detail_response_model.dart';

part 'detail_product_event.dart';
part 'detail_product_state.dart';

class DetailProductBloc extends Bloc<DetailProductEvent, DetailProductState> {
  final ProductRemoteDatasource dataSource;
  DetailProductBloc(
    this.dataSource,
  ) : super(DetailProductInitial()) {
    on<DoGetDetailProduct>((event, emit) async {
      emit(DetailProductLoading());

      final result = await dataSource.getDetailProduct(event.id);
      result.fold(
        (l) => emit(
          DetailProductError(hasilError: l),
        ),
        (r) => emit(
          DetailProductLoaded(data: r),
        ),
      );
    });
  }
}
