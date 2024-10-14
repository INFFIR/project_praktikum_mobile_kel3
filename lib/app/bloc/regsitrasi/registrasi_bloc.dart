import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'registrasi_event.dart';
part 'registrasi_state.dart';
part 'registrasi_bloc.freezed.dart';

class RegistrasiBloc extends Bloc<RegistrasiEvent, RegistrasiState> {
  RegistrasiBloc() : super(const _Initial()) {
    on<RegistrasiEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
