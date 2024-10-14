// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'data_checkout_bloc.dart';

class DataCheckoutEvent {}

class GetDataCheckoutEvent extends DataCheckoutEvent {
  String key;
  dynamic value;
  GetDataCheckoutEvent({
    required this.key,
    required this.value,
  });
}
