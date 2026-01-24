import 'package:gritti_app/features/settings/data/rx_units_metrics/api.dart';
import 'package:rxdart/rxdart.dart';

class UnitsMetricsRx {
  final api = UnitsMetricsApi();
  final _fetcher = BehaviorSubject<bool>();

  Stream<bool> get stream => _fetcher.stream;

  Future<bool> updateUnitsRx({
    required String weightUnit,
    required String heightUnit,
  }) async {
    try {
      final response = await api.updateUnits(
        weightUnit: weightUnit,
        heightUnit: heightUnit,
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
