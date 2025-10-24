import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';

import '../../../common_widget/custom_network_image.dart';

class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ClipOval(
          child: CustomCachedNetworkImage(
            imageUrl: '',
            width: 32.w,
            height: 32.h,
          ),
        ),

        SvgPicture.asset(Assets.icons.logos),

        SvgPicture.asset(Assets.icons.icoddn),
      ],
    );
  }
}
