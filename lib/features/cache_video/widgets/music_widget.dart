import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../ready/data/model/workout_video_response_model.dart';

class MusicWidget extends StatelessWidget {
  final List<Music>? music;
  final AudioPlayer? audioPlayer;

  const MusicWidget({super.key, this.audioPlayer, required this.music});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Close button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.cancel, size: 30.sp, color: Color(0xFFF566A9)),
            ),
          ),

          /// Music list or empty message
          if (music == null || music!.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50.h),
              child: Text(
                "Music not available for this video",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: music!.length,
              itemBuilder: (_, index) {
                var data = music![index];
                return Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: Color(0xFFF566A9).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ListTile(
                    title: Text(data.title ?? ""),
                    trailing: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (audioPlayer != null) {
                            await audioPlayer!.stop();
                          }
                          await audioPlayer?.play(
                            UrlSource(data.musicFile ?? ''),
                            volume: 1.0,
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
