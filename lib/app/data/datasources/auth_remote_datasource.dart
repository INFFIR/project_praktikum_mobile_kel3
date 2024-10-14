import 'package:dartz/dartz.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/login_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/register_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasource {
  Future<Either<String, AuthResponseModel>> login(
      LoginRequestModel model) async {
    final response = await http.post(
      Uri.parse('$urlBase/api/auth/local'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: model.toJson(),
    );

    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromRawJson(response.body));
    } else {
      return const Left('Server Error!');
    }
  }

  Future<Either<String, AuthResponseModel>> register(
      RegisterRequestModel model) async {
    final response = await http.post(
      Uri.parse('$urlBase/api/auth/local/register'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: model.toJson(),
    );
    if (response.statusCode == 200) {
      return Right(AuthResponseModel.fromRawJson(response.body));
    } else {
      return const Left('Server Error!');
    }
  }
}
