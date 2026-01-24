import 'package:gritti_app/features/settings/data/rx_delete_account/api.dart';
import 'package:rxdart/rxdart.dart';

class DeleteAccountRx {
  final api = DeleteAccountApi();
  final _fetcher = BehaviorSubject<bool>();

  Stream<bool> get stream => _fetcher.stream;

  Future<bool> deleteAccountRx() async {
    try {
      final response = await api.deleteAccount();

      if (response['status'] == true || response['success'] == true) {
        _fetcher.sink.add(true);
        return true;
      } else {
        _fetcher.sink.addError(response['message'] ?? 'Delete failed');
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
