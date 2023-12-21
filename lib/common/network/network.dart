import 'dart:async';

import 'package:baco/base/base.dart';
import 'package:dio/dio.dart';

import '../myLog.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// -------- dio ----------------- pour upload file

var dio = Dio();

class DioUtil {
  /// make the singleton
  static final DioUtil _singleton = DioUtil._internal();
  factory DioUtil() {
    return _singleton;
  }

  DioUtil._internal();
  static String host = "http://127.0.0.1:5000/";

  static init() {
    dio
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: false,
      ))
      // ..interceptors.add(HttpFormatter())
      ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
        // Do something before request is sent
        return handler.next(options); //continue
      }, onResponse: (response, handler) {
        // Do something with response data
        // print("response:${response.data}");
        AppLog.d("response:${response.data}");
        return handler.next(response);
      }, onError: (DioException e, handler) {
        // Do something with response error
        // IMViews.showError(transText.networkError);
        return handler.next(e); //continue
      }));

    // dio config
    dio.options.baseUrl = host;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "*",
      "Access-Control-Allow-Methods": "*",
      // "apiToken": apiToken,
    };
  }

  Dio? dioWebSocket;

  static Future globalRequest({
    required String path,
    required Map<String, dynamic> body,
    bool isGet = false,
    required FunctionVoidCallback errorCallback,
    required FunctionVoidCallback networkErrorCallback,
  }) async {
    Map<String, dynamic> httpBody = Map<String, dynamic>.from(body);

    Response response;
    try {
      if (isGet) {
        response = await dio.get(
          path,
          queryParameters: httpBody,
        );
      } else {
        response = await dio.post(path, data: httpBody);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.sendTimeout) {
        networkErrorCallback(e);
      } else {
        errorCallback(e);
      }
      return {};
    }
    var result = response.data;
    return result;
  }
}
