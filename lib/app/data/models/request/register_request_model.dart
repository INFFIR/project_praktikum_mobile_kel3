// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RegisterRequestModel {
  String username;
  String email;
  String password;
  RegisterRequestModel({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory RegisterRequestModel.fromMap(Map<String, dynamic> map) {
    return RegisterRequestModel(
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterRequestModel.fromJson(String source) =>
      RegisterRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
