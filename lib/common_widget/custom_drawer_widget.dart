/* import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poswell_app/constants/text_font_style.dart';
import 'package:poswell_app/helpers/all_routes.dart';
import 'package:poswell_app/helpers/loading_helper.dart';
import 'package:poswell_app/helpers/navigation_service.dart';
import 'package:poswell_app/networks/api_acess.dart';

import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../helpers/ui_helpers.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cFFFFFF,
      child: Column(
        // padding: EdgeInsets.zero,
        children: [
          UIHelper.verticalSpace(40.h),
          Center(
            child: Text(
              "Baby Sleep",
              style: TextFontStyle.headline28cFFFFFFStyleOpenSenseW700.copyWith(
                color: AppColors.c2F1E19,
              ),
            ),
          ),
          UIHelper.verticalSpace(40.w),
          DrawerItemWidget(
            iconPath: Assets.icons.userProfileIcon,
            itemName: 'User Profile',
            onTap: () => NavigationService.navigateTo(Routes.userProfileScreen),
          ),
          DrawerItemWidget(
            iconPath: Assets.icons.lock,
            itemName: 'Change Password',
            onTap: () => NavigationService.navigateTo(Routes.updatePasswordScreen),
          ),
          DrawerItemWidget(
            iconPath: Assets.icons.desclimer,
            itemName: 'Disclaimer',
            onTap: () {},
          ),
          DrawerItemWidget(
            iconPath: Assets.icons.privacyPolicy,
            itemName: 'Privacy Policy',
            onTap: () {},
          ),
          DrawerItemWidget(
            iconPath: Assets.icons.aboutUsIcon,
            itemName: 'About Us',
            onTap: () => NavigationService.navigateTo(Routes.aboutUsScreen),
          ),
          DrawerItemWidget(
            iconPath: Assets.icons.logoutIcon,
            itemName: 'Log Out',
            onTap: () {
              showMaterialDialog(context);
            },
          ),
          const Spacer(),
          Container(
            height: 130.h,
            width: double.infinity,
            margin:
                EdgeInsets.symmetric(horizontal: UIHelper.kDefaulutPadding()),
            decoration: BoxDecoration(
                color: AppColors.cEBE6DC,
                borderRadius: BorderRadius.circular(12.r)),
            alignment: Alignment.center,
            child: Text(
              "Banner",
              style: TextFontStyle.text16c2F1E19StyleRobotoW600,
            ),
          ),
          UIHelper.verticalSpaceMedium
        ],
      ),
    );
  }

  void showMaterialDialog(
    BuildContext context,
  ) {
    showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.r))),
              title: Column(
                children: [
                  Text(
                    "Log Out",
                    textAlign: TextAlign.center,
                    style: TextFontStyle.text16c2F1E19StyleRobotoW600,
                  ),
                  UIHelper.verticalSpace(16.h),
                  SizedBox(
                    width: 250.w,
                    child: DottedLine(
                      // lineThickness: 2.h,
                      dashColor: AppColors.c6C564C,
                      dashLength: 10.w,
                    ),
                  ),
                  UIHelper.verticalSpace(16.h),
                  Text(
                    "Are you sure you want to log out?",
                    textAlign: TextAlign.center,
                    style: TextFontStyle.text16c6C564CStyleRobotoW400,
                  )
                ],
              ),
              actions: <Widget>[
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                               Navigator.of(context).pop(false);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 10.w
                              ),
                              width: double.infinity,
                              height: 40.sp,
                              decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(color: AppColors.cB18E5E )
                              ),
                              // alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No",
                                    style: TextFontStyle.text16c2F1E19StyleRobotoW600
                                        .copyWith(color: AppColors.c2F1E19),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // UIHelper.horizontalSpace(10.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              logOutRXObj.logOut().waitingForSucess().then(
                                (sucess){
                                  if(sucess){
                                    NavigationService.popAndReplace(Routes.welcomeScreen);
                                  }
                                }
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                horizontal: 10.w
                              ),
                              height: 40.sp,
                              decoration: ShapeDecoration(
                                gradient: const RadialGradient(
                                  center: Alignment(0.00, -1.7),
                                  radius: 2,
                                  colors: [Color(0xFFEBE6E0), Color(0xFFCBC1B4)],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r)),
                              ),
                              // alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Yes",
                                    style: TextFontStyle.text16c2F1E19StyleRobotoW600
                                        .copyWith(color: AppColors.c2F1E19),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    UIHelper.verticalSpace(10.h)
                  ],
                ),
              ],
            ));
  }
}

class DrawerItemWidget extends StatelessWidget {
  final String itemName, iconPath;
  final VoidCallback? onTap;

  const DrawerItemWidget({
    required this.itemName,
    required this.iconPath,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: UIHelper.kDefaulutPadding()),
            child: Column(
              children: [
                UIHelper.verticalSpace(20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                              color: AppColors.cEBE6DC,
                              borderRadius: BorderRadius.circular(4.r)),
                          padding: EdgeInsets.all(8.sp),
                          child: SvgPicture.asset(iconPath),
                        ),
                        UIHelper.horizontalSpace(16.w),
                        Text(itemName,
                            style: TextFontStyle.text16c2F1E19StyleRobotoW700),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
                UIHelper.verticalSpace(20.h),
                DottedLine(
                  lineThickness: 1.5.h,
                  dashColor: AppColors.c6C564C.withOpacity(0.4),
                  dashLength: 10.w,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 */