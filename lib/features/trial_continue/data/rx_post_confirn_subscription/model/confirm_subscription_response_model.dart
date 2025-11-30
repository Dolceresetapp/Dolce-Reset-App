import 'dart:convert';

class ConfirmSubscriptionResponseModel {
    String? clientSecret;
    String? paymentIntentId;

    ConfirmSubscriptionResponseModel({
        this.clientSecret,
        this.paymentIntentId,
    });

    ConfirmSubscriptionResponseModel copyWith({
        String? clientSecret,
        String? paymentIntentId,
    }) => 
        ConfirmSubscriptionResponseModel(
            clientSecret: clientSecret ?? this.clientSecret,
            paymentIntentId: paymentIntentId ?? this.paymentIntentId,
        );

    factory ConfirmSubscriptionResponseModel.fromRawJson(String str) => ConfirmSubscriptionResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConfirmSubscriptionResponseModel.fromJson(Map<String, dynamic> json) => ConfirmSubscriptionResponseModel(
        clientSecret: json["client_secret"],
        paymentIntentId: json["payment_intent_id"],
    );

    Map<String, dynamic> toJson() => {
        "client_secret": clientSecret,
        "payment_intent_id": paymentIntentId,
    };
}
