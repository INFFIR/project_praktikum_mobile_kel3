// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'checkout_bloc.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  List<ProductDetailResponseModelData> items;
  CheckoutLoaded({
    required this.items,
  });
}

class CheckoutError extends CheckoutState {}
