import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';

import '../../../common_widget/custom_network_image.dart';

class ProfileSectionWidget extends StatelessWidget {
  final String avatar;
  const ProfileSectionWidget({super.key, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipOval(
          child: avatar.isEmpty
              ? Container(
                  width: 42.w,
                  height: 42.h,
                  color: const Color(0xFFE5E5E5),
                  child: Icon(
                    Icons.person,
                    size: 26.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                )
              : CustomCachedNetworkImage(
                  imageUrl: avatar,
                  width: 42.w,
                  height: 42.h,
                ),
        ),

        SvgPicture.asset(Assets.icons.logos),

        SvgPicture.asset(Assets.icons.icoddn),
      ],
    );
  }
}
