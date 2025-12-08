import 'dart:convert';

class AiReceipeResponseModel {
  bool? success;
  String? message;
  List<AiReceipeResponseData>? data;

  AiReceipeResponseModel({this.success, this.message, this.data});

  AiReceipeResponseModel copyWith({
    bool? success,
    String? message,
    List<AiReceipeResponseData>? data,
  }) => AiReceipeResponseModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory AiReceipeResponseModel.fromRawJson(String str) =>
      AiReceipeResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AiReceipeResponseModel.fromJson(Map<String, dynamic> json) =>
      AiReceipeResponseModel(
        success: json["success"],
        message: json["message"],
        data:
            json["data"] == null
                ? []
                : List<AiReceipeResponseData>.from(
                  json["data"]!.map((x) => AiReceipeResponseData.fromJson(x)),
                ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AiReceipeResponseData {
  String? meal;
  String? description;
  int? proteinG;
  int? timeMin;
  int? calories;
  String? imageUrl;

  AiReceipeResponseData({
    this.meal,
    this.description,
    this.proteinG,
    this.timeMin,
    this.calories,
    this.imageUrl,
  });

  AiReceipeResponseData copyWith({
    String? meal,
    String? description,
    int? proteinG,
    int? timeMin,
    int? calories,
    String? imageUrl,
  }) => AiReceipeResponseData(
    meal: meal ?? this.meal,
    description: description ?? this.description,
    proteinG: proteinG ?? this.proteinG,
    timeMin: timeMin ?? this.timeMin,
    calories: calories ?? this.calories,
    imageUrl: imageUrl ?? this.imageUrl,
  );

  factory AiReceipeResponseData.fromRawJson(String str) =>
      AiReceipeResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AiReceipeResponseData.fromJson(Map<String, dynamic> json) =>
      AiReceipeResponseData(
        meal: json["meal"],
        description: json["description"],
        proteinG: json["protein_g"],
        timeMin: json["time_min"],
        calories: json["calories"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
    "meal": meal,
    "description": description,
    "protein_g": proteinG,
    "time_min": timeMin,
    "calories": calories,
    "image_url": imageUrl,
  };
}
