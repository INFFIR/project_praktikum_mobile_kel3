part of 'detail_product_bloc.dart';

abstract class DetailProductState {}

class DetailProductInitial extends DetailProductState {}

class DetailProductLoading extends DetailProductState {}

class DetailProductLoaded extends DetailProductState {
  final ProductDetailResponseModel data;
  DetailProductLoaded({
    required this.data,
  });
}

class DetailProductError extends DetailProductState {
  final String hasilError;
  DetailProductError({
    required this.hasilError,
  });
}
