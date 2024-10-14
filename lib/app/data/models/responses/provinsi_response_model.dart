import 'dart:convert';

class ProvinsiModelResponse {
  final String provinceId;
  final String province;

  ProvinsiModelResponse({
    required this.provinceId,
    required this.province,
  });

  factory ProvinsiModelResponse.fromRawJson(String str) =>
      ProvinsiModelResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProvinsiModelResponse.fromJson(Map<String, dynamic> json) =>
      ProvinsiModelResponse(
        provinceId: json["province_id"],
        province: json["province"],
      );

  Map<String, dynamic> toJson() => {
        "province_id": provinceId,
        "province": province,
      };

  static List<ProvinsiModelResponse> fromJsonList(List list) {
    if (list.isEmpty) return List<ProvinsiModelResponse>.empty();
    return list
        .map((dataProvinsi) => ProvinsiModelResponse.fromJson(dataProvinsi))
        .toList();
  }
}
