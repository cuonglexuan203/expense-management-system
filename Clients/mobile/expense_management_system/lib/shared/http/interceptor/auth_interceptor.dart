import 'package:dio/dio.dart';
import 'package:flutter_boilerplate/feature/auth/repository/token_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthInterceptor extends Interceptor {
  final TokenRepository tokenRepository;

  AuthInterceptor(this.tokenRepository);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await tokenRepository.fetchToken();

      if (token != null) {
        options.headers['Authorization'] = 'Bearer ${token.token}';
      }

      return handler.next(options);
    } catch (error) {
      return handler.next(options);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle refresh token or logout
    }
    return handler.next(err);
  }
}

final authInterceptorProvider = Provider((ref) {
  final tokenRepository = ref.watch(tokenRepositoryProvider);
  return AuthInterceptor(tokenRepository);
});
