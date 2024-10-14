import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:project_praktikum_mobile_kel3/app/data/datasources/product_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/list_product_response_model.dart';

part 'search_bloc.freezed.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRemoteDatasource datasource;
  SearchBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_Search>((event, emit) async {
      emit(const _Loading());
      final result = await datasource.search(event.name);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
