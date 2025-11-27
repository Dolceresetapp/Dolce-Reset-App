import 'dart:convert';

class PaymentSheetResponseModel {
    String? status;
    String? message;
    Data? data;

    PaymentSheetResponseModel({
        this.status,
        this.message,
        this.data,
    });

    PaymentSheetResponseModel copyWith({
        String? status,
        String? message,
        Data? data,
    }) => 
        PaymentSheetResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory PaymentSheetResponseModel.fromRawJson(String str) => PaymentSheetResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PaymentSheetResponseModel.fromJson(Map<String, dynamic> json) => PaymentSheetResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    Intent? intent;

    Data({
        this.intent,
    });

    Data copyWith({
        Intent? intent,
    }) => 
        Data(
            intent: intent ?? this.intent,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        intent: json["intent"] == null ? null : Intent.fromJson(json["intent"]),
    );

    Map<String, dynamic> toJson() => {
        "intent": intent?.toJson(),
    };
}

class Intent {
    String? id;
    String? object;
    dynamic application;
    dynamic automaticPaymentMethods;
    dynamic cancellationReason;
    String? clientSecret;
    int? created;
    String? customer;
    dynamic description;
    dynamic excludedPaymentMethodTypes;
    dynamic flowDirections;
    dynamic lastSetupError;
    dynamic latestAttempt;
    bool? livemode;
    dynamic mandate;
    Metadata? metadata;
    dynamic nextAction;
    dynamic onBehalfOf;
    dynamic paymentMethod;
    dynamic paymentMethodConfigurationDetails;
    PaymentMethodOptions? paymentMethodOptions;
    List<String>? paymentMethodTypes;
    dynamic singleUseMandate;
    String? status;
    String? usage;

    Intent({
        this.id,
        this.object,
        this.application,
        this.automaticPaymentMethods,
        this.cancellationReason,
        this.clientSecret,
        this.created,
        this.customer,
        this.description,
        this.excludedPaymentMethodTypes,
        this.flowDirections,
        this.lastSetupError,
        this.latestAttempt,
        this.livemode,
        this.mandate,
        this.metadata,
        this.nextAction,
        this.onBehalfOf,
        this.paymentMethod,
        this.paymentMethodConfigurationDetails,
        this.paymentMethodOptions,
        this.paymentMethodTypes,
        this.singleUseMandate,
        this.status,
        this.usage,
    });

    Intent copyWith({
        String? id,
        String? object,
        dynamic application,
        dynamic automaticPaymentMethods,
        dynamic cancellationReason,
        String? clientSecret,
        int? created,
        String? customer,
        dynamic description,
        dynamic excludedPaymentMethodTypes,
        dynamic flowDirections,
        dynamic lastSetupError,
        dynamic latestAttempt,
        bool? livemode,
        dynamic mandate,
        Metadata? metadata,
        dynamic nextAction,
        dynamic onBehalfOf,
        dynamic paymentMethod,
        dynamic paymentMethodConfigurationDetails,
        PaymentMethodOptions? paymentMethodOptions,
        List<String>? paymentMethodTypes,
        dynamic singleUseMandate,
        String? status,
        String? usage,
    }) => 
        Intent(
            id: id ?? this.id,
            object: object ?? this.object,
            application: application ?? this.application,
            automaticPaymentMethods: automaticPaymentMethods ?? this.automaticPaymentMethods,
            cancellationReason: cancellationReason ?? this.cancellationReason,
            clientSecret: clientSecret ?? this.clientSecret,
            created: created ?? this.created,
            customer: customer ?? this.customer,
            description: description ?? this.description,
            excludedPaymentMethodTypes: excludedPaymentMethodTypes ?? this.excludedPaymentMethodTypes,
            flowDirections: flowDirections ?? this.flowDirections,
            lastSetupError: lastSetupError ?? this.lastSetupError,
            latestAttempt: latestAttempt ?? this.latestAttempt,
            livemode: livemode ?? this.livemode,
            mandate: mandate ?? this.mandate,
            metadata: metadata ?? this.metadata,
            nextAction: nextAction ?? this.nextAction,
            onBehalfOf: onBehalfOf ?? this.onBehalfOf,
            paymentMethod: paymentMethod ?? this.paymentMethod,
            paymentMethodConfigurationDetails: paymentMethodConfigurationDetails ?? this.paymentMethodConfigurationDetails,
            paymentMethodOptions: paymentMethodOptions ?? this.paymentMethodOptions,
            paymentMethodTypes: paymentMethodTypes ?? this.paymentMethodTypes,
            singleUseMandate: singleUseMandate ?? this.singleUseMandate,
            status: status ?? this.status,
            usage: usage ?? this.usage,
        );

