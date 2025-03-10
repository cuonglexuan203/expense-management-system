import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/feature/auth/model/token.dart';
import 'package:flutter_boilerplate/feature/auth/repository/token_repository.dart';
import 'package:flutter_boilerplate/shared/http/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  final TokenRepository tokenRepository;
  final Dio dio;
  final Ref ref;
  bool _isRefreshing = false;

  AuthInterceptor(this.tokenRepository, this.dio, this.ref);

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
    if (err.response?.statusCode == 401 && !_isRefreshing) {
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

      final apiProvider = ref.read(apiProvider);
      final baseUrl = apiProvider._baseUrl;

      final response = await dio.post(
        '${baseUrl}Auth/refresh-token',
        data: {'refreshToken': token.refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => true,
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
      print("Error in _refreshToken: $e");
      return false;
    }
  }
}

final authInterceptorProvider = Provider((ref) {
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  final dio = Dio();
  return AuthInterceptor(tokenRepository, dio, ref);
});
