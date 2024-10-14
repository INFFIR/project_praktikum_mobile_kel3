import 'dart:convert';

class KotaModelResponse {
  final String cityId;
  final String provinceId;
  final String province;
  final String type;
  final String cityName;
  final String postalCode;

  KotaModelResponse({
    required this.cityId,
    required this.provinceId,
    required this.province,
    required this.type,
    required this.cityName,
    required this.postalCode,
  });

  factory KotaModelResponse.fromRawJson(String str) =>
      KotaModelResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory KotaModelResponse.fromJson(Map<String, dynamic> json) =>
      KotaModelResponse(
        cityId: json["city_id"],
        provinceId: json["province_id"],
        province: json["province"],
        type: json["type"],
        cityName: json["city_name"],
        postalCode: json["postal_code"],
      );

  Map<String, dynamic> toJson() => {
        "city_id": cityId,
        "province_id": provinceId,
        "province": province,
        "type": type,
        "city_name": cityName,
        "postal_code": postalCode,
      };

  static List<KotaModelResponse> fromJsonList(List list) {
    if (list.isEmpty) return List<KotaModelResponse>.empty();
    return list
        .map((dataKota) => KotaModelResponse.fromJson(dataKota))
        .toList();
  }
}
