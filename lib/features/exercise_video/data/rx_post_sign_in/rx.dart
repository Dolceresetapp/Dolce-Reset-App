import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/workour_save_response_model.dart';
import 'api.dart';

final class ActiveWorkoutSaveRx
    extends RxResponseInt<ActiveWorkoutResponseModel> {
  final api = ActiveWorkoutSaveAPi.instance;

  ActiveWorkoutSaveRx({required super.empty, required super.dataFetcher});

  ValueStream<ActiveWorkoutResponseModel> get activeWorkoutSaveRxStream =>
      dataFetcher.stream;

  Future<bool> activeWorkoutSaveRx({required int listId}) async {
    try {
      ActiveWorkoutResponseModel data = await api.activeWorkoutSaveAPi(
        listId: listId,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(ActiveWorkoutResponseModel data) {
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
