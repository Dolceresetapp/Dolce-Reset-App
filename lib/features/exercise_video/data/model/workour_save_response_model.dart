import 'dart:convert';

class ActiveWorkoutResponseModel {
    bool? success;
    String? message;

    ActiveWorkoutResponseModel({
        this.success,
        this.message,
    });

    ActiveWorkoutResponseModel copyWith({
        bool? success,
        String? message,
    }) => 
        ActiveWorkoutResponseModel(
            success: success ?? this.success,
            message: message ?? this.message,
        );

    factory ActiveWorkoutResponseModel.fromRawJson(String str) => ActiveWorkoutResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ActiveWorkoutResponseModel.fromJson(Map<String, dynamic> json) => ActiveWorkoutResponseModel(
        success: json["success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
    };
}
