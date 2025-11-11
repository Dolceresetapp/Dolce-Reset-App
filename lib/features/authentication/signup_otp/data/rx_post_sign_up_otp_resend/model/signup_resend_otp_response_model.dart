import 'dart:convert';

class SignupResendOtpResponseModel {
    bool? success;
    String? message;
    int? otp;
    int? code;

    SignupResendOtpResponseModel({
        this.success,
        this.message,
        this.otp,
        this.code,
    });

    SignupResendOtpResponseModel copyWith({
        bool? success,
        String? message,
        int? otp,
        int? code,
    }) => 
        SignupResendOtpResponseModel(
            success: success ?? this.success,
            message: message ?? this.message,
            otp: otp ?? this.otp,
            code: code ?? this.code,
        );

    factory SignupResendOtpResponseModel.fromRawJson(String str) => SignupResendOtpResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SignupResendOtpResponseModel.fromJson(Map<String, dynamic> json) => SignupResendOtpResponseModel(
        success: json["success"],
        message: json["message"],
        otp: json["otp"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "otp": otp,
        "code": code,
    };
}
