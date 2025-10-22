import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/gen/assets.gen.dart';

class ReceiverWidget extends StatelessWidget {
  const ReceiverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 0.5.sw,
        alignment: Alignment.topLeft,
        height: 400.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.container.path),
          ),
        ),
      ),
    );
  }
}
