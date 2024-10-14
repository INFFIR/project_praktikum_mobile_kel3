part of 'get_kota_tujuan_bloc.dart';

sealed class GetKotaTujuanState {}

final class GetKotaTujuanInitial extends GetKotaTujuanState {}

final class GetKotaTujuanLoading extends GetKotaTujuanState {}

final class GetKotaTujuanLoaded extends GetKotaTujuanState {
  final List<KotaModelResponse> dataKota;
  GetKotaTujuanLoaded({required this.dataKota});
}

final class GetKotaTujuanError extends GetKotaTujuanState {
  final String error;
  GetKotaTujuanError({required this.error});
}
