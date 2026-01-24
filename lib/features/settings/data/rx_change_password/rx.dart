import 'package:gritti_app/features/settings/data/rx_change_password/api.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordRx {
  final api = ChangePasswordApi();
  final _fetcher = BehaviorSubject<bool>();

  Stream<bool> get stream => _fetcher.stream;

  Future<bool> changePasswordRx({
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await api.changePassword(
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (response['status'] == true || response['success'] == true) {
        _fetcher.sink.add(true);
        return true;
      } else {
        _fetcher.sink.addError(response['message'] ?? 'Update failed');
        return false;
      }
    } catch (e) {
      _fetcher.sink.addError(e.toString());
      return false;
    }
  }

  void dispose() {
    _fetcher.close();
  }
}
