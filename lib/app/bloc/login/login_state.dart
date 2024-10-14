part of 'login_bloc.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final AuthResponseModel model;
  LoginLoaded({
    required this.model,
  });
}

class LoginError extends LoginState {}
