import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/ai_generate_response_model.dart';
import 'api.dart';

final class AiGenerateRx extends RxResponseInt<AiGenerateResponseModel> {
  final api = AiGenerateApi.instance;

  AiGenerateRx({required super.empty, required super.dataFetcher});

  ValueStream<AiGenerateResponseModel> get aiGenerateRxStream =>
      dataFetcher.stream;

  Future<bool> aiGenerateRx({required String prompt}) async {
    try {
      AiGenerateResponseModel data = await api.aiGenerateApi(prompt: prompt);
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(AiGenerateResponseModel data) {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(dynamic error) {
    if (error is DioException) {
      // Handle timeout errors
      if (error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        ToastUtil.showShortToast("La richiesta ha impiegato troppo tempo. Riprova.");
        log(error.toString());
        dataFetcher.sink.addError(error);
        return false;
      }

      // Handle response errors (only if response is not null)
      if (error.response != null) {
        if (error.response!.statusCode == 400) {
          ToastUtil.showShortToast(error.response!.data["message"] ?? "Errore");
        } else if (error.response!.statusCode == 401) {
          ToastUtil.showShortToast(error.response!.data["message"] ?? "Non autorizzato");
          totalDataClean();
          NavigationService.navigateToReplacement(Routes.signInScreen);
        } else {
          ToastUtil.showShortToast(error.response!.data?["message"] ?? "Errore del server");
        }
      } else {
        ToastUtil.showShortToast("Errore di connessione");
      }
      log(error.toString());
      dataFetcher.sink.addError(error);
      return false;
    }
    return false;
  }
}
