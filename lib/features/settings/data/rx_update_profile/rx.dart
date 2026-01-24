import 'dart:developer';

import 'package:gritti_app/features/settings/data/rx_update_profile/api.dart';
import 'package:rxdart/rxdart.dart';

class UpdateProfileRx {
  final api = UpdateProfileApi();
  final _fetcher = BehaviorSubject<bool>();

  Stream<bool> get stream => _fetcher.stream;

  Future<bool> updateProfileRx({
    required String name,
    int? age,
    double? currentWeight,
    double? height,
    double? targetWeight,
  }) async {
    try {
      log('UpdateProfileRx - Starting update with name: $name');

      final response = await api.updateProfile(
        name: name,
        age: age,
        currentWeight: currentWeight,
        height: height,
        targetWeight: targetWeight,
      );

      log('UpdateProfileRx - Response received: $response');

      if (response['status'] == true || response['success'] == true) {
        _fetcher.sink.add(true);
        return true;
      } else {
        final errorMsg = response['message'] ?? 'Update failed';
        log('UpdateProfileRx - Error: $errorMsg');
        _fetcher.sink.addError(errorMsg);
        return false;
      }
    } catch (e, stackTrace) {
      log('UpdateProfileRx - Exception: $e');
      log('UpdateProfileRx - StackTrace: $stackTrace');
      _fetcher.sink.addError(e.toString());
      rethrow;
    }
  }

  void dispose() {
    _fetcher.close();
  }
}
