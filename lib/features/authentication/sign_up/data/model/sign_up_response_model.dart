import 'dart:convert';

class SignupResponseModel {
  bool? status;
  String? message;
  String? token;
  Data? data;

  SignupResponseModel({this.status, this.message, this.token, this.data});

  SignupResponseModel copyWith({
    bool? status,
    String? message,
    String? token,
    Data? data,
  }) =>
      SignupResponseModel(
        status: status ?? this.status,
        message: message ?? this.message,
        token: token ?? this.token,
        data: data ?? this.data,
      );

  factory SignupResponseModel.fromRawJson(String str) =>
      SignupResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) =>
      SignupResponseModel(
        status: json["status"],
        message: json["message"],
        token: json["token"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "token": token,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? name;
  String? email;
  String? avatar;
  int? userInfo;
  int? paymentMethod;
  int? isNutration;

  Data({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.userInfo,
    this.paymentMethod,
    this.isNutration,
  });

  Data copyWith({
    int? id,
    String? name,
    String? email,
    String? avatar,
    int? userInfo,
    int? paymentMethod,
    int? isNutration,
  }) => Data(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    avatar: avatar ?? this.avatar,
    userInfo: userInfo ?? this.userInfo,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    isNutration: isNutration ?? this.isNutration,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    avatar: json["avatar"],
    userInfo: json["user_info"],
    paymentMethod: json["payment_method"],
    isNutration: json["is_nutration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "avatar": avatar,
    "user_info": userInfo,
    "payment_method": paymentMethod,
    "is_nutration": isNutration,
  };
}
