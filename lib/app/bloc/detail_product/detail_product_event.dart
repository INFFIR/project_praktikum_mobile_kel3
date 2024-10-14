// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_product_bloc.dart';

abstract class DetailProductEvent {}

class DoGetDetailProduct extends DetailProductEvent {
  final int id;
  DoGetDetailProduct({
    required this.id,
  });
}
