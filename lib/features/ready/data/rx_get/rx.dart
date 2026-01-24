import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/workout_video_response_model.dart';
import 'api.dart';

final class WorkoutVideoRx
    extends RxResponseInt<WorkoutWiseVideoResponseModel> {
  final api = WorkoutVideoApi.instance;

  WorkoutVideoRx({required super.empty, required super.dataFetcher});

  ValueStream<WorkoutWiseVideoResponseModel> get workoutVideoRxStream =>
      dataFetcher.stream;

  Future<WorkoutWiseVideoResponseModel> workoutVideoRx({
    required int id,
  }) async {
    try {
      WorkoutWiseVideoResponseModel data = await api.workoutVideoApi(id: id);
      handleSuccessWithReturn(data);
      return data;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(WorkoutWiseVideoResponseModel data) {
    dataFetcher.sink.add(data);
    return data;
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      final message = error.response?.data?["message"]?.toString() ?? "Errore di connessione";
      final statusCode = error.response?.statusCode;

      if (statusCode == 401) {
        ToastUtil.showShortToast(message);
        totalDataClean();
        NavigationService.navigateToReplacement(Routes.signInScreen);
      } else {
        ToastUtil.showShortToast(message);
      }
      log(error.toString());
      dataFetcher.sink.addError(error);
    } else {
      log('Non-Dio error: $error');
    }
    // Return empty model on error
    return empty;
  }
}
