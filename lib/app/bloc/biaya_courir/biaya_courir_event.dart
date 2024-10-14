// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'biaya_courir_bloc.dart';

sealed class BiayaCourirEvent {}

class DoGetBiayaCourirEvent extends BiayaCourirEvent {
  String origin;
  String destination;
  String weight;
  String courier;
  DoGetBiayaCourirEvent({
    required this.origin,
    required this.destination,
    required this.weight,
    required this.courier,
  });
}

class DoRemoveBiayaCourirEvent extends BiayaCourirEvent {}
