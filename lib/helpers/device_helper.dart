import 'dart:developer';
import 'package:flutter/services.dart';

const _deviceChannel = MethodChannel('com.dolceresetltd.app/device');

/// Returns true if running on iPad. Returns false on failure.
Future<bool> isIPad() async {
  try {
    return await _deviceChannel.invokeMethod<bool>('isIPad') ?? false;
  } catch (e) {
    log('[DeviceHelper] iPad check failed: $e');
    return false;
  }
}
