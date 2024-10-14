// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class VoucherResponseModel {
  int id;
  Attributes attributes;

  VoucherResponseModel({
    required this.id,
    required this.attributes,
  });

  factory VoucherResponseModel.fromRawJson(String str) =>
      VoucherResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VoucherResponseModel.fromJson(Map<String, dynamic> json) =>
      VoucherResponseModel(
        id: json["id"],
        attributes: Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes.toJson(),
      };

  @override
  bool operator ==(covariant VoucherResponseModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.attributes == attributes;
  }

  @override
  int get hashCode => id.hashCode ^ attributes.hashCode;

  static List<VoucherResponseModel> fromJsonList(List list) {
    if (list.isEmpty) return List<VoucherResponseModel>.empty();
    return list
        .map((dataVoucher) => VoucherResponseModel.fromJson(dataVoucher))
        .toList();
  }
}

class Attributes {
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  String codeVoucher;
  int potonganPersen;

  Attributes({
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.codeVoucher,
    required this.potonganPersen,
  });

  factory Attributes.fromRawJson(String str) =>
      Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        publishedAt: DateTime.parse(json["publishedAt"]),
        codeVoucher: json["code_voucher"],
        potonganPersen: json["potongan_persen"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "publishedAt": publishedAt.toIso8601String(),
        "code_voucher": codeVoucher,
        "potongan_persen": potonganPersen,
      };

  @override
  bool operator ==(covariant Attributes other) {
    if (identical(this, other)) return true;

    return other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.publishedAt == publishedAt &&
        other.codeVoucher == codeVoucher &&
        other.potonganPersen == potonganPersen;
  }

  @override
  int get hashCode {
    return createdAt.hashCode ^
        updatedAt.hashCode ^
        publishedAt.hashCode ^
        codeVoucher.hashCode ^
        potonganPersen.hashCode;
  }
}
