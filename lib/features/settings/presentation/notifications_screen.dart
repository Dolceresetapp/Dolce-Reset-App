import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _storage = GetStorage();

  bool _generalNotifications = true;
  bool _emailNotifications = true;
  bool _soundNotifications = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _generalNotifications = _storage.read('general_notifications') ?? true;
      _emailNotifications = _storage.read('email_notifications') ?? true;
      _soundNotifications = _storage.read('sound_notifications') ?? true;
    });
  }

  void _saveSettings() {
    _storage.write('general_notifications', _generalNotifications);
    _storage.write('email_notifications', _emailNotifications);
    _storage.write('sound_notifications', _soundNotifications);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Impostazioni salvate!'),
        backgroundColor: const Color(0xFFF566A9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF27272A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifiche',
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF27272A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.verticalSpace(20.h),

              _buildNotificationTile(
                title: 'Notifiche Generali',
                subtitle: 'Ricevi promemoria per i tuoi allenamenti',
                icon: Icons.notifications_outlined,
                value: _generalNotifications,
                onChanged: (value) {
                  setState(() => _generalNotifications = value);
                  _saveSettings();
                },
              ),

              UIHelper.verticalSpace(16.h),

              _buildNotificationTile(
                title: 'Notifiche Email',
                subtitle: 'Ricevi aggiornamenti via email',
                icon: Icons.email_outlined,
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() => _emailNotifications = value);
                  _saveSettings();
                },
              ),

              UIHelper.verticalSpace(16.h),

              _buildNotificationTile(
                title: 'Suoni',
                subtitle: 'Abilita i suoni delle notifiche',
                icon: Icons.volume_up_outlined,
                value: _soundNotifications,
                onChanged: (value) {
                  setState(() => _soundNotifications = value);
                  _saveSettings();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFF566A9),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF71717A),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFF566A9),
          ),
        ],
      ),
    );
  }
}
