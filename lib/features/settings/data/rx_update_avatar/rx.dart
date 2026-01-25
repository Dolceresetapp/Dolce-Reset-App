import 'dart:io';
import 'dart:developer' as dev;

import 'package:rxdart/rxdart.dart';

import 'api.dart';

class UpdateAvatarRx {
  final _updateAvatarFetcher = PublishSubject<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get updateAvatarStream =>
      _updateAvatarFetcher.stream;

  Future<String?> updateAvatarRx({required File avatarFile}) async {
    try {
      final response = await UpdateAvatarApi.instance.updateAvatarApi(
        avatarFile: avatarFile,
      );

      dev.log('UpdateAvatar response: $response');

      _updateAvatarFetcher.sink.add(response);

      // Return the new avatar URL from the response
      if ((response['status'] == true || response['success'] == true) && response['data'] != null) {
        final avatar = response['data']['avatar'];
        dev.log('Avatar URL from response: $avatar');
        return avatar as String?;
      }
      dev.log('Avatar update failed - status: ${response['status']}, data: ${response['data']}');
      return null;
    } catch (e) {
      dev.log('UpdateAvatar error: $e');
      _updateAvatarFetcher.sink.addError(e);
      rethrow;
    }
  }

  void dispose() {
    _updateAvatarFetcher.close();
  }
}
