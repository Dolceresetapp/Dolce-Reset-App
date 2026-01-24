import 'package:gritti_app/features/settings/data/rx_wellness_goals/api.dart';
import 'package:rxdart/rxdart.dart';

class WellnessGoalsRx {
  final api = WellnessGoalsApi();
  final _fetcher = BehaviorSubject<bool>();

  Stream<bool> get stream => _fetcher.stream;

  Future<Map<String, dynamic>?> getWellnessGoalsRx() async {
    try {
      final response = await api.getWellnessGoals();

      if (response['status'] == true || response['success'] == true) {
        return response['data'];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateWellnessGoalsRx({
    String? bodyPartFocus,
    String? dreamBody,
    String? urgentImprovement,
    String? tryingDuration,
    double? targetWeight,
  }) async {
    try {
      final response = await api.updateWellnessGoals(
        bodyPartFocus: bodyPartFocus,
        dreamBody: dreamBody,
        urgentImprovement: urgentImprovement,
        tryingDuration: tryingDuration,
        targetWeight: targetWeight,
      );

      if (response['status'] == 'success' || response['status'] == true) {
        _fetcher.sink.add(true);
        return true;
      } else {
        _fetcher.sink.addError(response['message'] ?? 'Update failed');
        return false;
      }
    } catch (e) {
      _fetcher.sink.addError(e.toString());
      rethrow;
    }
  }

  void dispose() {
    _fetcher.close();
  }
}
