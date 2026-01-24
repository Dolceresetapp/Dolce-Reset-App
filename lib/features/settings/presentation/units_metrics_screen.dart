import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/api_acess.dart';
import 'package:gritti_app/helpers/loading_helper.dart';

class UnitsMetricsScreen extends StatefulWidget {
  const UnitsMetricsScreen({super.key});

  @override
  State<UnitsMetricsScreen> createState() => _UnitsMetricsScreenState();
}

class _UnitsMetricsScreenState extends State<UnitsMetricsScreen> {
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUnits();
  }

  Future<void> _loadCurrentUnits() async {
    // Load from API if available
  }

  Future<void> _saveUnits() async {
    setState(() => _isLoading = true);

    try {
      final success = await unitsMetricsRxObj
          .updateUnitsRx(
            weightUnit: _weightUnit,
            heightUnit: _heightUnit,
          )
          .waitingForFuture();

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unità aggiornate con successo!'),
            backgroundColor: const Color(0xFFF566A9),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context);
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
      if (mounted) setState(() => _isLoading = false);
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
          'Unità e Metriche',
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

              _buildSectionTitle('Unità di Peso'),
              UIHelper.verticalSpace(16.h),
              _buildUnitSelector(
                options: ['kg', 'lbs'],
                selectedValue: _weightUnit,
                onChanged: (value) => setState(() => _weightUnit = value),
              ),

              UIHelper.verticalSpace(32.h),

              _buildSectionTitle('Unità di Altezza'),
              UIHelper.verticalSpace(16.h),
              _buildUnitSelector(
                options: ['cm', 'ft'],
                selectedValue: _heightUnit,
                onChanged: (value) => setState(() => _heightUnit = value),
              ),

              const Spacer(),

              CustomButton(
                onPressed: _isLoading ? () {} : _saveUnits,
                child: _isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Salva',
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                      ),
              ),

              UIHelper.verticalSpace(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
        color: const Color(0xFF27272A),
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildUnitSelector({
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
  }) {
    return Row(
      children: options.map((option) {
        final isSelected = option == selectedValue;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              margin: EdgeInsets.only(
                right: option != options.last ? 12.w : 0,
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFF566A9)
                    : const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFF566A9)
                      : const Color(0xFFE4E4E7),
                ),
              ),
              child: Center(
                child: Text(
                  option.toUpperCase(),
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF27272A),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
