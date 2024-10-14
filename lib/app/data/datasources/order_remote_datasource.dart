import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_local_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/order_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/list_order_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/order_response_model.dart';

class OrderRemoteDatasource {
  Future<Either<String, OrderResponseModel>> order(
      OrderRequestModel requestModel) async {
    final tokenJwt = await AuthLocalDatasource().getToken();
    final response = await http.post(
      Uri.parse('$urlBase/api/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenJwt',
      },
      body: requestModel.toRawJson(),
    );

    if (response.statusCode == 200) {
      return Right(OrderResponseModel.fromJson(response.body));
    } else {
      return const Left('Server Error');
    }
  }

  Future<Either<String, ListOrderResponseModel>> listOrder() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse(
          '$urlBase/api/orders?populate[id_products][populate][0]=product_cover&filters[userId][\$eq]=${authData.user.id}&sort=id:desc'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData.jwt}',
      },
    );

    if (response.statusCode == 200) {
      return Right(ListOrderResponseModel.fromJson(json.decode(response.body)));
    } else {
      return const Left('Server Error');
    }
  }
}
