import 'dart:convert';

class CourirModalResponse {
  final String code;
  final String name;
  final List<CourirModalResponseCost> costs;

  CourirModalResponse({
    required this.code,
    required this.name,
    required this.costs,
  });

  factory CourirModalResponse.fromRawJson(String str) =>
      CourirModalResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourirModalResponse.fromJson(Map<String, dynamic> json) =>
      CourirModalResponse(
        code: json["code"],
        name: json["name"],
        costs: List<CourirModalResponseCost>.from(
            json["costs"].map((x) => CourirModalResponseCost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "costs": List<dynamic>.from(costs.map((x) => x.toJson())),
      };

  static List<CourirModalResponse> fromJsonList(List list) {
    if (list.isEmpty) return List<CourirModalResponse>.empty();
    return list.map((e) => CourirModalResponse.fromJson(e)).toList();
  }
}

class CourirModalResponseCost {
  final String service;
  final String description;
  final List<CostCost> cost;

  CourirModalResponseCost({
    required this.service,
    required this.description,
    required this.cost,
  });

  factory CourirModalResponseCost.fromRawJson(String str) =>
      CourirModalResponseCost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CourirModalResponseCost.fromJson(Map<String, dynamic> json) =>
      CourirModalResponseCost(
        service: json["service"],
        description: json["description"],
        cost:
            List<CostCost>.from(json["cost"].map((x) => CostCost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service": service,
        "description": description,
        "cost": List<dynamic>.from(cost.map((x) => x.toJson())),
      };
}

class CostCost {
  final int value;
  final String etd;
  final String note;

  CostCost({
    required this.value,
    required this.etd,
    required this.note,
  });

  factory CostCost.fromRawJson(String str) =>
      CostCost.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CostCost.fromJson(Map<String, dynamic> json) => CostCost(
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
