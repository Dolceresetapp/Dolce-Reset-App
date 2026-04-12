import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import 'common_widget/custom_svg_asset.dart';
import 'common_widget/guest_prompt_widget.dart';
import 'constants/app_constants.dart';
import 'constants/text_font_style.dart';
import 'features/chef/presentation/chef_screen.dart';
import 'features/excerises/presentation/excerise_screen.dart';
import 'features/motivation/presentation/motivation_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'gen/assets.gen.dart';
import 'helpers/di.dart';
import 'networks/api_acess.dart';
import 'services/preload_service.dart';
import 'services/subscription_service.dart';

class NavigationScreen extends StatefulWidget {
  final int initialIndex;
  const NavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late int currentIndex;
  bool _backgroundLoadingDone = false;
  late final bool _isGuest;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _isGuest = appData.read(kKeyIsGuest) ?? false;

    // Build screens based on guest mode
    _screens = [
      const ExceriseScreen(),
      _isGuest
          ? const GuestPromptWidget(
              title: 'Chef AI',
              subtitle: 'Registrati per accedere al generatore di ricette AI e all\'analizzatore di cibo.',
              icon: Icons.restaurant_outlined,
            )
          : const ChefScreen(),
      _isGuest
          ? const GuestPromptWidget(
              title: 'Motivazione',
              subtitle: 'Registrati per parlare con il tuo Coach AI e unirti alla community.',
              icon: Icons.psychology_outlined,
            )
          : const MotivationScreen(),
      _isGuest
          ? const GuestPromptWidget(
              title: 'Impostazioni',
              subtitle: 'Registrati per personalizzare il tuo profilo e le impostazioni.',
              icon: Icons.settings_outlined,
            )
          : const SettingsScreen(),
    ];

    if (!_backgroundLoadingDone && !_isGuest) {
      _backgroundLoadingDone = true;
      _startBackgroundLoading();
    }
  }

  Future<void> _startBackgroundLoading() async {
    // Step 1: Sync subscription (lightweight API call)
    subscriptionService.syncSubscriptionStatus();

    // Wait for UI to fully render before loading data
    await Future.delayed(const Duration(milliseconds: 800));

    // Step 2: Load essential data in parallel (already cached from CacheLoadingScreen)
    await Future.wait([
      categoryRxObj.categoryRx().catchError((_) => false),
      themeRxObj.themeRx().catchError((_) => false),
      myWorkoutRxObj.myWorkoutRx().catchError((_) => false),
    ]);

    // Step 3: Wait before starting heavy background work
    await Future.delayed(const Duration(seconds: 1));

    // Step 4: Preload dynamic workout data + course images (deferred from CacheLoadingScreen)
    preloadService.preloadDeepContent();

    // Step 5: Deep preload (thumbnails, music) — runs gently in background
    await Future.delayed(const Duration(seconds: 2));
    preloadService.preloadExerciseThumbnails();

    // Step 6: After another delay, preload remaining content
    await Future.delayed(const Duration(seconds: 2));
    preloadService.preloadAfterLogin();
    motivationCoachRxObj.motivationCoachRx(prompt: "Hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: StylishBottomBar(
        elevation: 5,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        option: AnimatedBarOptions(
          iconStyle: IconStyle.Default,
          inkEffect: true,
          barAnimation: BarAnimation.fade,
        ),
        items: [
          _bottomBarItem(
            assetName: Assets.icons.monotoneAdd,
            label: "Esercizi",
            isSelected: currentIndex == 0,
          ),
          _bottomBarItem(
            assetName: Assets.icons.monotoneAdd2,
            label: "Chef",
            isSelected: currentIndex == 1,
          ),
          _bottomBarItem(
            assetName: Assets.icons.transportRocketDiagonal,
            label: "Motivazione",
            isSelected: currentIndex == 2,
          ),
          _bottomBarItem(
            assetName: Assets.icons.monotoneAdd1,
            label: "Impostazioni",
            isSelected: currentIndex == 3,
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            setState(() {
              currentIndex = index;
            });
          }
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
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
          color: isSelected ? Colors.black : const Color(0xFFA1A1AA),
        ),
      ),
    ),
  );
}
