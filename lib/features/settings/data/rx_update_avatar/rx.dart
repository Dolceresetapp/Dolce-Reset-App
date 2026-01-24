import 'dart:io';

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

      _updateAvatarFetcher.sink.add(response);

      // Return the new avatar URL from the response
      if ((response['status'] == true || response['success'] == true) && response['data'] != null) {
        return response['data']['avatar'] as String?;
      }
      return null;
    } catch (e) {
      _updateAvatarFetcher.sink.addError(e);
      rethrow;
    }
  }

  void dispose() {
    _updateAvatarFetcher.close();
  }
}
