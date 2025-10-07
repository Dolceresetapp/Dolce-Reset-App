/* // ignore_for_file: use_super_parameters, library_private_types_in_public_api, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


// Global ValueNotifier for currentIndex
final ValueNotifier<int> globalCurrentIndexNotifier = ValueNotifier<int>(0);

class NavigationScreen extends StatefulWidget {
  final Widget? pageNum;

  const NavigationScreen({Key? key, this.pageNum}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  // ignore: unused_field
  int _colorIndex = 0;

  // ignore: prefer_final_fields
  bool _isFisrtBuild = true;
  // ignore: unused_field, prefer_final_fields
  bool _navigationOn = true;
  // bool _isFirstBuild = true;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatScreen(),
    const ReminderScreen(),
    const SavedArticalScreen(),
    const JournalScreen(),
  ];
  @override
  void initState() {
    super.initState();
    // _currentIndex = widget.pageNum ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    Object? args;
    StatefulWidget? screenPage;
    if (_isFisrtBuild) {
      args = ModalRoute.of(context)!.settings.arguments;
    }
    if (args != null) {
      _colorIndex = 4;
      screenPage = args as StatefulWidget;
      var newColorIndex = -1;

      for (var element in _screens) {
        newColorIndex++;
        if (element.toString() == screenPage.toString()) {
          _colorIndex = newColorIndex;
          Future.delayed(const Duration(microseconds: 300), () {
            globalCurrentIndexNotifier.value = _colorIndex;
          });

          break;
        }
      }
    }
    // ignore: no_leading_underscores_for_local_identifiers

    return WillPopScope(
        onWillPop: () async {
          showMaterialDialog(context);
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: const CustomDrawer(),
          backgroundColor: AppColors.cFFFFFF,
          extendBody: true,
          body: ValueListenableBuilder<int>(
            valueListenable: globalCurrentIndexNotifier,
            builder: (context, currentIndex, child) {
              return Center(
                child: (screenPage != null)
                    ? screenPage
                    : _screens.elementAt(_currentIndex),
              );
            },
          ),
          bottomNavigationBar: Container(
            height: 70.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.cFFFFFF,
                borderRadius: BorderRadius.circular(48.r),
                border:
                    Border.all(color: AppColors.allPrimaryColor, width: 1.5.h)),
            margin: EdgeInsets.symmetric(vertical: 24.h, horizontal: 32.h),
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.h),
            child: ValueListenableBuilder<int>(
                valueListenable: globalCurrentIndexNotifier,
                builder: (context, currentIndex, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomNavigationButtonWidget(
                        svgPath: Assets.icons.homeIcon,
                        title: "Home",
                        isActive: _currentIndex == 0,
                        onTap: () {
                          setState(() {
                            _currentIndex = 0;
                          });
                        },
                      ),
                      CustomNavigationButtonWidget(
                        svgPath: Assets.icons.chatIcon,
                        title: "Chat",
                        isActive: _currentIndex == 1,
                        onTap: () {
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                      ),
                      CustomNavigationButtonWidget(
                        svgPath: Assets.icons.reminderIcon,
                        title: "Reminder",
                        isActive: _currentIndex == 2,
                        onTap: () {
                          setState(() {
                            _currentIndex = 2;
                          });
                        },
                      ),
                      CustomNavigationButtonWidget(
                        svgPath: Assets.icons.bookmarkNavIcon,
                        title: "Bookmark",
                        isActive: _currentIndex == 3,
                        onTap: () {
                          setState(() {
                            _currentIndex = 3;
                          });
                        },
                      ),
                      CustomNavigationButtonWidget(
                        svgPath: Assets.icons.journalIcon,
                        title: "Journal",
                        isActive: _currentIndex == 4,
                        onTap: () {
                          setState(() {
                            _currentIndex = 4;
                          });
                        },
                      ),
                    ],
                  );
                }),
          ),
        ));
  }
}

class CustomNavigationButtonWidget extends StatefulWidget {
  final String svgPath, title;
  final Function() onTap;
  final bool isActive;
  const CustomNavigationButtonWidget(
      {super.key,
      required this.title,
      required this.svgPath,
      required this.onTap,
      required this.isActive});

  @override
  State<CustomNavigationButtonWidget> createState() =>
      _CustomNavigationButtonWidgetState();
}

class _CustomNavigationButtonWidgetState
    extends State<CustomNavigationButtonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: widget.isActive
          ? Column(
              children: [
                SvgPicture.asset(
                  widget.svgPath,
                  color: AppColors.allPrimaryColor,
                ),
                UIHelper.verticalSpace(4.h),
                Text(
                  widget.title,
                  style: TextFontStyle.headline16c333333tyleMontserratW500
                      .copyWith(
                          color: AppColors.allPrimaryColor, fontSize: 10.sp),
                )
              ],
            )
          : SvgPicture.asset(
              widget.svgPath,
              color: AppColors.cCBCBCB,
            ),
    );
  }
}

class CenterButtonWidget extends StatelessWidget {
  final String svgPath;
  const CenterButtonWidget(
      {super.key, required this.onTap, required this.svgPath});
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85.h,
        width: 85.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cFFFFFF,
        ),
        padding: EdgeInsets.all(6.sp),
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.cFAD0E6, shape: BoxShape.circle),
          padding: EdgeInsets.all(6.sp),
          child: Container(
            decoration: const BoxDecoration(
                color: AppColors.allPrimaryColor, shape: BoxShape.circle),
            padding: EdgeInsets.all(15.sp),
            child: SvgPicture.asset(svgPath),
          ),
        ),
      ),
    );
  }
}
 */