import 'dart:convert';

class CoachResponseModel {
  bool? success;
  String? prompt;
  String? message;
  String? responseType;

  CoachResponseModel({
    this.success,
    this.prompt,
    this.message,
    this.responseType,
  });

  CoachResponseModel copyWith({
    bool? success,
    String? prompt,
    String? message,
    String? responseType,
  }) => CoachResponseModel(
    success: success ?? this.success,
    prompt: prompt ?? this.prompt,
    message: message ?? this.message,
    responseType: responseType ?? this.responseType,
  );

  factory CoachResponseModel.fromRawJson(String str) =>
      CoachResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CoachResponseModel.fromJson(Map<String, dynamic> json) =>
      CoachResponseModel(
        success: json["success"],
        prompt: json["prompt"],
        message: json["message"],
        responseType: json["response_type"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "prompt": prompt,
    "message": message,
    "response_type": responseType,
  };
}
