part of 'get_kota_asal_bloc.dart';

sealed class GetKotaAsalEvent {}

class DoGetKotaAsalEvent extends GetKotaAsalEvent {
  int id;
  DoGetKotaAsalEvent(this.id);
}

class DoRemoveKotaAsalEvent extends GetKotaAsalEvent {}
