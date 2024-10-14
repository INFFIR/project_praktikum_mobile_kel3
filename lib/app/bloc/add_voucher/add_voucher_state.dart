// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_voucher_bloc.dart';

sealed class AddVoucherState {}

class AddVoucherInitial extends AddVoucherState {}

class AddVoucherLoading extends AddVoucherState {}

class AddVoucherLoaded extends AddVoucherState {
  List<VoucherResponseModel> dataVoucer;
  AddVoucherLoaded({
    required this.dataVoucer,
  });
}

class AddVoucherError extends AddVoucherState {
  String error;
  AddVoucherError({
    required this.error,
  });
}
