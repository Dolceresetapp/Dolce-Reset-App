import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/navigation_service.dart';

class ProfileSectionWidget extends StatelessWidget {
  final String avatar;
  const ProfileSectionWidget({super.key, required this.avatar});

  Widget _buildDefaultAvatar() {
    return Container(
      width: 42.w,
      height: 42.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE5E5E5),
      ),
      child: Icon(
        Icons.person,
        size: 26.sp,
        color: const Color(0xFF9CA3AF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            NavigationService.navigateToWithArgs(Routes.navigationScreen, {"index": 3});
          },
          child: Container(
            width: 42.w,
            height: 42.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE5E5E5),
            ),
            clipBehavior: Clip.antiAlias,
            child: avatar.isEmpty
                ? Icon(
                    Icons.person,
                    size: 26.sp,
                    color: const Color(0xFF9CA3AF),
                  )
                : Image.network(
                    avatar,
                    width: 42.w,
                    height: 42.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 26.sp,
                        color: const Color(0xFF9CA3AF),
                      );
                    },
                  ),
          ),
        ),

        SvgPicture.asset(Assets.icons.logos),

        SvgPicture.asset(Assets.icons.icoddn),
      ],
    );
  }
}
