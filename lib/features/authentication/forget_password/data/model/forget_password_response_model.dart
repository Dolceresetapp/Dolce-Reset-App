import 'dart:convert';

class ForgetPasswordResponseModel {
    bool? status;
    String? message;
    int? code;
    int? data;

    ForgetPasswordResponseModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    ForgetPasswordResponseModel copyWith({
        bool? status,
        String? message,
        int? code,
        int? data,
    }) => 
        ForgetPasswordResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory ForgetPasswordResponseModel.fromRawJson(String str) => ForgetPasswordResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) => ForgetPasswordResponseModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "data": data,
    };
}
