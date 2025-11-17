import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:gritti_app/features/excerises/data/rx_post_theme/model/category_wise_theme_response_model.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../../helpers/toast.dart';
import '../../../../../../networks/rx_base.dart';
import '../../../../../helpers/all_routes.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../../networks/stream_cleaner.dart';
import 'api.dart';

final class CategoryWiseThemeRx
    extends RxResponseInt<CategoryWiseThemeResponseModel> {
  final api = CategoryWiseThemeApi.instance;

  CategoryWiseThemeRx({required super.empty, required super.dataFetcher});

  ValueStream<CategoryWiseThemeResponseModel> get categoryWiseThemeRxStream =>
      dataFetcher.stream;

  Future<bool> categoryWiseThemeRx({int? categoryId, String? type}) async {
    try {
      CategoryWiseThemeResponseModel data = await api.categoryWiseThemeApi(
        categoryId: categoryId,
        type: type,
      );
      handleSuccessWithReturn(data);
      return true;
    } catch (error) {
      return handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(CategoryWiseThemeResponseModel data) {
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
