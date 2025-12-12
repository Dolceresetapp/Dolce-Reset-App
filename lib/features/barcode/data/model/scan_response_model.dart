import 'dart:convert';

class ScanResonseModel {
  bool? status;
  Data? data;

  ScanResonseModel({this.status, this.data});

  ScanResonseModel copyWith({bool? status, Data? data}) =>
      ScanResonseModel(status: status ?? this.status, data: data ?? this.data);

  factory ScanResonseModel.fromRawJson(String str) =>
      ScanResonseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ScanResonseModel.fromJson(Map<String, dynamic> json) =>
      ScanResonseModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  String? name;
  String? brands;
  String? image;
  Nutriments? nutriments;

  Data({this.name, this.brands, this.image, this.nutriments});

  Data copyWith({
    String? name,
    String? brands,
    String? image,
    Nutriments? nutriments,
  }) => Data(
    name: name ?? this.name,
    brands: brands ?? this.brands,
    image: image ?? this.image,
    nutriments: nutriments ?? this.nutriments,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    name: json["name"],
    brands: json["brands"],
    image: json["image"],
    nutriments:
        json["nutriments"] == null
            ? null
            : Nutriments.fromJson(json["nutriments"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "brands": brands,
    "image": image,
    "nutriments": nutriments?.toJson(),
  };
}

class Nutriments {
  dynamic energyKcal;
  dynamic fat;
  dynamic saturatedFat;
  int? carbohydrates;
  dynamic sugars;
  dynamic fiber;
  dynamic proteins;
  double? salt;

  Nutriments({
    this.energyKcal,
    this.fat,
    this.saturatedFat,
    this.carbohydrates,
    this.sugars,
    this.fiber,
    this.proteins,
    this.salt,
  });

  Nutriments copyWith({
    dynamic energyKcal,
    dynamic fat,
    dynamic saturatedFat,
    int? carbohydrates,
    dynamic sugars,
    dynamic fiber,
    dynamic proteins,
    double? salt,
  }) => Nutriments(
    energyKcal: energyKcal ?? this.energyKcal,
    fat: fat ?? this.fat,
    saturatedFat: saturatedFat ?? this.saturatedFat,
    carbohydrates: carbohydrates ?? this.carbohydrates,
    sugars: sugars ?? this.sugars,
    fiber: fiber ?? this.fiber,
    proteins: proteins ?? this.proteins,
    salt: salt ?? this.salt,
  );

  factory Nutriments.fromRawJson(String str) =>
      Nutriments.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Nutriments.fromJson(Map<String, dynamic> json) => Nutriments(
    energyKcal: json["energy_kcal"],
    fat: json["fat"],
    saturatedFat: json["saturated_fat"],
    carbohydrates: json["carbohydrates"],
    sugars: json["sugars"],
    fiber: json["fiber"],
    proteins: json["proteins"],
    salt: json["salt"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "energy_kcal": energyKcal,
    "fat": fat,
    "saturated_fat": saturatedFat,
    "carbohydrates": carbohydrates,
    "sugars": sugars,
    "fiber": fiber,
    "proteins": proteins,
    "salt": salt,
  };
}
