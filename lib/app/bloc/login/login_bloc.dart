import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_remote_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/login_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/auth_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource datasource;
  LoginBloc(
    this.datasource,
  ) : super(LoginInitial()) {
    on<DoLoginEvent>(_loginEvent);
  }

  Future<void> _loginEvent(LoginEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    if (event is DoLoginEvent) {
      final result = await datasource.login(event.model);
      result.fold(
        (l) => emit(LoginError()),
        (r) => emit(LoginLoaded(model: r)),
      );
    }
  }
}
