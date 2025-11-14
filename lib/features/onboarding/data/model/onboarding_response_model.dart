import 'dart:convert';

class OnboardingResponseModel {
    String? status;
    String? message;
    Data? data;

    OnboardingResponseModel({
        this.status,
        this.message,
        this.data,
    });

    OnboardingResponseModel copyWith({
        String? status,
        String? message,
        Data? data,
    }) => 
        OnboardingResponseModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory OnboardingResponseModel.fromRawJson(String str) => OnboardingResponseModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OnboardingResponseModel.fromJson(Map<String, dynamic> json) => OnboardingResponseModel(
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
    String? age;
    String? bmi;
    String? bodyPartFocus;
    String? bodySatisfaction;
    String? celebrationPlan;
    String? currentBodyType;
    String? currentWeight;
    String? currentWeightIn;
    String? dreamBody;
    String? height;
    String? heightIn;
    String? targetWeight;
    String? targetWeightIn;
    String? tryingDuration;
    String? urgentImprovement;
    String? signature;

    Data({
        this.age,
        this.bmi,
        this.bodyPartFocus,
        this.bodySatisfaction,
        this.celebrationPlan,
        this.currentBodyType,
        this.currentWeight,
        this.currentWeightIn,
        this.dreamBody,
        this.height,
        this.heightIn,
        this.targetWeight,
        this.targetWeightIn,
        this.tryingDuration,
        this.urgentImprovement,
        this.signature,
    });

    Data copyWith({
        String? age,
        String? bmi,
        String? bodyPartFocus,
        String? bodySatisfaction,
        String? celebrationPlan,
        String? currentBodyType,
        String? currentWeight,
        String? currentWeightIn,
        String? dreamBody,
        String? height,
        String? heightIn,
        String? targetWeight,
        String? targetWeightIn,
        String? tryingDuration,
        String? urgentImprovement,
        String? signature,
    }) => 
        Data(
            age: age ?? this.age,
            bmi: bmi ?? this.bmi,
            bodyPartFocus: bodyPartFocus ?? this.bodyPartFocus,
            bodySatisfaction: bodySatisfaction ?? this.bodySatisfaction,
            celebrationPlan: celebrationPlan ?? this.celebrationPlan,
            currentBodyType: currentBodyType ?? this.currentBodyType,
            currentWeight: currentWeight ?? this.currentWeight,
            currentWeightIn: currentWeightIn ?? this.currentWeightIn,
            dreamBody: dreamBody ?? this.dreamBody,
            height: height ?? this.height,
            heightIn: heightIn ?? this.heightIn,
            targetWeight: targetWeight ?? this.targetWeight,
            targetWeightIn: targetWeightIn ?? this.targetWeightIn,
            tryingDuration: tryingDuration ?? this.tryingDuration,
            urgentImprovement: urgentImprovement ?? this.urgentImprovement,
            signature: signature ?? this.signature,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        age: json["age"],
        bmi: json["bmi"],
        bodyPartFocus: json["body_part_focus"],
        bodySatisfaction: json["body_satisfaction"],
        celebrationPlan: json["celebration_plan"],
        currentBodyType: json["current_body_type"],
        currentWeight: json["current_weight"],
        currentWeightIn: json["current_weight_in"],
        dreamBody: json["dream_body"],
        height: json["height"],
        heightIn: json["height_in"],
        targetWeight: json["target_weight"],
        targetWeightIn: json["target_weight_in"],
        tryingDuration: json["trying_duration"],
        urgentImprovement: json["urgent_improvement"],
        signature: json["signature"],
    );

    Map<String, dynamic> toJson() => {
        "age": age,
        "bmi": bmi,
        "body_part_focus": bodyPartFocus,
        "body_satisfaction": bodySatisfaction,
        "celebration_plan": celebrationPlan,
        "current_body_type": currentBodyType,
        "current_weight": currentWeight,
        "current_weight_in": currentWeightIn,
        "dream_body": dreamBody,
        "height": height,
        "height_in": heightIn,
        "target_weight": targetWeight,
        "target_weight_in": targetWeightIn,
        "trying_duration": tryingDuration,
        "urgent_improvement": urgentImprovement,
        "signature": signature,
    };
}
