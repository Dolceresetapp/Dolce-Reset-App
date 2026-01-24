import 'dart:convert';

class FaqResponseModel {
  bool? success;
  String? message;
  List<Faq>? faq;

  FaqResponseModel({
    this.success,
    this.message,
    this.faq,
  });

  factory FaqResponseModel.fromRawJson(String str) =>
      FaqResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) =>
      FaqResponseModel(
        success: json["success"],
        message: json["message"],
        faq: json["faq"] == null
            ? []
            : List<Faq>.from(json["faq"]!.map((x) => Faq.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "faq": faq == null
            ? []
            : List<dynamic>.from(faq!.map((x) => x.toJson())),
      };
}

class Faq {
  int? id;
  String? question;
  String? answer;
  String? status;

  Faq({
    this.id,
    this.question,
    this.answer,
    this.status,
  });

  factory Faq.fromRawJson(String str) => Faq.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        id: json["id"],
        question: json["question"],
        answer: json["answer"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "answer": answer,
        "status": status,
      };
}
