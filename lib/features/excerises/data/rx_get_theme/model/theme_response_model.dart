import 'dart:convert';

class ThemeResponseModel {
  bool? success;
  String? message;
  List<Datum>? data;

  ThemeResponseModel({this.success, this.message, this.data});

  ThemeResponseModel copyWith({
    bool? success,
    String? message,
    List<Datum>? data,
  }) => ThemeResponseModel(
    success: success ?? this.success,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory ThemeResponseModel.fromRawJson(String str) =>
      ThemeResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ThemeResponseModel.fromJson(Map<String, dynamic> json) =>
      ThemeResponseModel(
        success: json["success"],
        message: json["message"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? name;
  String? image;
  int? workOut;

  Datum({this.id, this.name, this.image, this.workOut});

  Datum copyWith({int? id, String? name, String? image, int? workOut}) => Datum(
    id: id ?? this.id,
    name: name ?? this.name,
    image: image ?? this.image,
    workOut: workOut ?? this.workOut,
  );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    workOut: json["work_out"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "work_out": workOut,
  };
}
