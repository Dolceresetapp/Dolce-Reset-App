import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/all_routes.dart';
import '../../../../../../helpers/navigation_service.dart';
import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../../networks/stream_cleaner.dart';
import '../model/chef_response_model.dart';
import 'api.dart';

final class ChefRx extends RxResponseInt<ChefResponseModel> {
  final api = ChefApi.instance;

  ChefRx({required super.empty, required super.dataFetcher});

  ValueStream<ChefResponseModel> get chefRxStream => dataFetcher.stream;

  Future<bool> chefRx({
    required String goalsFor,
    required String dietaryPreferences,
    required String intolerancesa,
    required String activityLevel,
    required String dontLike,
  }) async {
    try {
      ChefResponseModel data = await api.chefApi(
        goalsFor: goalsFor,
        dietaryPreferences: dietaryPreferences,
        intolerancesa: intolerancesa,
        activityLevel: activityLevel,
        dontLike: dontLike,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ChefResponseModel data) {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      if (error.response!.statusCode == 400) {
        ToastUtil.showShortToast(error.response!.data["message"]);
      } else {
        if (error.response!.statusCode == 401) {
          ToastUtil.showShortToast(error.response!.data["message"]);
          totalDataClean();
          NavigationService.navigateToReplacement(Routes.signInScreen);
        } else {
          ToastUtil.showShortToast(error.response!.data["message"]);
        }
      }
      log(error.toString());
      dataFetcher.sink.addError(error);
      return false;
    }
  }
}
