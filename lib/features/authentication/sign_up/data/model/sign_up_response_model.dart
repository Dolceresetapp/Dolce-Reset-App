import 'dart:convert';

class SignupResponseModel {
    bool? success;
    String? message;
    Data? data;
    int? code;

    SignupResponseModel({
        this.success,
        this.message,
        this.data,
        this.code,
    });

    SignupResponseModel copyWith({
        bool? success,
        String? message,
        Data? data,
        int? code,
    }) => 
        SignupResponseModel(
            success: success ?? this.success,
            message: message ?? this.message,
            data: data ?? this.data,
            code: code ?? this.code,
        );

    factory SignupResponseModel.fromRawJson(String str) => SignupResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SignupResponseModel.fromJson(Map<String, dynamic> json) => SignupResponseModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "code": code,
    };
}

class Data {
    String? message;
    String? name;
    String? email;
    int? otp;

    Data({
        this.message,
        this.name,
        this.email,
        this.otp,
    });

    Data copyWith({
        String? message,
        String? name,
        String? email,
        int? otp,
    }) => 
        Data(
            message: message ?? this.message,
            name: name ?? this.name,
            email: email ?? this.email,
            otp: otp ?? this.otp,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        message: json["message"],
        name: json["name"],
        email: json["email"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "name": name,
        "email": email,
        "otp": otp,
    };
}
