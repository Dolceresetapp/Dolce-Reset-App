import 'dart:convert';

class PlanResponseModel {
    bool? status;
    String? message;
    int? code;
    List<Datum>? data;

    PlanResponseModel({
        this.status,
        this.message,
        this.code,
        this.data,
    });

    PlanResponseModel copyWith({
        bool? status,
        String? message,
        int? code,
        List<Datum>? data,
    }) => 
        PlanResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            code: code ?? this.code,
            data: data ?? this.data,
        );

    factory PlanResponseModel.fromRawJson(String str) => PlanResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PlanResponseModel.fromJson(Map<String, dynamic> json) => PlanResponseModel(
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
    String? stripeProductId;
    String? stripePriceId;
    int? price;
    String? interval;

    Datum({
        this.id,
        this.name,
        this.stripeProductId,
        this.stripePriceId,
        this.price,
        this.interval,
    });

    Datum copyWith({
        int? id,
        String? name,
        String? stripeProductId,
        String? stripePriceId,
        int? price,
        String? interval,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            stripeProductId: stripeProductId ?? this.stripeProductId,
            stripePriceId: stripePriceId ?? this.stripePriceId,
            price: price ?? this.price,
            interval: interval ?? this.interval,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        stripeProductId: json["stripe_product_id"],
        stripePriceId: json["stripe_price_id"],
        price: json["price"],
        interval: json["interval"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "stripe_product_id": stripeProductId,
        "stripe_price_id": stripePriceId,
        "price": price,
        "interval": interval,
    };
}
