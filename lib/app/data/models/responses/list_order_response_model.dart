import 'dart:convert';

class ListOrderResponseModel {
  List<Order>? data;
  Meta? meta;

  ListOrderResponseModel({
    this.data,
    this.meta,
  });

  factory ListOrderResponseModel.fromRawJson(String str) =>
      ListOrderResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      ListOrderResponseModel(
        data: json["data"] == null
            ? []
            : List<Order>.from(json["data"]!.map((x) => Order.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };
}

class Order {
  int? id;
  PurpleAttributes? attributes;

  Order({
    this.id,
    this.attributes,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : PurpleAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class PurpleAttributes {
  int? totalPrice;
  String? deliveryAddress;
  int? shippingCost;
  String? statusOrder;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  int? discount;
  int? shoppingFee;
  VoucherData? voucherData;
  RajaOngkir? rajaOngkir;
  List<Item>? items;
  int? beratSemuaBarang;
  int? userId;
  IdProducts? idProducts;

  PurpleAttributes({
    this.totalPrice,
    this.deliveryAddress,
    this.shippingCost,
    this.statusOrder,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.discount,
    this.shoppingFee,
    this.voucherData,
    this.rajaOngkir,
    this.items,
    this.beratSemuaBarang,
    this.userId,
    this.idProducts,
  });

  factory PurpleAttributes.fromRawJson(String str) =>
      PurpleAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PurpleAttributes.fromJson(Map<String, dynamic> json) =>
      PurpleAttributes(
        totalPrice: json["total_price"],
        deliveryAddress: json["delivery_address"],
        shippingCost: json["shipping_cost"],
        statusOrder: json["status_order"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
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
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        beratSemuaBarang: json["berat_semua_barang"],
        userId: json["userId"],
        idProducts: json["id_products"] == null
            ? null
            : IdProducts.fromJson(json["id_products"]),
      );

  Map<String, dynamic> toJson() => {
        "total_price": totalPrice,
        "delivery_address": deliveryAddress,
        "shipping_cost": shippingCost,
        "status_order": statusOrder,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "discount": discount,
        "shopping_fee": shoppingFee,
        "voucher_data": voucherData?.toJson(),
        "raja_ongkir": rajaOngkir?.toJson(),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "berat_semua_barang": beratSemuaBarang,
        "userId": userId,
        "id_products": idProducts?.toJson(),
      };
}

class IdProducts {
  List<Item>? data;

  IdProducts({
    this.data,
  });

  factory IdProducts.fromRawJson(String str) =>
      IdProducts.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IdProducts.fromJson(Map<String, dynamic> json) => IdProducts(
        data: json["data"] == null
            ? []
            : List<Item>.from(json["data"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Item {
  int? id;
  ItemAttributes? attributes;

  Item({
    this.id,
    this.attributes,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : ItemAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class ItemAttributes {
  String? productName;
  String? productDescription;
  bool? isSold;
  int? productPrice;
  DateTime? productRelease;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  int? productStock;
  int? productWeight;
  ProductCover? productCover;

  ItemAttributes({
    this.productName,
    this.productDescription,
    this.isSold,
    this.productPrice,
    this.productRelease,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.productStock,
    this.productWeight,
    this.productCover,
  });

  factory ItemAttributes.fromRawJson(String str) =>
      ItemAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemAttributes.fromJson(Map<String, dynamic> json) => ItemAttributes(
        productName: json["product_name"],
        productDescription: json["product_description"],
        isSold: json["is_sold"],
        productPrice: json["product_price"],
        productRelease: json["product_release"] == null
            ? null
            : DateTime.parse(json["product_release"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        productStock: json["product_stock"],
        productWeight: json["product_weight"],
        productCover: json["product_cover"] == null
            ? null
            : ProductCover.fromJson(json["product_cover"]),
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_description": productDescription,
        "is_sold": isSold,
        "product_price": productPrice,
        "product_release":
            "${productRelease!.year.toString().padLeft(4, '0')}-${productRelease!.month.toString().padLeft(2, '0')}-${productRelease!.day.toString().padLeft(2, '0')}",
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "publishedAt": publishedAt?.toIso8601String(),
        "product_stock": productStock,
        "product_weight": productWeight,
        "product_cover": productCover?.toJson(),
      };
}

class ProductCover {
  Data? data;

  ProductCover({
    this.data,
  });

  factory ProductCover.fromRawJson(String str) =>
      ProductCover.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductCover.fromJson(Map<String, dynamic> json) => ProductCover(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  DataAttributes? attributes;

  Data({
    this.id,
    this.attributes,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : DataAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class DataAttributes {
  String? name;
  dynamic alternativeText;
  dynamic caption;
  int? width;
  int? height;
  Formats? formats;
  String? hash;
  String? ext;
  String? mime;
  double? size;
  String? url;
  dynamic previewUrl;
  String? provider;
  dynamic providerMetadata;
  DateTime? createdAt;
  DateTime? updatedAt;

  DataAttributes({
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.previewUrl,
    this.provider,
    this.providerMetadata,
    this.createdAt,
    this.updatedAt,
  });

  factory DataAttributes.fromRawJson(String str) =>
      DataAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataAttributes.fromJson(Map<String, dynamic> json) => DataAttributes(
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats:
            json["formats"] == null ? null : Formats.fromJson(json["formats"]),
        hash: json["hash"],
        ext: json["ext"],
        mime: json["mime"],
        size: json["size"]?.toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        provider: json["provider"],
        providerMetadata: json["provider_metadata"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width,
        "height": height,
        "formats": formats?.toJson(),
        "hash": hash,
        "ext": ext,
        "mime": mime,
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": provider,
        "provider_metadata": providerMetadata,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Formats {
  Small? thumbnail;
  Small? small;

  Formats({
    this.thumbnail,
    this.small,
  });

  factory Formats.fromRawJson(String str) => Formats.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Formats.fromJson(Map<String, dynamic> json) => Formats(
        thumbnail: json["thumbnail"] == null
            ? null
            : Small.fromJson(json["thumbnail"]),
        small: json["small"] == null ? null : Small.fromJson(json["small"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail?.toJson(),
        "small": small?.toJson(),
      };
}

class Small {
  String? name;
  String? hash;
  String? ext;
  String? mime;
  dynamic path;
  int? width;
  int? height;
  double? size;
  String? url;

  Small({
    this.name,
    this.hash,
    this.ext,
    this.mime,
    this.path,
    this.width,
    this.height,
    this.size,
    this.url,
  });

  factory Small.fromRawJson(String str) => Small.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Small.fromJson(Map<String, dynamic> json) => Small(
        name: json["name"],
        hash: json["hash"],
        ext: json["ext"],
        mime: json["mime"],
        path: json["path"],
        width: json["width"],
        height: json["height"],
        size: json["size"]?.toDouble(),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "hash": hash,
        "ext": ext,
        "mime": mime,
        "path": path,
        "width": width,
        "height": height,
        "size": size,
        "url": url,
      };
}

class RajaOngkir {
  int? ongkir;
  Provinsi? provinsiAsal;
  Kota? kotaAsal;
  Provinsi? provinsiTujuan;
  Kota? kotaTujuan;
  CourirPilihan? courirPilihan;

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
  String? code;
  String? name;
  Costs? costs;

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
  String? service;
  String? description;
  Cost? cost;

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
  int? value;
  String? etd;
  String? note;

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
  int? cityId;
  int? provinceId;
  String? province;
  String? type;
  String? cityName;
  int? postalCode;

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
  int? provinceId;
  String? province;

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
  int? id;
  VoucherDataAttributes? attributes;

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
            : VoucherDataAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class VoucherDataAttributes {
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? publishedAt;
  String? codeVoucher;
  int? potonganPersen;

  VoucherDataAttributes({
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.codeVoucher,
    this.potonganPersen,
  });

  factory VoucherDataAttributes.fromRawJson(String str) =>
      VoucherDataAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory VoucherDataAttributes.fromJson(Map<String, dynamic> json) =>
      VoucherDataAttributes(
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

class Meta {
  Pagination? pagination;

  Meta({
    this.pagination,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
      };
}

class Pagination {
  int? page;
  int? pageSize;
  int? pageCount;
  int? total;

  Pagination({
    this.page,
    this.pageSize,
    this.pageCount,
    this.total,
  });

  factory Pagination.fromRawJson(String str) =>
      Pagination.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        page: json["page"],
        pageSize: json["pageSize"],
        pageCount: json["pageCount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "pageCount": pageCount,
        "total": total,
      };
}
