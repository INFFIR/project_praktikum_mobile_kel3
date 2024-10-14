// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ListProductResponseModel {
  final List<Product>? data;
  final Meta? meta;

  ListProductResponseModel({
    this.data,
    this.meta,
  });

  factory ListProductResponseModel.fromRawJson(String str) =>
      ListProductResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListProductResponseModel.fromJson(Map<String, dynamic> json) =>
      ListProductResponseModel(
        data: json["data"] == null
            ? []
            : List<Product>.from(json["data"]!.map((x) => Product.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "meta": meta?.toJson(),
      };

  @override
  bool operator ==(covariant ListProductResponseModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.data, data) && other.meta == meta;
  }

  @override
  int get hashCode => data.hashCode ^ meta.hashCode;
}

class Product {
  final int? id;
  final DatumAttributes? attributes;

  Product({
    this.id,
    this.attributes,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        attributes: json["attributes"] == null
            ? null
            : DatumAttributes.fromJson(json["attributes"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id && other.attributes == attributes;
  }

  @override
  int get hashCode => id.hashCode ^ attributes.hashCode;
}

class DatumAttributes {
  final String? productName;
  final String? productDescription;
  final bool? isSold;
  final int? productPrice;
  final DateTime? productRelease;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final int? productStock;
  final int? productWeight;
  final ProductCover? productCover;

  DatumAttributes({
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

  factory DatumAttributes.fromRawJson(String str) =>
      DatumAttributes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DatumAttributes.fromJson(Map<String, dynamic> json) =>
      DatumAttributes(
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

  @override
  bool operator ==(covariant DatumAttributes other) {
    if (identical(this, other)) return true;

    return other.productName == productName &&
        other.productDescription == productDescription &&
        other.isSold == isSold &&
        other.productPrice == productPrice &&
        other.productRelease == productRelease &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.publishedAt == publishedAt &&
        other.productStock == productStock &&
        other.productWeight == productWeight &&
        other.productCover == productCover;
  }

  @override
  int get hashCode {
    return productName.hashCode ^
        productDescription.hashCode ^
        isSold.hashCode ^
        productPrice.hashCode ^
        productRelease.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        publishedAt.hashCode ^
        productStock.hashCode ^
        productWeight.hashCode ^
        productCover.hashCode;
  }
}

class ProductCover {
  final Data? data;

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

  @override
  bool operator ==(covariant ProductCover other) {
    if (identical(this, other)) return true;

    return other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

class Data {
  final int? id;
  final DataAttributes? attributes;

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

  @override
  bool operator ==(covariant Data other) {
    if (identical(this, other)) return true;

    return other.id == id && other.attributes == attributes;
  }

  @override
  int get hashCode => id.hashCode ^ attributes.hashCode;
}

class DataAttributes {
  final String? name;
  final dynamic alternativeText;
  final dynamic caption;
  final int? width;
  final int? height;
  final Formats? formats;
  final String? hash;
  final String? ext;
  final String? mime;
  final double? size;
  final String? url;
  final dynamic previewUrl;
  final String? provider;
  final dynamic providerMetadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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

  @override
  bool operator ==(covariant DataAttributes other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.alternativeText == alternativeText &&
        other.caption == caption &&
        other.width == width &&
        other.height == height &&
        other.formats == formats &&
        other.hash == hash &&
        other.ext == ext &&
        other.mime == mime &&
        other.size == size &&
        other.url == url &&
        other.previewUrl == previewUrl &&
        other.provider == provider &&
        other.providerMetadata == providerMetadata &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        alternativeText.hashCode ^
        caption.hashCode ^
        width.hashCode ^
        height.hashCode ^
        formats.hashCode ^
        hash.hashCode ^
        ext.hashCode ^
        mime.hashCode ^
        size.hashCode ^
        url.hashCode ^
        previewUrl.hashCode ^
        provider.hashCode ^
        providerMetadata.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}

class Formats {
  final Small? thumbnail;
  final Small? small;

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
  final String? name;
  final String? hash;
  final String? ext;
  final String? mime;
  final dynamic path;
  final int? width;
  final int? height;
  final double? size;
  final String? url;

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

class Meta {
  final Pagination? pagination;

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
  final int? page;
  final int? pageSize;
  final int? pageCount;
  final int? total;

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
