import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:project_praktikum_mobile_kel3/app/data/datasources/order_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/list_order_response_model.dart';

part 'list_order_bloc.freezed.dart';
part 'list_order_event.dart';
part 'list_order_state.dart';

class ListOrderBloc extends Bloc<ListOrderEvent, ListOrderState> {
  final OrderRemoteDatasource datasource;
  ListOrderBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_GetListOrder>((event, emit) async {
      emit(const _Loading());
      final result = await datasource.listOrder();
      result.fold(
        (l) => emit(const _Error()),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
