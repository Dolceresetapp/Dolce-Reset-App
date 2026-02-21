import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/gen/assets.gen.dart';
import 'package:gritti_app/helpers/all_routes.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/loading_helper.dart';
import 'package:gritti_app/helpers/navigation_service.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/common_widget/custom_network_image.dart';
import 'package:gritti_app/networks/dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../networks/api_acess.dart';
import '../../../helpers/helper_methods.dart';
import '../widgets/settings_title_widget.dart';
import '../widgets/settings_toggle_widget.dart';
import '../widgets/user_info_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification toggle states
  bool _generalNotifications = true;
  bool _emailNotifications = true;
  bool _soundNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationSettings();
  }

  void _loadNotificationSettings() {
    _generalNotifications = appData.read('generalNotifications') ?? true;
    _emailNotifications = appData.read('emailNotifications') ?? true;
    _soundNotifications = appData.read('soundNotifications') ?? true;
  }

  void _saveNotificationSetting(String key, bool value) {
    appData.write(key, value);
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Prossimamente!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFF566A9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleSubscriptionBilling() async {
    try {
      log('========== SUBSCRIPTION BILLING ==========');

      // Web2Wave users: open Web2Wave manage page (works on all platforms)
      final paymentSource = appData.read('payment_source');
      if (paymentSource == 'web2wave') {
        log('>>> Web2Wave user: Opening Web2Wave manage page...');
        final userEmail = appData.read(kKeyEmail)?.toString() ?? '';
        final url = Uri.parse('https://dolce-reset-ltd.web2wave.com/manage-subscription?email=${Uri.encodeComponent(userEmail)}');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        log('==========================================');
        return;
      }

      // On iOS, redirect to Apple subscription management (Guideline 3.1.1)
      if (Platform.isIOS) {
        log('>>> iOS: Opening App Store subscriptions...');
        final url = Uri.parse('https://apps.apple.com/account/subscriptions');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
        log('==========================================');
        return;
      }

      final subscriptionInfo = await subscriptionManagementRxObj.getSubscriptionInfo();
      log('Subscription info received: $subscriptionInfo');

      if (!mounted) return;

      if (subscriptionInfo == null) {
        log('subscriptionInfo is NULL - API may have failed');
        _showError('Impossibile recuperare info abbonamento');
        return;
      }

      final paymentMethod = subscriptionInfo['payment_method'];
      final hasStripeCustomer = subscriptionInfo['has_stripe_customer'] == true;

      log('payment_method: $paymentMethod');
      log('has_stripe_customer: $hasStripeCustomer');

      if (paymentMethod == 'stripe' || paymentMethod == 'web' || hasStripeCustomer) {
        log('>>> Opening Stripe billing portal...');
        final portalUrl = await subscriptionManagementRxObj.getBillingPortalUrl();
        log('Portal URL: $portalUrl');
        if (!mounted) return;

        if (portalUrl != null) {
          final url = Uri.parse(portalUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        } else {
          _showError('Impossibile aprire il portale di fatturazione');
        }
      } else if (paymentMethod == 'google') {
        log('>>> Opening Google Play subscriptions...');
        final url = Uri.parse('https://play.google.com/store/account/subscriptions');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      } else {
        log('>>> No payment method, using platform default...');
        final url = Uri.parse('https://play.google.com/store/account/subscriptions');
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }
      log('==========================================');
    } catch (e) {
      log('Subscription error: $e');
      if (mounted) {
        _showError('Errore: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Elimina Account',
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF27272A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Sei sicuro di voler eliminare il tuo account? Questa azione è irreversibile.',
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF52525B),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annulla',
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF71717A),
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await deleteAccountRxObj.deleteAccountRx().waitingForFuture();
              if (success && mounted) {
                appData.write(kKeyIsLoggedIn, false);
                DioSingleton.instance.update('');
                NavigationService.navigateToReplacement(Routes.signInScreen);
              }
            },
            child: Text(
              'Elimina',
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFFDC2626),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Cancella Dati',
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF27272A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Sei sicuro di voler cancellare tutti i dati locali? Questa azione cancellerà le tue preferenze salvate.',
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF52525B),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annulla',
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFF71717A),
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await appData.erase();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Dati cancellati con successo!'),
                    backgroundColor: const Color(0xFFF566A9),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Cancella',
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: const Color(0xFFDC2626),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getAvatarUrl() {
    return getUserAvatar();
  }

  Widget _buildAvatarImage() {
    final avatarUrl = _getAvatarUrl();

    return CustomCachedNetworkImage(
      imageUrl: avatarUrl,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                //
                Container(
                  width: 1.sw,
                  height: 140.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                    color: Color(0xFFF566A9),
                  ),
                ),

                // Profile text
                Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SafeArea(
                      child: Text(
                        "Profilo",
                        style: TextFontStyle.headline30c27272AtyleWorkSansW700
                            .copyWith(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -40,
                  child: Center(
                    child: ValueListenableBuilder<String>(
                      valueListenable: avatarNotifier,
                      builder: (_, avatarUrl, __) {
                        final url = avatarUrl.isEmpty ? getUserAvatar() : avatarUrl;
                        return Container(
                          width: 86.w,
                          height: 86.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(3.w),
                          child: ClipOval(
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              color: const Color(0xFFE5E5E5),
                              child: CustomCachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,

                  child: InkWell(
                    onTap: () async {
                      log(
                        "Tapped Me==================================================",
                      );
                      /*  await showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            topRight: Radius.circular(10.r),
                          ),
                        ),
                        context: context,
                        builder: (_) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1A2F20),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.r),
                                topRight: Radius.circular(10.r),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 20.h,
                            ),
            
                            child: Column(
                              spacing: 20.h,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    NavigationService.goBack;
                                  },
                                  child: Row(
                                    spacing: 10.w,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextFontStyle
                                            .headLine102cF8F3EFBarlowCondensedW700
                                            .copyWith(fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                ),
            
                                // Gallery
                                InkWell(
                                  onTap: () async {
                                    NavigationService.goBack;
                                  },
                                  child: Row(
                                    spacing: 10.w,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.photo_library,
                                        color: Colors.white,
                                        size: 20.sp,
                                      ),
                                      Text(
                                        "Gallery",
                                        style: TextFontStyle
                                            .headLine102cF8F3EFBarlowCondensedW700
                                            .copyWith(fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ); */
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      color: Colors.transparent,
                      child: SvgPicture.asset(
                        Assets.icons.upload,
                        width: 28.w,
                        height: 28.h,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            UIHelper.verticalSpace(40.h),

            Align(
              alignment: Alignment.center,
              child: Text(
                appData.read(kKeyName) ?? "Rabby",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 24.sp,

                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: UserInfoWidget(
                    icon: Assets.icons.cake,
                    subtitle: "anni",
                    title: "18",
                  ),
                ),
                SizedBox(
                  height: 80.h,
                  child: VerticalDivider(
                    color: Color(0xFFD4D4D8),
                    thickness: 1,
                  ),
                ),
                Expanded(
                  child: UserInfoWidget(
                    icon: Assets.icons.cake,
                    subtitle: "chilogrammi",
                    title: "65",
                  ),
                ),
                SizedBox(
                  height: 80.h,
                  child: VerticalDivider(
                    color: Color(0xFFD4D4D8),
                    thickness: 1,
                  ),
                ),
                Expanded(
                  child: UserInfoWidget(
                    icon: Assets.icons.cake,
                    subtitle: "Altezza",
                    title: "5'5 ",
                  ),
                ),
              ],
            ),

            /*      UIHelper.verticalSpace(30.h), */

            /* Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Streak",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    "See All",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFFF566A9),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            UIHelper.verticalSpace(10.h), */

            /*  Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.sp),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFAFAFA),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.w,
                      color: const Color(0xFFE4E4E7),
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Streak",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF27272A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),

                        Text(
                          "24 days",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF27272A),
                                fontSize: 24.sp,

                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),

                    UIHelper.verticalSpace(16.h),
                    Divider(color: Color(0xFFD4D4D8), thickness: 1),

                    UIHelper.verticalSpace(16.h),

                    Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Assets.icons.fire,
                          width: 30.w,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),

                        Column(
                          spacing: 8.h,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You're on fire!",
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                  .copyWith(
                                    color: const Color(0xFF27272A),
                                    fontSize: 16.sp,

                                    fontWeight: FontWeight.w700,
                                  ),
                            ),

                            Text(
                              "Keep using the app to get benefits!",
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                                  .copyWith(
                                    color: const Color(0xFF52525B),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            UIHelper.verticalSpace(32.h),
 */
            /*  Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Achivements",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF27272A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    "See All",
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFFF566A9),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpace(16.h),
            // Arcivements
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.sp),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFAFAFA),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.w,
                      color: const Color(0xFFE4E4E7),
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Achievements",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF27272A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),

                        Text(
                          "23",
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600
                              .copyWith(
                                color: const Color(0xFF27272A),
                                fontSize: 24.sp,

                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),

                    UIHelper.verticalSpace(16.h),
                    Divider(color: Color(0xFFD4D4D8), thickness: 1),

                    UIHelper.verticalSpace(16.h),

                    Row(
                      spacing: 10.w,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AchivementWidget(
                          icon: Assets.icons.frame2,
                          levelName: "Level 1",
                        ),
                        AchivementWidget(
                          icon: Assets.icons.frame1,
                          levelName: "Level 2",
                        ),

                        AchivementWidget(
                          icon: Assets.icons.frame,
                          levelName: "Level 3",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ), */
            UIHelper.verticalSpace(32.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Impostazioni Generali",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(16.h),
            SettingsTitleWidget(
              icon: Assets.icons.userSingle,
              title: "Impostazioni Profilo",
              onTap: () async {
                final result = await Navigator.pushNamed(context, Routes.profileSettingsScreen);
                if (result == true && mounted) {
                  setState(() {}); // Rebuild to show updated avatar/name
                }
              },
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.vector,
              title: "Abbonamento e Fatturazione",
              onTap: _handleSubscriptionBilling,
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.activityRunningJogging,
              title: "Obiettivi Benessere",
              onTap: () => NavigationService.navigateTo(Routes.wellnessGoalsScreen),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.ruler,
              title: "Unità e Metriche",
              onTap: () => NavigationService.navigateTo(Routes.unitsMetricsScreen),
            ),
            UIHelper.verticalSpace(32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Notifiche",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsToggleWidget(
              icon: Assets.icons.vector1,
              title: "Notifiche Generali",
              value: _generalNotifications,
              onChanged: (value) {
                setState(() => _generalNotifications = value);
                _saveNotificationSetting('generalNotifications', value);
              },
            ),
            UIHelper.verticalSpace(12.h),
            SettingsToggleWidget(
              icon: Assets.icons.envelopeEmail,
              title: "Notifiche Email",
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
                _saveNotificationSetting('emailNotifications', value);
              },
            ),
            UIHelper.verticalSpace(12.h),
            SettingsToggleWidget(
              icon: Assets.icons.soundOn,
              title: "Suoni Notifiche",
              value: _soundNotifications,
              onChanged: (value) {
                setState(() => _soundNotifications = value);
                _saveNotificationSetting('soundNotifications', value);
              },
            ),

            ///
            UIHelper.verticalSpace(32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Sicurezza e Privacy",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.lockLocked,
              title: "Cambia Password",
              onTap: () => NavigationService.navigateTo(Routes.changePasswordScreen),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.arrowRepeat,
              title: "Cancella e Ripristina Dati",
              onTap: () => _showClearDataDialog(context),
            ),
            UIHelper.verticalSpace(32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Aiuto e Supporto",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.questionMarkCircle,
              title: "Domande Frequenti",
              onTap: () => NavigationService.navigateTo(Routes.faqsScreen),
            ),

            UIHelper.verticalSpace(32.h),

            // Danger Zone
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "Zona Pericolosa",
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            SettingsTitleWidget(
              icon: Assets.icons.trash,
              title: "Elimina Account",
              onTap: () => _showDeleteAccountDialog(context),
            ),

            UIHelper.verticalSpace(20.h),

            // Logout button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: InkWell(
                onTap: () {
                  logoutRxObj.logoutRx().waitingForFuture().then((success) {
                    if (success) {
                      appData.write(kKeyIsLoggedIn, false);
                      DioSingleton.instance.update('');
                      NavigationService.navigateToReplacement(
                        Routes.signInScreen,
                      );
                    }
                  });
                },
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFEE2E2),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.w, color: const Color(0xFFFECACA)),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    spacing: 16.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 24.sp,
                        color: const Color(0xFFDC2626),
                      ),
                      Text(
                        "Esci",
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                          color: const Color(0xFFDC2626),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            UIHelper.verticalSpaceMediumLarge,
          ],
        ),
      ),
    );
  }
}
