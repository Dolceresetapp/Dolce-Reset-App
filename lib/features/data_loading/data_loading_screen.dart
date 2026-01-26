import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';
import '../../helpers/all_routes.dart';
import '../../helpers/navigation_service.dart';
import '../../networks/api_acess.dart';

/// Screen that preloads all data before showing the main app
/// This ensures instant UX with no loading spinners
class DataLoadingScreen extends StatefulWidget {
  const DataLoadingScreen({super.key});

  @override
  State<DataLoadingScreen> createState() => _DataLoadingScreenState();
}

class _DataLoadingScreenState extends State<DataLoadingScreen> {
  String _status = 'Loading your data...';

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      // Load all data in parallel for speed
      setState(() => _status = 'Loading categories...');

      await Future.wait([
        _loadWithStatus(() => categoryRxObj.categoryRx(), 'Categories'),
        _loadWithStatus(() => themeRxObj.themeRx(), 'Themes'),
        _loadWithStatus(() => myWorkoutRxObj.myWorkoutRx(), 'Workouts'),
        _loadWithStatus(() => userInfoRxObj.getUserInfo(), 'Profile'),
      ]);

      setState(() => _status = 'Ready!');

      // Small delay to show "Ready!" message
      await Future.delayed(const Duration(milliseconds: 300));

      // Navigate to main screen
      if (mounted) {
        NavigationService.navigateToReplacement(Routes.navigationScreen);
      }
    } catch (e) {
      // Even on error, proceed to main screen (data will load there)
      if (mounted) {
        NavigationService.navigateToReplacement(Routes.navigationScreen);
      }
    }
  }

  Future<void> _loadWithStatus(Future<void> Function() loader, String name) async {
    try {
      await loader();
    } catch (e) {
      // Ignore individual errors, continue loading
      debugPrint('Failed to load $name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or loading animation
            Lottie.asset(
              Assets.lottie.loadingSpinner,
              width: 120.w,
              height: 120.h,
            ),
            SizedBox(height: 24.h),
            Text(
              _status,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
