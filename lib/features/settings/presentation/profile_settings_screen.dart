import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gritti_app/common_widget/custom_button.dart';
import 'package:gritti_app/common_widget/custom_text_field.dart';
import 'package:gritti_app/constants/text_font_style.dart';
import 'package:gritti_app/helpers/di.dart';
import 'package:gritti_app/helpers/ui_helpers.dart';
import 'package:gritti_app/networks/api_acess.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/app_constants.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _picker = ImagePicker();

  bool _isLoading = false;
  File? _selectedImage;
  String? _currentAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _nameController.text = appData.read(kKeyName) ?? '';
    _currentAvatarUrl = appData.read(kKeyAvatar);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
        requestFullMetadata: false,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
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
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E7),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Text(
                'Scegli foto profilo',
                style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                  color: const Color(0xFF27272A),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              UIHelper.verticalSpace(12.h),
              ListTile(
                dense: true,
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7F3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: const Color(0xFFF566A9),
                    size: 20.sp,
                  ),
                ),
                title: Text(
                  'Scatta una foto',
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                dense: true,
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCE7F3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: const Color(0xFFF566A9),
                    size: 20.sp,
                  ),
                ),
                title: Text(
                  'Scegli dalla galleria',
                  style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                    color: const Color(0xFF27272A),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              UIHelper.verticalSpace(8.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveAll() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Upload avatar first if selected
      if (_selectedImage != null) {
        final newAvatarUrl = await updateAvatarRxObj.updateAvatarRx(
          avatarFile: _selectedImage!,
        );
        if (newAvatarUrl != null) {
          appData.write(kKeyAvatar, newAvatarUrl);
        }
      }

      // Then update profile
      final success = await updateProfileRxObj.updateProfileRx(
        name: _nameController.text.trim(),
        age: _ageController.text.isNotEmpty
            ? int.tryParse(_ageController.text)
            : null,
        currentWeight: _weightController.text.isNotEmpty
            ? double.tryParse(_weightController.text)
            : null,
        height: _heightController.text.isNotEmpty
            ? double.tryParse(_heightController.text)
            : null,
        targetWeight: _targetWeightController.text.isNotEmpty
            ? double.tryParse(_targetWeightController.text)
            : null,
      );

      if (mounted) {
        if (success) {
          appData.write(kKeyName, _nameController.text.trim());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profilo aggiornato con successo!'),
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
          'Impostazioni Profilo',
          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
            color: const Color(0xFF27272A),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpace(4.h),

                      // Avatar section
                      Center(
                        child: GestureDetector(
                          onTap: _showImagePickerOptions,
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF566A9),
                                ),
                                child: CircleAvatar(
                                  radius: 45.r,
                                  backgroundColor: const Color(0xFFE5E5E5),
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty
                                          ? NetworkImage(_currentAvatarUrl!) as ImageProvider
                                          : null),
                                  child: (_selectedImage == null && (_currentAvatarUrl == null || _currentAvatarUrl!.isEmpty))
                                      ? Icon(
                                          Icons.person,
                                          size: 45.sp,
                                          color: const Color(0xFF9CA3AF),
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF566A9),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2.w),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      UIHelper.verticalSpace(6.h),

                      Center(
                        child: Text(
                          'Tocca per cambiare foto',
                          style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
                            color: const Color(0xFF9CA3AF),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      UIHelper.verticalSpace(40.h),

                      _buildSectionTitle('Informazioni Personali'),
                      UIHelper.verticalSpace(10.h),

                      _buildLabel('Nome'),
                      UIHelper.verticalSpace(6.h),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Inserisci il tuo nome',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Il nome è obbligatorio';
                          }
                          return null;
                        },
                      ),

                      UIHelper.verticalSpace(12.h),

                      _buildLabel('Età'),
                      UIHelper.verticalSpace(6.h),
                      CustomTextField(
                        controller: _ageController,
                        hintText: 'Es: 25',
                        keyboardType: TextInputType.number,
                      ),

                      UIHelper.verticalSpace(20.h),
                      _buildSectionTitle('Misure Corporee'),
                      UIHelper.verticalSpace(10.h),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Peso Attuale (kg)'),
                                UIHelper.verticalSpace(6.h),
                                CustomTextField(
                                  controller: _weightController,
                                  hintText: 'Es: 70',
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Altezza (cm)'),
                                UIHelper.verticalSpace(6.h),
                                CustomTextField(
                                  controller: _heightController,
                                  hintText: 'Es: 175',
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      UIHelper.verticalSpace(12.h),

                      _buildLabel('Peso Obiettivo (kg)'),
                      UIHelper.verticalSpace(6.h),
                      CustomTextField(
                        controller: _targetWeightController,
                        hintText: 'Es: 65',
                        keyboardType: TextInputType.number,
                      ),

                      UIHelper.verticalSpace(20.h),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed bottom button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: CustomButton(
                onPressed: _isLoading ? () {} : _saveAll,
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
                        'Salva Modifiche',
                        style: TextFontStyle.headLine16cFFFFFFWorkSansW600,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (_selectedImage != null) {
      return SizedBox.expand(
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        ),
      );
    } else if (_currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty) {
      return SizedBox.expand(
        child: Image.network(
          _currentAvatarUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: const Color(0xFFF566A9),
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: 45.sp,
              color: const Color(0xFF9CA3AF),
            );
          },
        ),
      );
    } else {
      return Icon(
        Icons.person,
        size: 45.sp,
        color: const Color(0xFF9CA3AF),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
        color: const Color(0xFF27272A),
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextFontStyle.headLine16cFFFFFFWorkSansW600.copyWith(
        color: const Color(0xFF52525B),
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
