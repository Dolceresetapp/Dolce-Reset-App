import 'package:cached_network_image/cached_network_image.dart';
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

      // Precache images for smoother carousel experience
      _precacheImages();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Precache all recipe images in the background
  void _precacheImages() {
    if (_aiReceipeList == null) return;

    for (final recipe in _aiReceipeList!) {
      final imageUrl = recipe.imageUrl;
      if (imageUrl != null && imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
        // Use CachedNetworkImageProvider to download and cache images
        CachedNetworkImageProvider(imageUrl).resolve(const ImageConfiguration());
      }
    }
  }
}
