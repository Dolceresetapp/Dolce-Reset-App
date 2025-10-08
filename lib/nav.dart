import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'common_widget/custom_svg_asset.dart';
import 'features/chef/presentation/chef_screen.dart';
import 'features/excerises/presentation/excerise_screen.dart';
import 'features/motivation/presentation/motivation_screen.dart';
import 'constants/text_font_style.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'gen/assets.gen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 2;
  final List<Widget> widgetList = [
    ExceriseScreen(),
    ChefScreen(),
    MotivationScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: widgetList[currentIndex],
      bottomNavigationBar: StylishBottomBar(
        elevation: 5,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        option: AnimatedBarOptions(
          iconStyle: IconStyle.Default,
          inkEffect: true,
          barAnimation: BarAnimation.fade,
        ),
        items: [
          _bottomBarItem(
            assetName: Assets.icons.monotoneAdd,
            label: "Exercises",
            isSelected: currentIndex == 0,
          ),

          _bottomBarItem(
            assetName: Assets.icons.monotoneAdd2,
            label: "Chef",
            isSelected: currentIndex == 1,
          ),

          _bottomBarItem(
            assetName: Assets.icons.transportRocketDiagonal,
            label: "Motivation",
            isSelected: currentIndex == 2,
          ),

          _bottomBarItem(
            assetName: Assets.icons.monotoneAdd1,
            label: "Settings",
            isSelected: currentIndex == 3,
          ),
        ],

        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

BottomBarItem _bottomBarItem({
  required String assetName,
  required String label,
  bool isSelected = false,
}) {
  return BottomBarItem(
    icon: Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomSvgAsset(
        assetName: assetName,
        width: 24.w,
        height: 24.h,
        color: const Color(0xFFA1A1AA),
      ),
    ),
    selectedIcon: Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomSvgAsset(
        assetName: assetName,
        width: 24.w,
        height: 24.h,
        color: isSelected ? const Color(0xFFF566A9) : const Color(0xFFA1A1AA),
      ),
    ),
    title: Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextFontStyle.headline30c27272AtyleWorkSansW700.copyWith(
          fontSize: 12.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? const Color(0xFFF566A9) : const Color(0xFFA1A1AA),
        ),
      ),
    ),
  );
}
