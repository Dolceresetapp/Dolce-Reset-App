import 'package:flutter/material.dart';
import 'package:gritti_app/networks/api_acess.dart';

import '../features/chef/data/model/ai_receipe_response_model.dart';

class ChefProvider extends ChangeNotifier {
  List<AiReceipeResponseData>? _aiReceipeList;
  bool _isLoading = true;
  String? _error;

  // Getter

  List<AiReceipeResponseData>? get aiReceipeList => _aiReceipeList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchData() async {
    _isLoading = true;

    _error = null;

    try {
      final result = await aiReceipeRxObj.aiReceipeRx();
      _aiReceipeList = result.data;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
