import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/responses/voucher_response_model.dart';
import 'package:http/http.dart' as http;

class VoucherDatasource {
  Future<Either<String, List<VoucherResponseModel>>> getVoucher(
      String kodeVoucher) async {
    Uri url = Uri.parse(
        '$urlBase/api/vouchers?filters[code_voucher][\$eqi]=$kodeVoucher');
    try {
      final response = await http.get(url);
      final dataTampung = json.decode(response.body) as Map<String, dynamic>;
      final dataVoucher = dataTampung['data'] as List<dynamic>;
      if (dataVoucher.isNotEmpty) {
        final toModel = VoucherResponseModel.fromJsonList(dataVoucher);
        return Right(toModel);
      } else {
        return const Left('Voucher Tidak ada');
      }
    } catch (e) {
      return Left('Get Data Error : $e');
    }
  }
}
