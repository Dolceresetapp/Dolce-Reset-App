import 'dart:convert';

class RatingResponseModel {
  bool? status;
  String? message;
  int? code;
  List<Datum>? data;

  RatingResponseModel({this.status, this.message, this.code, this.data});

  RatingResponseModel copyWith({
    bool? status,
    String? message,
    int? code,
    List<Datum>? data,
  }) => RatingResponseModel(
    status: status ?? this.status,
    message: message ?? this.message,
    code: code ?? this.code,
    data: data ?? this.data,
  );

  factory RatingResponseModel.fromRawJson(String str) =>
      RatingResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RatingResponseModel.fromJson(Map<String, dynamic> json) =>
      RatingResponseModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "code": code,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? title;
  String? description;
  String? image;
  int? rating;

  Datum({this.id, this.title, this.description, this.image, this.rating});

  Datum copyWith({
    int? id,
    String? title,
    String? description,
    String? image,
    int? rating,
  }) => Datum(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    image: image ?? this.image,
    rating: rating ?? this.rating,
  );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "image": image,
    "rating": rating,
  };
}
