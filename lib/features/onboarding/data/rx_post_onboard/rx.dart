import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import '../model/onboarding_response_model.dart';
import 'api.dart';

final class OnboardingRx extends RxResponseInt<OnboardingResponseModel> {
  final api = OnboardingApi.instance;

  OnboardingRx({required super.empty, required super.dataFetcher});

  ValueStream<OnboardingResponseModel> get onboardingRxStream =>
      dataFetcher.stream;

  Future<bool> onboardingRx({
    required String userId,
    required String age,
    required String bmi,
    required String bodyPartFocus,
    required String bodySatisfaction,
    required String celebrationPlan,
    required String currentBodyType,
    required String currentWeight,
    required String dreamBody,
    required String height,
    required String targetWeight,
    required String tryingDuration,
    required String urgentImprovement,
    required Uint8List signature,
    required String targetWeightIn,
    required String weightIn,
    required String heightIn,
  }) async {
    try {
      OnboardingResponseModel data = await api.onboardingApi(
        age: age,
        bmi: bmi,
        bodyPartFocus: bodyPartFocus,
        bodySatisfaction: bodySatisfaction,
        celebrationPlan: celebrationPlan,
        currentBodyType: currentBodyType,
        currentWeight: currentWeight,
        dreamBody: dreamBody,
        height: height,
        signature: signature,
        targetWeight: targetWeight,
        tryingDuration: tryingDuration,
        urgentImprovement: urgentImprovement,
        userId: userId,
        heightIn: heightIn,
        targetWeightIn: targetWeightIn,
        weightIn: weightIn,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(OnboardingResponseModel data) {
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
