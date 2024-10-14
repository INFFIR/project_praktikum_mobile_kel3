part of 'get_kota_tujuan_bloc.dart';

sealed class GetKotaTujuanEvent {}

class DoGetKotaTujuanEvent extends GetKotaTujuanEvent {
  int id;
  DoGetKotaTujuanEvent(this.id);
}

class DoRemoveKotaTujuanEvent extends GetKotaTujuanEvent {}
