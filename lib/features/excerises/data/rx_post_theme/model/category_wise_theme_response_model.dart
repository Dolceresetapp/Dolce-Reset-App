import 'dart:convert';

class CategoryWiseThemeResponseModel {
    bool? status;
    String? message;
    int? code;
    List<Datum>? data;

    CategoryWiseThemeResponseModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    CategoryWiseThemeResponseModel copyWith({
        bool? status,
        String? message,
        int? code,
        List<Datum>? data,
    }) => 
        CategoryWiseThemeResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory CategoryWiseThemeResponseModel.fromRawJson(String str) => CategoryWiseThemeResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory CategoryWiseThemeResponseModel.fromJson(Map<String, dynamic> json) => CategoryWiseThemeResponseModel(
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
    dynamic image;
    String? type;
    int? categoryId;

    Datum({
        this.id,
        this.name,
        this.image,
        this.type,
        this.categoryId,
    });

    Datum copyWith({
        int? id,
        String? name,
        dynamic image,
        String? type,
        int? categoryId,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            image: image ?? this.image,
            type: type ?? this.type,
            categoryId: categoryId ?? this.categoryId,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        categoryId: json["category_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "category_id": categoryId,
    };
}
