import 'dart:convert';

class SignInResponseModel {
  bool? status;
  String? message;
  int? code;
  String? token;
  Data? data;

  SignInResponseModel({
    this.status,
    this.message,
    this.code,
    this.token,
    this.data,
  });

  SignInResponseModel copyWith({
    bool? status,
    String? message,
    int? code,
    String? token,
    Data? data,
  }) => SignInResponseModel(
    status: status ?? this.status,
    message: message ?? this.message,
    code: code ?? this.code,
    token: token ?? this.token,
    data: data ?? this.data,
  );

  factory SignInResponseModel.fromRawJson(String str) =>
      SignInResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) =>
      SignInResponseModel(
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
  dynamic avatar;
  String? name;
  String? email;
  int? userInfo;
  int? paymentMethod;
  int? isNutration;

  Data({
    this.id,
    this.avatar,
    this.name,
    this.email,
    this.userInfo,
    this.paymentMethod,
    this.isNutration,
  });

  Data copyWith({
    int? id,
    dynamic avatar,
    String? name,
    String? email,
    int? userInfo,
    int? paymentMethod,
    int? isNutration,
  }) => Data(
    id: id ?? this.id,
    avatar: avatar ?? this.avatar,
    name: name ?? this.name,
    email: email ?? this.email,
    userInfo: userInfo ?? this.userInfo,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    isNutration: isNutration ?? this.isNutration,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    avatar: json["avatar"],
    name: json["name"],
    email: json["email"],
    userInfo: json["user_info"],
    paymentMethod: json["Payment_method"],
    isNutration: json["is_nutration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "avatar": avatar,
    "name": name,
    "email": email,
    "user_info": userInfo,
    "Payment_method": paymentMethod,
    "is_nutration": isNutration,
  };
}
