import 'dart:convert';

class DynamicWorkoutResponseModel {
  bool? success;
  String? message;
  String? categoryName;
  String? coverImage;
  int? totalWorkouts;
  List<Datum>? data;

  DynamicWorkoutResponseModel({
    this.success,
    this.message,
    this.categoryName,
    this.coverImage,
    this.totalWorkouts,
    this.data,
  });

  DynamicWorkoutResponseModel copyWith({
    bool? success,
    String? message,
    String? categoryName,
    String? coverImage,
    int? totalWorkouts,
    List<Datum>? data,
  }) => DynamicWorkoutResponseModel(
    success: success ?? this.success,
    message: message ?? this.message,
    categoryName: categoryName ?? this.categoryName,
    coverImage: coverImage ?? this.coverImage,
    totalWorkouts: totalWorkouts ?? this.totalWorkouts,
    data: data ?? this.data,
  );

  factory DynamicWorkoutResponseModel.fromRawJson(String str) =>
      DynamicWorkoutResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DynamicWorkoutResponseModel.fromJson(Map<String, dynamic> json) =>
      DynamicWorkoutResponseModel(
        success: json["success"],
        message: json["message"],
        categoryName: json["category_name"],
        coverImage: json["cover_image"],
        totalWorkouts: json["total_workouts"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "category_name": categoryName,
    "cover_image": coverImage,
    "total_workouts": totalWorkouts,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? title;
  String? image;
  int? calories;
  int? minutes;

  Datum({this.id, this.title, this.image, this.calories, this.minutes});

  Datum copyWith({
    int? id,
    String? title,
    String? image,
    int? calories,
    int? minutes,
  }) => Datum(
    id: id ?? this.id,
    title: title ?? this.title,
    image: image ?? this.image,
    calories: calories ?? this.calories,
    minutes: minutes ?? this.minutes,
  );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    calories: json["calories"],
    minutes: json["minutes"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "calories": calories,
    "minutes": minutes,
  };
}
