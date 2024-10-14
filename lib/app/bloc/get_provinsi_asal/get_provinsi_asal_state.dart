part of 'get_provinsi_asal_bloc.dart';

sealed class GetProvinsiAsalState {}

final class GetProvinsiAsalInitial extends GetProvinsiAsalState {}

final class GetProvinsiAsalLoading extends GetProvinsiAsalState {}

final class GetProvinsiAsalLoaded extends GetProvinsiAsalState {
  final List<ProvinsiModelResponse> dataProvinsi;
  GetProvinsiAsalLoaded({
    required this.dataProvinsi,
  });
}

final class GetProvinsiAsalError extends GetProvinsiAsalState {
  final String error;
  GetProvinsiAsalError({required this.error});
}
