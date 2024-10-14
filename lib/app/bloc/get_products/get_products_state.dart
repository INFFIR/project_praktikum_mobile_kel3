// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_products_bloc.dart';

abstract class GetProductsState {}

class GetProductsInitial extends GetProductsState {}

class GetProductsLoading extends GetProductsState {}

class GetProductsLoaded extends GetProductsState {
  final ListProductResponseModel data;
  GetProductsLoaded({
    required this.data,
  });
}

class GetProductsError extends GetProductsState {
  final String hasil;
  GetProductsError({
    required this.hasil,
  });
}
