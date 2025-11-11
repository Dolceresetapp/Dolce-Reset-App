import 'dart:convert';

class SignInResponseModel {
    bool? status;
    String? message;
    int? code;
    String? tokenType;
    String? token;
    int? expiresIn;
    Data? data;

    SignInResponseModel({
        this.status,
        this.message,
        this.code,
        this.tokenType,
        this.token,
        this.expiresIn,
        this.data,
    });

    SignInResponseModel copyWith({
        bool? status,
        String? message,
        int? code,
        String? tokenType,
        String? token,
        int? expiresIn,
        Data? data,
    }) => 
        SignInResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            tokenType: tokenType ?? this.tokenType,
            token: token ?? this.token,
            expiresIn: expiresIn ?? this.expiresIn,
            data: data ?? this.data,
        );

    factory SignInResponseModel.fromRawJson(String str) => SignInResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SignInResponseModel.fromJson(Map<String, dynamic> json) => SignInResponseModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        tokenType: json["token_type"],
        token: json["token"],
        expiresIn: json["expires_in"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "token_type": tokenType,
        "token": token,
        "expires_in": expiresIn,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? name;
    String? email;
    dynamic avatar;
    DateTime? otpVerifiedAt;
    DateTime? lastActivityAt;

    Data({
        this.id,
        this.name,
        this.email,
        this.avatar,
        this.otpVerifiedAt,
        this.lastActivityAt,
    });

    Data copyWith({
        int? id,
        String? name,
        String? email,
        dynamic avatar,
        DateTime? otpVerifiedAt,
        DateTime? lastActivityAt,
    }) => 
        Data(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            avatar: avatar ?? this.avatar,
            otpVerifiedAt: otpVerifiedAt ?? this.otpVerifiedAt,
            lastActivityAt: lastActivityAt ?? this.lastActivityAt,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        avatar: json["avatar"],
        otpVerifiedAt: json["otp_verified_at"] == null ? null : DateTime.parse(json["otp_verified_at"]),
        lastActivityAt: json["last_activity_at"] == null ? null : DateTime.parse(json["last_activity_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "avatar": avatar,
        "otp_verified_at": otpVerifiedAt?.toIso8601String(),
        "last_activity_at": lastActivityAt?.toIso8601String(),
    };
}
