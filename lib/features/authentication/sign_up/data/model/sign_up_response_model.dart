import 'dart:convert';

class SignupResponseModel {
    bool? status;
    String? message;
    Data? data;

    SignupResponseModel({
        this.status,
        this.message,
        this.data,
    });

    SignupResponseModel copyWith({
        bool? status,
        String? message,
        Data? data,
    }) => 
        SignupResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory SignupResponseModel.fromRawJson(String str) => SignupResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SignupResponseModel.fromJson(Map<String, dynamic> json) => SignupResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? name;
    String? email;
    String? otp;

    Data({
        this.id,
        this.name,
        this.email,
        this.otp,
    });

    Data copyWith({
        int? id,
        String? name,
        String? email,
        String? otp,
    }) => 
        Data(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            otp: otp ?? this.otp,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        otp: json["otp"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "otp": otp,
    };
}
