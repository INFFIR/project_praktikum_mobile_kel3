import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/courir_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/kota_response_model.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/provinsi_response_model.dart';
import 'package:http/http.dart' as http;

class RajaOngkirDatasource {
  Future<Either<String, List<ProvinsiModelResponse>>> getAllProvinsi() async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");
    try {
      final response = await http.get(
        url,
        headers: {
          'key': 'bbb6ad40f7e226bda8661e2aee11e0d4',
        },
      );
      final dataTampung = json.decode(response.body);
      final statusCode = dataTampung['rajaongkir']['status']['code'];
      if (statusCode != 200) {
        throw dataTampung['rajaongkir']['status']['description'];
      }
      final dataProvinsi = dataTampung['rajaongkir']['results'];
      final toModel = ProvinsiModelResponse.fromJsonList(dataProvinsi);
      return Right(toModel);
    } catch (error) {
      return const Left('Ada masalah pencarian provinsi');
    }
  }

  Future<Either<String, List<KotaModelResponse>>> getKotaByProvinsi(
      int id) async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/city?province=$id");
    try {
      final response = await http.get(
        url,
        headers: {
          "key": "bbb6ad40f7e226bda8661e2aee11e0d4",
        },
      );
      final dataTampung = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = dataTampung['rajaongkir']['status']['code'];
      if (statusCode != 200) {
        throw dataTampung['rajaongkir']['status']['description'];
      }
      var dataKota = dataTampung["rajaongkir"]["results"] as List<dynamic>;
      var toModel = KotaModelResponse.fromJsonList(dataKota);
      return Right(toModel);
    } catch (e) {
      return const Left('Ada masalah pencarian Kota');
    }
  }

  Future<Either<String, List<CourirModalResponse>>> getCostCourir(
    String origin,
    String destination,
    String weight,
    String courier,
  ) async {
    Uri url = Uri.parse('https://api.rajaongkir.com/starter/cost');
    try {
      final response = await http.post(
        url,
        headers: {
          "key": "bbb6ad40f7e226bda8661e2aee11e0d4",
          'content-type': 'application/x-www-form-urlencoded',
        },
        body: {
          'origin': origin,
          'destination': destination,
          'weight': weight,
          'courier': courier,
        },
      );
      final dataTampung = json.decode(response.body) as Map<String, dynamic>;
      final statusCode = dataTampung['rajaongkir']['status']['code'];
      if (statusCode != 200) {
        throw dataTampung['rajaongkir']['status']['description'];
      }
      final dataCost = dataTampung['rajaongkir']['results'] as List<dynamic>;
      final toModel = CourirModalResponse.fromJsonList(dataCost);
      return Right(toModel);
    } catch (e) {
      return const Left('Ada masalah pencarian biaya kurir');
    }
  }
}
