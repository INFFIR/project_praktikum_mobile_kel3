// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_voucher_bloc.dart';

class AddVoucherEvent {}

class DoAddVoucherEvent extends AddVoucherEvent {
  String kodeVoucher;
  DoAddVoucherEvent({
    required this.kodeVoucher,
  });
}

class RemoveVoucherEvent extends AddVoucherEvent {}
