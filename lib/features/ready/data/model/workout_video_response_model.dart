import 'dart:convert';

class WorkoutWiseVideoResponseModel {
  bool? success;
  String? message;
  int? totalCal;
  int? minutes;
  int? listId;
  List<Datum>? data;

  WorkoutWiseVideoResponseModel({
    this.success,
    this.message,
    this.totalCal,
    this.minutes,
    this.listId,
    this.data,
  });

  WorkoutWiseVideoResponseModel copyWith({
    bool? success,
    String? message,
    int? totalCal,
    int? minutes,
    int? listId,
    List<Datum>? data,
  }) => WorkoutWiseVideoResponseModel(
    success: success ?? this.success,
    message: message ?? this.message,
    totalCal: totalCal ?? this.totalCal,
    minutes: minutes ?? this.minutes,
    listId: listId ?? this.listId,
    data: data ?? this.data,
  );

  factory WorkoutWiseVideoResponseModel.fromRawJson(String str) =>
      WorkoutWiseVideoResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WorkoutWiseVideoResponseModel.fromJson(Map<String, dynamic> json) =>
      WorkoutWiseVideoResponseModel(
        success: json["success"],
        message: json["message"],
        totalCal: json["total_cal"],
        minutes: json["minutes"],
        listId: json["list_id"],
        data:
            json["data"] == null
                ? []
                : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "total_cal": totalCal,
    "minutes": minutes,
    "list_id": listId,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  int? id;
  String? title;
  String? thumbnail;
  int? seconds;
  String? descriptions;
  String? videos;
  List<Music>? music;

  Datum({
    this.id,
    this.title,
    this.thumbnail,
    this.seconds,
    this.descriptions,
    this.videos,
    this.music,
  });

  Datum copyWith({
    int? id,
    String? title,
    String? thumbnail,
    int? seconds,
    String? descriptions,
    String? videos,
    List<Music>? music,
  }) => Datum(
    id: id ?? this.id,
    title: title ?? this.title,
    thumbnail: thumbnail ?? this.thumbnail,
    seconds: seconds ?? this.seconds,
    descriptions: descriptions ?? this.descriptions,
    videos: videos ?? this.videos,
    music: music ?? this.music,
  );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    thumbnail: json["thumbnail"],
    seconds: json["seconds"],
    descriptions: json["descriptions"],
    videos: json["videos"],
    music:
        json["music"] == null
            ? []
            : List<Music>.from(json["music"]!.map((x) => Music.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnail": thumbnail,
    "seconds": seconds,
    "descriptions": descriptions,
    "videos": videos,
    "music":
        music == null ? [] : List<dynamic>.from(music!.map((x) => x.toJson())),
  };
}

class Music {
  int? id;
  int? workoutVideosId;
  String? musicFile;
  String? title;
  String? duration;

  Music({
    this.id,
    this.workoutVideosId,
    this.musicFile,
    this.title,
    this.duration,
  });

  Music copyWith({
    int? id,
    int? workoutVideosId,
    String? musicFile,
    String? title,
    String? duration,
  }) => Music(
    id: id ?? this.id,
    workoutVideosId: workoutVideosId ?? this.workoutVideosId,
    musicFile: musicFile ?? this.musicFile,
    title: title ?? this.title,
    duration: duration ?? this.duration,
  );

  factory Music.fromRawJson(String str) => Music.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Music.fromJson(Map<String, dynamic> json) => Music(
    id: json["id"],
    workoutVideosId: json["workout_videos_id"],
    musicFile: json["music_file"],
    title: json["title"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "workout_videos_id": workoutVideosId,
    "music_file": musicFile,
    "title": title,
    "duration": duration,
  };
}
