import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:expense_management_system/feature/auth/model/token.dart';
import 'package:expense_management_system/feature/auth/repository/token_repository.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.tokenRepository, this.dio, this.ref);
  final TokenRepository tokenRepository;
  final Dio dio;
  final Ref ref;
  bool _isRefreshing = false;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await tokenRepository.fetchToken();

      if (token != null && token.accessToken!.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${token.accessToken}';
      }

      return handler.next(options);
    } catch (error) {
      print("Error in AuthInterceptor.onRequest: $error");
      return handler.next(options);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    bool isLoginRequest =
        err.requestOptions.path.contains(ApiEndpoints.auth.login);

    if (err.response?.statusCode == 401 && !_isRefreshing && !isLoginRequest) {
      _isRefreshing = true;
      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          final token = await tokenRepository.fetchToken();
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer ${token!.accessToken}';
          final response = await dio.fetch(options);
          _isRefreshing = false;
          return handler.resolve(response);
        } else {
          await tokenRepository.remove();
        }
      } catch (e) {
        print('Error refreshing token: $e');
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final token = await tokenRepository.fetchToken();
      if (token == null || token.refreshToken!.isEmpty) {
        return false;
      }

      final baseUrl = ref.read(apiProvider).baseUrl;

      final response = await dio.post(
        '${baseUrl}${ApiEndpoints.auth.refreshToken}',
        data: {
          'accessToken': token.accessToken,
          'refreshToken': token.refreshToken,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      );

      if (response.statusCode == 200) {
        final tokenData = response.data as Map<String, dynamic>;
        final newToken = Token(
          token: json.encode(tokenData),
          accessToken: tokenData['accessToken']?.toString() ?? '',
          refreshToken: tokenData['refreshToken']?.toString() ?? '',
          accessTokenExpiration:
              tokenData['accessTokenExpiration']?.toString() ?? '',
          refreshTokenExpiration:
              tokenData['refreshTokenExpiration']?.toString() ?? '',
        );
        await tokenRepository.saveToken(newToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}

final authInterceptorProvider = Provider((ref) {
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  final dio = ref.watch(dioProvider);
  return AuthInterceptor(tokenRepository, dio, ref);
});
