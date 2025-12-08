import 'dart:convert';

class ChefResponseModel {
  bool? success;
  String? message;
  Data? data;

  ChefResponseModel({this.success, this.message, this.data});

  ChefResponseModel copyWith({bool? success, String? message, Data? data}) =>
      ChefResponseModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ChefResponseModel.fromRawJson(String str) =>
      ChefResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChefResponseModel.fromJson(Map<String, dynamic> json) =>
      ChefResponseModel(
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
  int? id;
  int? userId;
  String? goalsFor;
  String? dietaryPreferences;
  String? intolerances;
  String? activityLevel;
  String? dontLike;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.userId,
    this.goalsFor,
    this.dietaryPreferences,
    this.intolerances,
    this.activityLevel,
    this.dontLike,
    this.createdAt,
    this.updatedAt,
  });

  Data copyWith({
    int? id,
    int? userId,
    String? goalsFor,
    String? dietaryPreferences,
    String? intolerances,
    String? activityLevel,
    String? dontLike,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Data(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    goalsFor: goalsFor ?? this.goalsFor,
    dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
    intolerances: intolerances ?? this.intolerances,
    activityLevel: activityLevel ?? this.activityLevel,
    dontLike: dontLike ?? this.dontLike,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    goalsFor: json["goals_for"],
    dietaryPreferences: json["dietary_preferences"],
    intolerances: json["intolerances"],
    activityLevel: json["activity_level"],
    dontLike: json["dont_like"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "goals_for": goalsFor,
    "dietary_preferences": dietaryPreferences,
    "intolerances": intolerances,
    "activity_level": activityLevel,
    "dont_like": dontLike,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
