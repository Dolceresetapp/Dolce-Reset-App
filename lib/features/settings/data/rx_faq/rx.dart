import 'package:gritti_app/features/settings/data/model/faq_response_model.dart';
import 'package:gritti_app/features/settings/data/rx_faq/api.dart';
import 'package:rxdart/rxdart.dart';

class FaqRx {
  final api = FaqApi();
  final _fetcher = BehaviorSubject<FaqResponseModel>();

  Stream<FaqResponseModel> get stream => _fetcher.stream;

  Future<void> getFaqsRx() async {
    try {
      final response = await api.getFaqs();
      final model = FaqResponseModel.fromJson(response);
      _fetcher.sink.add(model);
    } catch (e) {
      _fetcher.sink.addError(e.toString());
    }
  }

  void dispose() {
    _fetcher.close();
  }
}
