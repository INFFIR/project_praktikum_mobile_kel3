part of 'get_kota_asal_bloc.dart';

sealed class GetKotaAsalState {}

final class GetKotaAsalInitial extends GetKotaAsalState {}

final class GetKotaAsalLoading extends GetKotaAsalState {}

final class GetKotaAsalLoaded extends GetKotaAsalState {
  final List<KotaModelResponse> dataKota;
  GetKotaAsalLoaded({required this.dataKota});
}

final class GetKotaAsalError extends GetKotaAsalState {
  final String error;
  GetKotaAsalError({required this.error});
}
