import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gritti_app/helpers/toast.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class MotivationProvider extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();

  File? file;

  final box = GetStorage();

  Future<void> pickedImage({required ImageSource source}) async {
    // Pick an image.
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      // Convert XFile to File
      File tempFile = File(image.path);

      // Get App Directory

      final appDir = await getApplicationDocumentsDirectory();

      // Create new file path inside app folder
      final fileName = basename(image.path);
      final savedImage = await tempFile.copy('${appDir.path}/$fileName');

      // . Save reference
      file = savedImage;

      // save path in local stroage
      box.write("motivation_image", savedImage.path);
    } else {
      ToastUtil.showShortToast("You haven't selected any image");
    }

    notifyListeners();
  }

  // Load when app start
  void loadSavedImage() {
    final savedPath = box.read("motivation_image");

    if (savedPath != null) {
      file = File(savedPath);
      notifyListeners();
    }
  }
}
