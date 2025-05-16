import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expense_management_system/shared/http/interceptor/dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({
    required this.requestRetrier,
  });

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (_shouldRetry(err)) {
      try {
        requestRetrier.scheduleRequestRetry(err.requestOptions).then(
              (value) => handler.resolve(value),
              onError: (error) => handler.next(err),
            );
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioError err) {
    return (err.type == DioErrorType.connectionTimeout ||
            err.type == DioErrorType.receiveTimeout ||
            err.type == DioErrorType.sendTimeout ||
            err.error is SocketException) &&
        err.type != DioErrorType.badResponse;
  }
}
