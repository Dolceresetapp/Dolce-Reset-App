import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/meal_result_response_model.dart';
import 'api.dart';

final class MealResultRx extends RxResponseInt<MealResponseModel> {
  final api = MealResultApi.instance;

  MealResultRx({required super.empty, required super.dataFetcher});

  ValueStream<MealResponseModel> get mealResultRxStream => dataFetcher.stream;

  Future<bool> mealResultRx({
    required String name,
    required String brands,
    required String energyKcal,
    required String fat,
    required String saturatedFat,
    required String carbohydrates,
    required String sugars,
    required String fiber,
    required String proteins,
    required String salt,
    required String image,
  }) async {
    try {
      MealResponseModel data = await api.mealResultApi(
        name: name,
        brands: brands,
        energyKcal: energyKcal,
        fat: fat,
        saturatedFat: saturatedFat,
        carbohydrates: carbohydrates,
        sugars: sugars,
        fiber: fiber,
        proteins: proteins,
        salt: salt,
        image: image,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(MealResponseModel data) {
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
