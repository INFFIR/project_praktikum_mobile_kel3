import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/register_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/auth_response_model.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDatasource datasource;
  RegisterBloc(this.datasource) : super(const _Initial()) {
    on<_Register>((event, emit) async {
      emit(const _Loading());
      final result = await datasource.register(event.model);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
