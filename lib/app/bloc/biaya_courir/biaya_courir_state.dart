part of 'biaya_courir_bloc.dart';

sealed class BiayaCourirState {}

final class BiayaCourirInitial extends BiayaCourirState {}

final class BiayaCourirLoading extends BiayaCourirState {}

final class BiayaCourirLoaded extends BiayaCourirState {
  final List<CourirModalResponse> dataCourir;
  BiayaCourirLoaded({required this.dataCourir});
}

final class BiayaCourirError extends BiayaCourirState {
  final String error;
  BiayaCourirError({required this.error});
}
