part of 'data_checkout_bloc.dart';

class DataCheckoutState {}

class DataCheckoutInitial extends DataCheckoutState {}

class DataCheckoutLoading extends DataCheckoutState {}

class DataCheckoutLoaded extends DataCheckoutState {
  Map<String, dynamic> dataCheckout;
  DataCheckoutLoaded({
    required this.dataCheckout,
  });
}

class DataCheckoutError extends DataCheckoutState {}
