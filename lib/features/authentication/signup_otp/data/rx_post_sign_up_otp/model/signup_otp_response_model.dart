import 'dart:convert';

class SignupResendOtpResponseModel {
  bool? status;
  String? message;
  int? code;
  String? token;
  Data? data;

  SignupResendOtpResponseModel({
    this.status,
    this.message,
    this.code,
    this.token,
    this.data,
  });

  SignupResendOtpResponseModel copyWith({
    bool? status,
    String? message,
    int? code,
    String? token,
    Data? data,
  }) => SignupResendOtpResponseModel(
    status: status ?? this.status,
    message: message ?? this.message,
    code: code ?? this.code,
    token: token ?? this.token,
    data: data ?? this.data,
  );

  factory SignupResendOtpResponseModel.fromRawJson(String str) =>
      SignupResendOtpResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignupResendOtpResponseModel.fromJson(Map<String, dynamic> json) =>
      SignupResendOtpResponseModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        token: json["token"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "token": token,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? name;
  String? email;

  Data({this.id, this.name, this.email});

  Data copyWith({int? id, String? name, String? email}) => Data(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(id: json["id"], name: json["name"], email: json["email"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email};
}
