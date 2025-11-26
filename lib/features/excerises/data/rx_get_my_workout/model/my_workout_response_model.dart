import 'dart:convert';

class MyWorkoutResponseModel {
  bool? success;
  String? message;
  List<ActiveWorkout>? activeWorkouts;

  MyWorkoutResponseModel({this.success, this.message, this.activeWorkouts});

  MyWorkoutResponseModel copyWith({
    bool? success,
    String? message,
    List<ActiveWorkout>? activeWorkouts,
  }) => MyWorkoutResponseModel(
    success: success ?? this.success,
    message: message ?? this.message,
    activeWorkouts: activeWorkouts ?? this.activeWorkouts,
  );

  factory MyWorkoutResponseModel.fromRawJson(String str) =>
      MyWorkoutResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyWorkoutResponseModel.fromJson(Map<String, dynamic> json) =>
      MyWorkoutResponseModel(
        success: json["success"],
        message: json["message"],
        activeWorkouts:
            json["active_workouts"] == null
                ? []
                : List<ActiveWorkout>.from(
                  json["active_workouts"]!.map(
                    (x) => ActiveWorkout.fromJson(x),
                  ),
                ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "active_workouts":
        activeWorkouts == null
            ? []
            : List<dynamic>.from(activeWorkouts!.map((x) => x.toJson())),
  };
}

class ActiveWorkout {
  int? id;
  String? title;
  String? image;
  int? calories;
  int? minutes;

  ActiveWorkout({this.id, this.title, this.image, this.calories, this.minutes});

  ActiveWorkout copyWith({
    int? id,
    String? title,
    String? image,
    int? calories,
    int? minutes,
  }) => ActiveWorkout(
    id: id ?? this.id,
    title: title ?? this.title,
    image: image ?? this.image,
    calories: calories ?? this.calories,
    minutes: minutes ?? this.minutes,
  );

  factory ActiveWorkout.fromRawJson(String str) =>
      ActiveWorkout.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ActiveWorkout.fromJson(Map<String, dynamic> json) => ActiveWorkout(
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
