// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderRequestModel {
  final Data? data;

  OrderRequestModel({
    this.data,
  });

  factory OrderRequestModel.fromRawJson(String str) =>
      OrderRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      OrderRequestModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  final int? totalPrice;
  final String? deliveryAddress;
  final int? shippingCost;
  final String? statusOrder;
  final List<IdProduct>? idProducts;
  final int? discount;
  final int? shoppingFee;
  final VoucherData? voucherData;
  final RajaOngkir? rajaOngkir;
  final List<dynamic>? items;
  final int? beratSemuaBarang;
  final int userId;

  Data({
    this.totalPrice,
    this.deliveryAddress,
    this.shippingCost,
    this.statusOrder,
    this.idProducts,
    this.discount,
    this.shoppingFee,
    this.voucherData,
    this.rajaOngkir,
    this.items,
    this.beratSemuaBarang,
    required this.userId,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalPrice: json["total_price"],
        deliveryAddress: json["delivery_address"],
        shippingCost: json["shipping_cost"],
        statusOrder: json["status_order"],
        idProducts: json["id_products"] == null
            ? []
            : List<IdProduct>.from(
                json["id_products"]!.map((x) => IdProduct.fromJson(x))),
        discount: json["discount"],
        shoppingFee: json["shopping_fee"],
        voucherData: json["voucher_data"] == null
            ? null
            : VoucherData.fromJson(json["voucher_data"]),
        rajaOngkir: json["raja_ongkir"] == null
            ? null
            : RajaOngkir.fromJson(json["raja_ongkir"]),
        items: json["items"] == null
            ? []
            : List<dynamic>.from(json["items"]!.map((x) => x)),
        beratSemuaBarang: json["berat_semua_barang"],
        userId: json['userId'],
      );

  Map<String, dynamic> toJson() => {
        "total_price": totalPrice,
        "delivery_address": deliveryAddress,
        "shipping_cost": shippingCost,
        "status_order": statusOrder,
        "id_products": idProducts == null
            ? []
            : List<dynamic>.from(idProducts!.map((x) => x.toJson())),
        "discount": discount,
        "shopping_fee": shoppingFee,
        "voucher_data": voucherData?.toJson(),
        "raja_ongkir": rajaOngkir?.toJson(),
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x)),
        "berat_semua_barang": beratSemuaBarang,
        "userId": userId,
      };
}

class IdProduct {
  final int? id;

  IdProduct({
    this.id,
  });

  factory IdProduct.fromRawJson(String str) =>
      IdProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IdProduct.fromJson(Map<String, dynamic> json) => IdProduct(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  @override
  bool operator ==(covariant IdProduct other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class RajaOngkir {
  final int? ongkir;
  final Provinsi? provinsiAsal;
  final Kota? kotaAsal;
  final Provinsi? provinsiTujuan;
  final Kota? kotaTujuan;
  final CourirPilihan? courirPilihan;

  RajaOngkir({
    this.ongkir,
    this.provinsiAsal,
    this.kotaAsal,
    this.provinsiTujuan,
    this.kotaTujuan,
    this.courirPilihan,
  });

  factory RajaOngkir.fromRawJson(String str) =>
      RajaOngkir.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RajaOngkir.fromJson(Map<String, dynamic> json) => RajaOngkir(
        ongkir: json["ongkir"],
        provinsiAsal: json["provinsi_asal"] == null
            ? null
            : Provinsi.fromJson(json["provinsi_asal"]),
        kotaAsal:
            json["kota_asal"] == null ? null : Kota.fromJson(json["kota_asal"]),
        provinsiTujuan: json["provinsi_tujuan"] == null
            ? null
            : Provinsi.fromJson(json["provinsi_tujuan"]),
        kotaTujuan: json["kota_tujuan"] == null
            ? null
            : Kota.fromJson(json["kota_tujuan"]),
        courirPilihan: json["courir_pilihan"] == null
            ? null
            : CourirPilihan.fromJson(json["courir_pilihan"]),
      );

  Map<String, dynamic> toJson() => {
        "ongkir": ongkir,
        "provinsi_asal": provinsiAsal?.toJson(),
        "kota_asal": kotaAsal?.toJson(),
        "provinsi_tujuan": provinsiTujuan?.toJson(),
        "kota_tujuan": kotaTujuan?.toJson(),
        "courir_pilihan": courirPilihan?.toJson(),
      };
}

class CourirPilihan {
  final String? code;
  final String? name;
  final Costs? costs;

  CourirPilihan({
    this.code,
    this.name,
    this.costs,
  });

  factory CourirPilihan.fromRawJson(String str) =>
      CourirPilihan.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourirPilihan.fromJson(Map<String, dynamic> json) => CourirPilihan(
        code: json["code"],
        name: json["name"],
        costs: json["costs"] == null ? null : Costs.fromJson(json["costs"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "costs": costs?.toJson(),
      };
}

class Costs {
  final String? service;
  final String? description;
  final Cost? cost;

  Costs({
    this.service,
    this.description,
    this.cost,
  });

  factory Costs.fromRawJson(String str) => Costs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Costs.fromJson(Map<String, dynamic> json) => Costs(
        service: json["service"],
        description: json["description"],
        cost: json["cost"] == null ? null : Cost.fromJson(json["cost"]),
      );

  Map<String, dynamic> toJson() => {
        "service": service,
        "description": description,
        "cost": cost?.toJson(),
      };
}

class Cost {
  final int? value;
  final String? etd;
  final String? note;

  Cost({
    this.value,
    this.etd,
    this.note,
  });

  factory Cost.fromRawJson(String str) => Cost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cost.fromJson(Map<String, dynamic> json) => Cost(
        value: json["value"],
        etd: json["etd"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "etd": etd,
        "note": note,
      };
}

class Kota {
  final int? cityId;
  final int? provinceId;
  final String? province;
  final String? type;
  final String? cityName;
  final int? postalCode;

  Kota({
    this.cityId,
    this.provinceId,
    this.province,
    this.type,
    this.cityName,
    this.postalCode,
  });

  factory Kota.fromRawJson(String str) => Kota.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Kota.fromJson(Map<String, dynamic> json) => Kota(
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
}

class Provinsi {
  final int? provinceId;
  final String? province;

  Provinsi({
    this.provinceId,
    this.province,
  });

  factory Provinsi.fromRawJson(String str) =>
      Provinsi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Provinsi.fromJson(Map<String, dynamic> json) => Provinsi(
        provinceId: json["province_id"],
        province: json["province"],
      );

  Map<String, dynamic> toJson() => {
        "province_id": provinceId,
        "province": province,
      };
}

class VoucherData {
  final int? id;
  final Attributes? attributes;

  VoucherData({
    this.id,
    this.attributes,
  });

  factory VoucherData.fromRawJson(String str) =>
      VoucherData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VoucherData.fromJson(Map<String, dynamic> json) => VoucherData(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : Attributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class Attributes {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final String? codeVoucher;
  final int? potonganPersen;

  Attributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.codeVoucher,
    this.potonganPersen,
  });

  factory Attributes.fromRawJson(String str) =>
      Attributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        codeVoucher: json["code_voucher"],
        potonganPersen: json["potongan_persen"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "code_voucher": codeVoucher,
        "potongan_persen": potonganPersen,
      };
}
