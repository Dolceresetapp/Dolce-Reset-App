import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/app_constants.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/api_acess.dart';

class WellnessGoalsScreen extends StatefulWidget {
  const WellnessGoalsScreen({super.key});

  @override
  State<WellnessGoalsScreen> createState() => _WellnessGoalsScreenState();
}

class _WellnessGoalsScreenState extends State<WellnessGoalsScreen> {
  bool _isLoading = false;
  bool _isSaving = false;

  String? _bodyPartFocus;
  String? _dreamBody;
  String? _urgentImprovement;
  String? _tryingDuration;
  double? _targetWeight;

  final List<String> _bodyPartOptions = [
    'Abdomen and face',
    'Legs',
    'Back / Posture',
    'Whole body',
  ];

  final List<String> _dreamBodyOptions = [
    'Healthy and fit',
    'Curvy and confident',
    'Strong and healthy',
  ];

  final List<String> _urgentImprovementOptions = [
    'Lose Weight',
    'Get back into shape',
    'Improve sleep/energy',
    'Reduce pain/stiffness',
  ];

  final List<String> _tryingDurationOptions = [
    'I have Never tried',
    'A few months ago',
    'A few years ago',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentGoals();
  }

  Future<void> _loadCurrentGoals() async {
    setState(() => _isLoading = true);

    try {
      final data = await wellnessGoalsRxObj.getWellnessGoalsRx();
      log('WellnessGoals API Response: $data');

      if (data != null && mounted) {
        setState(() {
          final userInfo = data['user_info'];
          log('WellnessGoals user_info: $userInfo');

          if (userInfo != null) {
            // Handle target_weight which might be string or number
            final tw = userInfo['target_weight'];
            if (tw != null) {
              _targetWeight = tw is String ? double.tryParse(tw) : tw?.toDouble();
            }

            _bodyPartFocus = userInfo['body_part_focus'];
            _dreamBody = userInfo['dream_body'];
            _urgentImprovement = userInfo['urgent_improvement'];
            _tryingDuration = userInfo['trying_duration'];

            log('Loaded values - bodyPartFocus: $_bodyPartFocus, dreamBody: $_dreamBody, urgentImprovement: $_urgentImprovement, tryingDuration: $_tryingDuration, targetWeight: $_targetWeight');
          }
        });
      }
    } catch (e) {
      log('WellnessGoals error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveGoals() async {
    setState(() => _isSaving = true);

    try {
      final success = await wellnessGoalsRxObj.updateWellnessGoalsRx(
        bodyPartFocus: _bodyPartFocus,
        dreamBody: _dreamBody,
        urgentImprovement: _urgentImprovement,
        tryingDuration: _tryingDuration,
        targetWeight: _targetWeight,
      );

      if (mounted) {
        if (success) {
          // Save to local storage
          appData.write(kKeyBodyPartFocus, _bodyPartFocus);
          appData.write(kKeyDreamBody, _dreamBody);
          appData.write(kKeyUrgentImprovement, _urgentImprovement);
          appData.write(kKeyTryingDuration, _tryingDuration);
          if (_targetWeight != null) {
            appData.write(kKeyonboard9HeightValue, _targetWeight.toString());
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Obiettivi aggiornati con successo!'),
              backgroundColor: const Color(0xFFF566A9),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Errore durante l\'aggiornamento'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
          'Wellness Goals',
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF27272A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFF566A9)),
            )
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.verticalSpace(16.h),

                          _buildSectionTitle('Zona del corpo da migliorare'),
                          UIHelper.verticalSpace(12.h),
                          _buildChipSelector(
                            options: _bodyPartOptions,
                            selectedValue: _bodyPartFocus,
                            onSelected: (value) => setState(() => _bodyPartFocus = value),
                          ),

                          UIHelper.verticalSpace(24.h),

                          _buildSectionTitle('Il tuo corpo ideale'),
                          UIHelper.verticalSpace(12.h),
                          _buildChipSelector(
                            options: _dreamBodyOptions,
                            selectedValue: _dreamBody,
                            onSelected: (value) => setState(() => _dreamBody = value),
                          ),

                          UIHelper.verticalSpace(24.h),

                          _buildSectionTitle('Obiettivo principale'),
                          UIHelper.verticalSpace(12.h),
                          _buildChipSelector(
                            options: _urgentImprovementOptions,
                            selectedValue: _urgentImprovement,
                            onSelected: (value) => setState(() => _urgentImprovement = value),
                          ),

                          UIHelper.verticalSpace(24.h),

                          _buildSectionTitle('Da quanto tempo ci provi?'),
                          UIHelper.verticalSpace(12.h),
                          _buildChipSelector(
                            options: _tryingDurationOptions,
                            selectedValue: _tryingDuration,
                            onSelected: (value) => setState(() => _tryingDuration = value),
                          ),

                          UIHelper.verticalSpace(24.h),

                          _buildSectionTitle('Peso obiettivo (kg)'),
                          UIHelper.verticalSpace(12.h),
                          _buildWeightSlider(),

                          UIHelper.verticalSpace(24.h),
                        ],
                      ),
                    ),
                  ),

                  // Fixed bottom button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                    child: CustomButton(
                      onPressed: _isSaving ? () {} : _saveGoals,
                      child: _isSaving
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Salva Obiettivi',
                              style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
        color: const Color(0xFF27272A),
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildChipSelector({
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = option == selectedValue;
        return GestureDetector(
          onTap: () => onSelected(option),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF566A9) : const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected ? const Color(0xFFF566A9) : const Color(0xFFE4E4E7),
              ),
            ),
            child: Text(
              option,
              style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                color: isSelected ? Colors.white : const Color(0xFF52525B),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWeightSlider() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          child: Column(
            children: [
              Text(
                '${(_targetWeight ?? 65).toStringAsFixed(0)} kg',
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFFF566A9),
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelper.verticalSpace(8.h),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFF566A9),
                  inactiveTrackColor: const Color(0xFFE4E4E7),
                  thumbColor: const Color(0xFFF566A9),
                  overlayColor: const Color(0xFFF566A9).withOpacity(0.2),
                  trackHeight: 6.h,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.r),
                ),
                child: Slider(
                  value: _targetWeight ?? 65,
                  min: 40,
                  max: 150,
                  onChanged: (value) {
                    setState(() => _targetWeight = value);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '40 kg',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '150 kg',
                    style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                      color: const Color(0xFF9CA3AF),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
