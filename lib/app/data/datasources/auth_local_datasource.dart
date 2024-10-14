import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/auth_response_model.dart';

class AuthLocalDatasource {
  Future<bool> saveAuthData(AuthResponseModel model) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await pref.setString('auth', jsonEncode(model.toJson()));
    return result;
  }

  Future<bool> removeAuthData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.remove('auth');
  }

  Future<String> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    final authData = AuthResponseModel.fromJson(jsonDecode(authJson));
    return authData.jwt;
  }

  Future<bool> isLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth');
    return authJson != null;
  }

  Future<User> getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    final authData = AuthResponseModel.fromJson(jsonDecode(authJson));
    return authData.user;
  }

  Future<int> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    final authData = AuthResponseModel.fromJson(jsonDecode(authJson));
    return authData.user.id;
  }

  Future<AuthResponseModel> getAuthData() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final authJson = pref.getString('auth') ?? '';
    final authData = AuthResponseModel.fromJson(jsonDecode(authJson));
    return authData;
  }
}
