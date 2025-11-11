import 'dart:convert';

class LogoutResponseModel {
    bool? status;
    String? message;
    int? code;

    LogoutResponseModel({
        this.status,
        this.message,
        this.code,
    });

    LogoutResponseModel copyWith({
        bool? status,
        String? message,
        int? code,
    }) => 
        LogoutResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
        );

    factory LogoutResponseModel.fromRawJson(String str) => LogoutResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LogoutResponseModel.fromJson(Map<String, dynamic> json) => LogoutResponseModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
    };
}
