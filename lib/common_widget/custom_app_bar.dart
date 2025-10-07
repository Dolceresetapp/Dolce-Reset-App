import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import '../helpers/navigation_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final Widget? title;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final TextStyle? style;
  final bool centerTitle;
  final double height;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    this.titleText,
    this.title,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.style,
    this.leading,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading:
          leading ??
          (automaticallyImplyLeading
              ? BackButton(
                color: AppColors.c051F42,
                onPressed: () {
                  NavigationService.goBack;
                },
              )
              : null),
      title:
          title ??
          Text(
            titleText ?? '',
            style: style ?? TextFontStyle.headLine18c051F42PoppinsW600,
          ),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions,
      backgroundColor: backgroundColor ?? AppColors.cF0F0F0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height.h);
}