    factory Intent.fromRawJson(String str) => Intent.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Intent.fromJson(Map<String, dynamic> json) => Intent(
        id: json["id"],
        object: json["object"],
        application: json["application"],
        automaticPaymentMethods: json["automatic_payment_methods"],
        cancellationReason: json["cancellation_reason"],
        clientSecret: json["client_secret"],
        created: json["created"],
        customer: json["customer"],
        description: json["description"],
        excludedPaymentMethodTypes: json["excluded_payment_method_types"],
        flowDirections: json["flow_directions"],
        lastSetupError: json["last_setup_error"],
        latestAttempt: json["latest_attempt"],
        livemode: json["livemode"],
        mandate: json["mandate"],
        metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
        nextAction: json["next_action"],
        onBehalfOf: json["on_behalf_of"],
        paymentMethod: json["payment_method"],
        paymentMethodConfigurationDetails: json["payment_method_configuration_details"],
        paymentMethodOptions: json["payment_method_options"] == null ? null : PaymentMethodOptions.fromJson(json["payment_method_options"]),
        paymentMethodTypes: json["payment_method_types"] == null ? [] : List<String>.from(json["payment_method_types"]!.map((x) => x)),
        singleUseMandate: json["single_use_mandate"],
        status: json["status"],
        usage: json["usage"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "application": application,
        "automatic_payment_methods": automaticPaymentMethods,
        "cancellation_reason": cancellationReason,
        "client_secret": clientSecret,
        "created": created,
        "customer": customer,
        "description": description,
        "excluded_payment_method_types": excludedPaymentMethodTypes,
        "flow_directions": flowDirections,
        "last_setup_error": lastSetupError,
        "latest_attempt": latestAttempt,
        "livemode": livemode,
        "mandate": mandate,
        "metadata": metadata?.toJson(),
        "next_action": nextAction,
        "on_behalf_of": onBehalfOf,
        "payment_method": paymentMethod,
        "payment_method_configuration_details": paymentMethodConfigurationDetails,
        "payment_method_options": paymentMethodOptions?.toJson(),
        "payment_method_types": paymentMethodTypes == null ? [] : List<dynamic>.from(paymentMethodTypes!.map((x) => x)),
        "single_use_mandate": singleUseMandate,
        "status": status,
        "usage": usage,
    };
}

class Metadata {
    String? planId;

    Metadata({
        this.planId,
    });

    Metadata copyWith({
        String? planId,
    }) => 
        Metadata(
            planId: planId ?? this.planId,
        );

    factory Metadata.fromRawJson(String str) => Metadata.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        planId: json["plan_id"],
    );

    Map<String, dynamic> toJson() => {
        "plan_id": planId,
    };
}

class PaymentMethodOptions {
    Card? card;

    PaymentMethodOptions({
        this.card,
    });

    PaymentMethodOptions copyWith({
        Card? card,
    }) => 
        PaymentMethodOptions(
            card: card ?? this.card,
        );

    factory PaymentMethodOptions.fromRawJson(String str) => PaymentMethodOptions.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) => PaymentMethodOptions(
        card: json["card"] == null ? null : Card.fromJson(json["card"]),
    );

    Map<String, dynamic> toJson() => {
        "card": card?.toJson(),
    };
}

class Card {
    dynamic mandateOptions;
    dynamic network;
    String? requestThreeDSecure;

    Card({
        this.mandateOptions,
        this.network,
        this.requestThreeDSecure,
    });

    Card copyWith({
        dynamic mandateOptions,
        dynamic network,
        String? requestThreeDSecure,
    }) => 
        Card(
            mandateOptions: mandateOptions ?? this.mandateOptions,
            network: network ?? this.network,
            requestThreeDSecure: requestThreeDSecure ?? this.requestThreeDSecure,
        );

    factory Card.fromRawJson(String str) => Card.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Card.fromJson(Map<String, dynamic> json) => Card(
        mandateOptions: json["mandate_options"],
        network: json["network"],
        requestThreeDSecure: json["request_three_d_secure"],
    );

    Map<String, dynamic> toJson() => {
        "mandate_options": mandateOptions,
        "network": network,
        "request_three_d_secure": requestThreeDSecure,
    };
}
