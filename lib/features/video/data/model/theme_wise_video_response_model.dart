// import 'dart:convert';

// class ThemeWiseVideoResponseModel {
//   bool? status;
//   String? message;
//   int? code;
//   List<Datum>? data;

//   ThemeWiseVideoResponseModel({
//     this.status,
//     this.message,
//     this.code,
//     this.data,
//   });

//   ThemeWiseVideoResponseModel copyWith({
//     bool? status,
//     String? message,
//     int? code,
//     List<Datum>? data,
//   }) => ThemeWiseVideoResponseModel(
//     status: status ?? this.status,
//     message: message ?? this.message,
//     code: code ?? this.code,
//     data: data ?? this.data,
//   );

//   factory ThemeWiseVideoResponseModel.fromRawJson(String str) =>
//       ThemeWiseVideoResponseModel.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory ThemeWiseVideoResponseModel.fromJson(Map<String, dynamic> json) =>
//       ThemeWiseVideoResponseModel(
//         status: json["status"],
//         message: json["message"],
//         code: json["code"],
//         data:
//             json["data"] == null
//                 ? []
//                 : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "message": message,
//     "code": code,
//     "data":
//         data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
//   };
// }

// class Datum {
//   int? id;
//   int? minutes;
//   int? calories;
//   String? image;
//   String? video;
//   String? title;
//   int? themeId;

//   Datum({
//     this.id,
//     this.minutes,
//     this.calories,
//     this.image,
//     this.video,
//     this.title,
//     this.themeId,
//   });

//   Datum copyWith({
//     int? id,
//     int? minutes,
//     int? calories,
//     String? image,
//     String? video,
//     String? title,
//     int? themeId,
//   }) => Datum(
//     id: id ?? this.id,
//     minutes: minutes ?? this.minutes,
//     calories: calories ?? this.calories,
//     image: image ?? this.image,
//     video: video ?? this.video,
//     title: title ?? this.title,
//     themeId: themeId ?? this.themeId,
//   );

//   factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["id"],
//     minutes: json["minutes"],
//     calories: json["calories"],
//     image: json["image"],
//     video: json["video"],
//     title: json["title"],
//     themeId: json["theme_id"],
//   );

//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "minutes": minutes,
//     "calories": calories,
//     "image": image,
//     "video": video,
//     "title": title,
//     "theme_id": themeId,
//   };
// }
