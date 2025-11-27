import 'dart:convert';

class SubscriptionResponseModel {
    bool? success;
    String? message;
    Subscription? subscription;

    SubscriptionResponseModel({
        this.success,
        this.message,
        this.subscription,
    });

    SubscriptionResponseModel copyWith({
        bool? success,
        String? message,
        Subscription? subscription,
    }) => 
        SubscriptionResponseModel(
            success: success ?? this.success,
            message: message ?? this.message,
            subscription: subscription ?? this.subscription,
        );

    factory SubscriptionResponseModel.fromRawJson(String str) => SubscriptionResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory SubscriptionResponseModel.fromJson(Map<String, dynamic> json) => SubscriptionResponseModel(
        success: json["success"],
        message: json["message"],
        subscription: json["subscription"] == null ? null : Subscription.fromJson(json["subscription"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "subscription": subscription?.toJson(),
    };
}

class Subscription {
    String? type;
    String? stripeId;
    String? stripeStatus;
    String? stripePrice;
    int? quantity;
    DateTime? trialEndsAt;
    dynamic endsAt;
    int? userId;
    DateTime? updatedAt;
    DateTime? createdAt;
    int? id;

    Subscription({
        this.type,
        this.stripeId,
        this.stripeStatus,
        this.stripePrice,
        this.quantity,
        this.trialEndsAt,
        this.endsAt,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.id,
    });

    Subscription copyWith({
        String? type,
        String? stripeId,
        String? stripeStatus,
        String? stripePrice,
        int? quantity,
        DateTime? trialEndsAt,
        dynamic endsAt,
        int? userId,
        DateTime? updatedAt,
        DateTime? createdAt,
        int? id,
    }) => 
        Subscription(
            type: type ?? this.type,
            stripeId: stripeId ?? this.stripeId,
            stripeStatus: stripeStatus ?? this.stripeStatus,
            stripePrice: stripePrice ?? this.stripePrice,
            quantity: quantity ?? this.quantity,
            trialEndsAt: trialEndsAt ?? this.trialEndsAt,
            endsAt: endsAt ?? this.endsAt,
            userId: userId ?? this.userId,
            updatedAt: updatedAt ?? this.updatedAt,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
        );

    factory Subscription.fromRawJson(String str) => Subscription.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        type: json["type"],
        stripeId: json["stripe_id"],
        stripeStatus: json["stripe_status"],
        stripePrice: json["stripe_price"],
        quantity: json["quantity"],
        trialEndsAt: json["trial_ends_at"] == null ? null : DateTime.parse(json["trial_ends_at"]),
        endsAt: json["ends_at"],
        userId: json["user_id"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "stripe_id": stripeId,
        "stripe_status": stripeStatus,
        "stripe_price": stripePrice,
        "quantity": quantity,
        "trial_ends_at": trialEndsAt?.toIso8601String(),
        "ends_at": endsAt,
        "user_id": userId,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
    };
}
