import 'dart:convert';

class ForgetPasswordOtpResponseModel {
    bool? status;
    String? message;
    int? code;
    String? token;

    ForgetPasswordOtpResponseModel({
        this.status,
        this.message,
        this.code,
        this.token,
    });

    ForgetPasswordOtpResponseModel copyWith({
        bool? status,
        String? message,
        int? code,
        String? token,
    }) => 
        ForgetPasswordOtpResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            token: token ?? this.token,
        );

    factory ForgetPasswordOtpResponseModel.fromRawJson(String str) => ForgetPasswordOtpResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ForgetPasswordOtpResponseModel.fromJson(Map<String, dynamic> json) => ForgetPasswordOtpResponseModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "token": token,
    };
}
