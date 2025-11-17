import 'dart:convert';

class CategoryResponseModel {
    bool? status;
    String? message;
    int? code;
    List<Datum>? data;

    CategoryResponseModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    CategoryResponseModel copyWith({
        bool? status,
        String? message,
        int? code,
        List<Datum>? data,
    }) => 
        CategoryResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory CategoryResponseModel.fromRawJson(String str) => CategoryResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoryResponseModel.fromJson(Map<String, dynamic> json) => CategoryResponseModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    String? slug;
    String? image;
    String? status;

    Datum({
        this.id,
        this.name,
        this.slug,
        this.image,
        this.status,
    });

    Datum copyWith({
        int? id,
        String? name,
        String? slug,
        String? image,
        String? status,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            slug: slug ?? this.slug,
            image: image ?? this.image,
            status: status ?? this.status,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        image: json["image"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "image": image,
        "status": status,
    };
}
