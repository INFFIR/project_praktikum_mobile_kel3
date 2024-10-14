// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'checkout_bloc.dart';

abstract class CheckoutEvent {}

class AddToCartEvent extends CheckoutEvent {
  final ProductDetailResponseModelData data;
  AddToCartEvent({
    required this.data,
  });
}

class RemoveFromCartEvent extends CheckoutEvent {
  final ProductDetailResponseModelData data;
  RemoveFromCartEvent({
    required this.data,
  });
}

class RemoveAllByIDFromCart extends CheckoutEvent {
  final int id;
  RemoveAllByIDFromCart({
    required this.id,
  });
}

class RemoveAllFromCartEvent extends CheckoutEvent {}
