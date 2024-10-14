part of 'get_provinsi_tujuan_bloc.dart';

sealed class GetProvinsiTujuanState {}

final class GetProvinsiTujuanInitial extends GetProvinsiTujuanState {}

final class GetProvinsiTujuanLoading extends GetProvinsiTujuanState {}

final class GetProvinsiTujuanLoaded extends GetProvinsiTujuanState {
  final List<ProvinsiModelResponse> dataProvinsi;
  GetProvinsiTujuanLoaded({required this.dataProvinsi});
}

final class GetProvinsiTujuanError extends GetProvinsiTujuanState {
  final String error;
  GetProvinsiTujuanError({required this.error});
}
