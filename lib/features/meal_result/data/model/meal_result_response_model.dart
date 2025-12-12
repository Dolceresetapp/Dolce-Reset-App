import 'dart:convert';

class MealResponseModel {
  bool? success;
  String? message;
  Data? data;

  MealResponseModel({this.success, this.message, this.data});

  MealResponseModel copyWith({bool? success, String? message, Data? data}) =>
      MealResponseModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MealResponseModel.fromRawJson(String str) =>
      MealResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealResponseModel.fromJson(Map<String, dynamic> json) =>
      MealResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? productName;
  String? image;
  String? brand;
  int? score;
  bool? isHealthy;
  String? verdict;
  String? reason;
  String? details;
  List<Alternative>? alternatives;

  Data({
    this.productName,
    this.image,
    this.brand,
    this.score,
    this.isHealthy,
    this.verdict,
    this.reason,
    this.details,
    this.alternatives,
  });

  Data copyWith({
    String? productName,
    String? image,
    String? brand,
    int? score,
    bool? isHealthy,
    String? verdict,
    String? reason,
    String? details,
    List<Alternative>? alternatives,
  }) => Data(
    productName: productName ?? this.productName,
    image: image ?? this.image,
    brand: brand ?? this.brand,
    score: score ?? this.score,
    isHealthy: isHealthy ?? this.isHealthy,
    verdict: verdict ?? this.verdict,
    reason: reason ?? this.reason,
    details: details ?? this.details,
    alternatives: alternatives ?? this.alternatives,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    productName: json["product_name"],
    image: json["image"],
    brand: json["brand"],
    score: json["score"],
    isHealthy: json["is_healthy"],
    verdict: json["verdict"],
    reason: json["reason"],
    details: json["details"],
    alternatives:
        json["alternatives"] == null
            ? []
            : List<Alternative>.from(
              json["alternatives"]!.map((x) => Alternative.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "image": image,
    "brand": brand,
    "score": score,
    "is_healthy": isHealthy,
    "verdict": verdict,
    "reason": reason,
    "details": details,
    "alternatives":
        alternatives == null
            ? []
            : List<dynamic>.from(alternatives!.map((x) => x.toJson())),
  };
}

class Alternative {
  String? name;
  String? category;
  String? imageUrl;
  String? whyBetter;

  Alternative({this.name, this.category, this.imageUrl, this.whyBetter});

  Alternative copyWith({
    String? name,
    String? category,
    String? imageUrl,
    String? whyBetter,
  }) => Alternative(
    name: name ?? this.name,
    category: category ?? this.category,
    imageUrl: imageUrl ?? this.imageUrl,
    whyBetter: whyBetter ?? this.whyBetter,
  );

  factory Alternative.fromRawJson(String str) =>
      Alternative.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Alternative.fromJson(Map<String, dynamic> json) => Alternative(
    name: json["name"],
    category: json["category"],
    imageUrl: json["image_url"],
    whyBetter: json["why_better"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "category": category,
    "image_url": imageUrl,
    "why_better": whyBetter,
  };
}
