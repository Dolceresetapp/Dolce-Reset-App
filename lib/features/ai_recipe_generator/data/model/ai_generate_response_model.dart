import 'dart:convert';

class AiGenerateResponseModel {
  bool? success;
  String? prompt;
  String? message;
  List<Datum>? data;
  String? responseType;

  AiGenerateResponseModel({
    this.success,
    this.prompt,
    this.message,
    this.data,
    this.responseType,
  });

  AiGenerateResponseModel copyWith({
    bool? success,
    String? prompt,
    String? message,
    List<Datum>? data,
    String? responseType,
  }) => AiGenerateResponseModel(
    success: success ?? this.success,
    prompt: prompt ?? this.prompt,
    message: message ?? this.message,
    data: data ?? this.data,
    responseType: responseType ?? this.responseType,
  );

  factory AiGenerateResponseModel.fromRawJson(String str) =>
      AiGenerateResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AiGenerateResponseModel.fromJson(Map<String, dynamic> json) =>
      AiGenerateResponseModel(
        success: json["success"],
        prompt: json["prompt"],
        message: json["message"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        responseType: json["response_type"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "prompt": prompt,
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "response_type": responseType,
  };
}

class Datum {
  String? meal;
  String? description;
  List<String>? ingredients;
  List<String>? steps;
  int? timeMin;
  int? calories;
  int? proteinG;
  String? imageUrl;

  Datum({
    this.meal,
    this.description,
    this.ingredients,
    this.steps,
    this.timeMin,
    this.calories,
    this.proteinG,
    this.imageUrl,
  });

  Datum copyWith({
    String? meal,
    String? description,
    List<String>? ingredients,
    List<String>? steps,
    int? timeMin,
    int? calories,
    int? proteinG,
    String? imageUrl,
  }) => Datum(
    meal: meal ?? this.meal,
    description: description ?? this.description,
    ingredients: ingredients ?? this.ingredients,
    steps: steps ?? this.steps,
    timeMin: timeMin ?? this.timeMin,
    calories: calories ?? this.calories,
    proteinG: proteinG ?? this.proteinG,
    imageUrl: imageUrl ?? this.imageUrl,
  );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    meal: json["meal"],
    description: json["description"],
    ingredients:
        json["ingredients"] == null
            ? []
            : List<String>.from(json["ingredients"]!.map((x) => x)),
    steps:
        json["steps"] == null
            ? []
            : List<String>.from(json["steps"]!.map((x) => x)),
    timeMin: json["time_min"],
    calories: json["calories"],
    proteinG: json["protein_g"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "meal": meal,
    "description": description,
    "ingredients":
        ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x)),
    "steps": steps == null ? [] : List<dynamic>.from(steps!.map((x) => x)),
    "time_min": timeMin,
    "calories": calories,
    "protein_g": proteinG,
    "image_url": imageUrl,
  };
}
