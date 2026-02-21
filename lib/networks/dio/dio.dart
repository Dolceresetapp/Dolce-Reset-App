import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '/helpers/di.dart';
import '../../constants/app_constants.dart';
import '../endpoints.dart';
import 'log.dart';
import 'cache_interceptor.dart';

final class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  static CancelToken cancelToken = CancelToken();
  DioSingleton._internal();

  static DioSingleton get instance => _singleton;

  late Dio dio;

  void create() {
    dio = Dio(BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.ACCEPT_LANGUAGE: appData.read(kKeyCountryCode) ?? "pt",
        NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
      },
    ));
    dio.interceptors.add(CacheInterceptor());
    dio.interceptors.add(Logger());
  }

  void update(String auth) {
    if (kDebugMode) print("Dio update");
    // Update headers on existing instance — preserves connection pool & interceptors
    dio.options.headers[NetworkConstants.ACCEPT_LANGUAGE] =
        appData.read(kKeyLanguage) ?? "pt";
    if (auth.isNotEmpty) {
      dio.options.headers[NetworkConstants.AUTHORIZATION] = "Bearer $auth";
    } else {
      dio.options.headers.remove(NetworkConstants.AUTHORIZATION);
    }
  }

  void updateLanguage(String countryCode) {
    if (kDebugMode) print("Dio update $countryCode");
    dio.options.headers[NetworkConstants.ACCEPT_LANGUAGE] = countryCode;
  }
}

Future<Response> postHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.post(path, data: data, cancelToken: DioSingleton.cancelToken);

/// POST with extended timeout for AI/long-running requests
Future<Response> postHttpLongRunning(String path, [dynamic data]) =>
    DioSingleton.instance.dio.post(
      path,
      data: data,
      cancelToken: DioSingleton.cancelToken,
      options: Options(
        receiveTimeout: const Duration(seconds: 120),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

Future<Response> putHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.put(path, data: data, cancelToken: DioSingleton.cancelToken);

Future<Response> getHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.get(path, cancelToken: DioSingleton.cancelToken);

Future<Response> deleteHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.delete(path, data: data, cancelToken: DioSingleton.cancelToken);
