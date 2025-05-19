import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:expense_management_system/app/provider/connectivity_provider.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:expense_management_system/shared/http/interceptor/auth_interceptor.dart';
import 'package:expense_management_system/shared/http/interceptor/dio_connectivity_request_retrier.dart';
import 'package:expense_management_system/shared/http/interceptor/retry_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Define a provider for the network configuration
final networkConfigProvider = Provider<NetworkConfig>((ref) {
  final baseUrl = dotenv.env['BASE_URL'] ?? 'https://default-api.com/';
  return NetworkConfig(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 5),
  );
});

// Define a provider for the Dio instance
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(networkConfigProvider);
  final dio = Dio();

  // Configure Dio with timeouts from NetworkConfig
  dio.options.baseUrl = config.baseUrl;
  dio.options.sendTimeout = config.sendTimeout;
  dio.options.connectTimeout = config.connectTimeout;
  dio.options.receiveTimeout = config.receiveTimeout;

  // Add pretty logger for debug mode
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(requestBody: true));
  }

  return dio;
});

// Create a network configuration class to centralize network settings
class NetworkConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, String> defaultHeaders;

  const NetworkConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 5),
    this.receiveTimeout = const Duration(seconds: 60),
    this.sendTimeout = const Duration(seconds: 5),
    this.defaultHeaders = const {},
  });
}

// enum ContentType { urlEncoded, json,  }

final apiProvider = Provider<ApiProvider>((ref) {
  final dio = ref.watch(dioProvider);

  // Add auth interceptor
  dio.interceptors.add(ref.read(authInterceptorProvider));

  // Add retry interceptor
  dio.interceptors.add(
    RetryOnConnectionChangeInterceptor(
      requestRetrier: DioConnectivityRequestRetrier(
        dio: dio,
        connectivity: Connectivity(),
      ),
    ),
  );

  return ApiProvider(ref, dio);
});

class ApiProvider {
  ApiProvider(this._ref, this._dio);

  final Ref _ref;
  final Dio _dio;

  // Expose the baseUrl getter
  String get baseUrl => _ref.read(networkConfigProvider).baseUrl;

  // Helper method to check connectivity
  Future<bool> _checkConnectivity() async {
    return _ref.read(connectivityProvider) == ConnectionState.online;
  }

  // Helper method to handle response
  APIResponse _handleResponse(Response response) {
    if (response.statusCode == null) {
      return const APIResponse.error(AppException.connectivity());
    }

    if (response.statusCode! < 300) {
      if (response.data is Map && response.data['data'] != null) {
        return APIResponse.success(response.data['data']);
      } else {
        return APIResponse.success(response.data);
      }
    } else {
      return _handleErrorResponse(response);
    }
  }

  // Helper method to handle error response
  APIResponse _handleErrorResponse(Response response) {
    final statusCode = response.statusCode;

    if (statusCode == 401) {
      return APIResponse.error(AppException.unauthorized());
    } else if (statusCode == 404) {
      return APIResponse.error(
          AppException.errorWithMessage('Resource not found'));
    } else if (statusCode == 502) {
      return const APIResponse.error(AppException.error());
    } else {
      if (response.data is Map) {
        final message = response.data['message'] ??
            response.data['error'] ??
            'An error occurred';
        return APIResponse.error(
          AppException.errorWithMessage(message.toString()),
        );
      }
      return const APIResponse.error(AppException.error());
    }
  }

  // Helper method to handle DioError
  APIResponse _handleDioError(DioError e) {
    if (e.error is SocketException) {
      return const APIResponse.error(AppException.connectivity());
    }

    if (e.type == DioErrorType.connectionTimeout ||
        e.type == DioErrorType.receiveTimeout ||
        e.type == DioErrorType.sendTimeout) {
      return const APIResponse.error(AppException.connectivity());
    }

    if (e.response != null) {
      return _handleErrorResponse(e.response!);
    }

    return APIResponse.error(
      AppException.errorWithMessage(e.message ?? 'An error occurred'),
    );
  }

  // Helper method to create content type header
  String _getContentTypeHeader(ContentType contentType) {
    return contentType == ContentType.json
        ? 'application/json; charset=utf-8'
        : 'application/x-www-form-urlencoded';
  }

  Future<APIResponse> post(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, String?>? query,
    ContentType contentType = ContentType.json,
  }) async {
    // Check connectivity first
    if (!await _checkConnectivity()) {
      return const APIResponse.error(AppException.connectivity());
    }

    final url = newBaseUrl != null ? newBaseUrl + path : baseUrl + path;

    try {
      final headers = {
        'accept': '*/*',
        'Content-Type': _getContentTypeHeader(contentType),
      };

      // Optional token override for specific endpoints
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.post(
        url,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    } on Error catch (e) {
      return APIResponse.error(
        AppException.errorWithMessage(e.stackTrace.toString()),
      );
    }
  }

  Future<APIResponse> get(
    String path, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? query,
    ContentType contentType = ContentType.json,
  }) async {
    // Check connectivity first
    if (!await _checkConnectivity()) {
      return const APIResponse.error(AppException.connectivity());
    }

    final url = newBaseUrl != null ? newBaseUrl + path : baseUrl + path;

    try {
      final headers = {
        'accept': '*/*',
        'Content-Type': _getContentTypeHeader(contentType),
      };

      // Optional token override for specific endpoints
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.get(
        url,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return APIResponse.error(
        AppException.errorWithMessage(e.toString()),
      );
    }
  }

  Future<APIResponse> put(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, String?>? query,
    ContentType contentType = ContentType.json,
  }) async {
    if (!await _checkConnectivity()) {
      return const APIResponse.error(AppException.connectivity());
    }

    final url = newBaseUrl != null ? newBaseUrl + path : baseUrl + path;

    try {
      final headers = {
        'accept': '*/*',
        'Content-Type': _getContentTypeHeader(contentType),
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.put(
        url,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    }
  }

  Future<APIResponse> delete(
    String path, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? query,
  }) async {
    if (!await _checkConnectivity()) {
      return const APIResponse.error(AppException.connectivity());
    }

    final url = newBaseUrl != null ? newBaseUrl + path : baseUrl + path;

    try {
      final headers = {
        'accept': '*/*',
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.delete(
        url,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    }
  }

  Future<APIResponse> patch(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, String?>? query,
    ContentType contentType = ContentType.json,
  }) async {
    if (!await _checkConnectivity()) {
      return const APIResponse.error(AppException.connectivity());
    }

    final url = newBaseUrl != null ? newBaseUrl + path : baseUrl + path;

    try {
      final headers = {
        'accept': '*/*',
        'Content-Type': _getContentTypeHeader(contentType),
      };

      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.patch(
        url,
        data: body,
        queryParameters: query,
        options: Options(headers: headers),
      );

      return _handleResponse(response);
    } on DioError catch (e) {
      return _handleDioError(e);
    }
  }
}
