import 'dart:convert';

import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_management_system/feature/auth/model/token.dart';
import 'package:expense_management_system/feature/auth/repository/token_repository.dart';
import 'package:expense_management_system/feature/auth/state/auth_state.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:expense_management_system/shared/util/validator.dart';

abstract class AuthRepositoryProtocol {
  Future<AuthState> login(String email, String password);
  Future<AuthState> signUp(String name, String email, String password);
}

final authRepositoryProvider = Provider(AuthRepository.new);

class AuthRepository implements AuthRepositoryProtocol {
  AuthRepository(this._ref) {}

  late final ApiProvider _api = _ref.read(apiProvider);
  final Ref _ref;

  @override
  Future<AuthState> login(String email, String password) async {
    if (!Validator.isValidPassWord(password)) {
      return const AuthState.error(
        AppException.errorWithMessage('Minimum 5 characters required'),
      );
    }
    if (!Validator.isValidEmail(email)) {
      return const AuthState.error(
        AppException.errorWithMessage('Please enter a valid email address'),
      );
    }
    final params = {
      'email': email,
      'password': password,
    };
    final loginResponse =
        await _api.post(ApiEndpoints.auth.login, jsonEncode(params));

    return loginResponse.when(success: (success) async {
      Map<String, dynamic> tokenData;
      if (success is Map<String, dynamic>) {
        tokenData = success;
      } else if (success is String) {
        try {
          tokenData = json.decode(success) as Map<String, dynamic>;
        } catch (e) {
          return const AuthState.error(
            AppException.errorWithMessage('Invalid token format received'),
          );
        }
      } else {
        return const AuthState.error(
          AppException.errorWithMessage('Invalid response format'),
        );
      }

      final token = Token(
        token: json.encode(tokenData),
        accessToken: tokenData['accessToken']?.toString() ?? '',
        refreshToken: tokenData['refreshToken']?.toString() ?? '',
        accessTokenExpiration:
            tokenData['accessTokenExpiration']?.toString() ?? '',
        refreshTokenExpiration:
            tokenData['refreshTokenExpiration']?.toString() ?? '',
      );

      final tokenRepository = _ref.read(tokenRepositoryProvider);
      await tokenRepository.saveToken(token);

      return const AuthState.loggedIn();
    }, error: (error) {
      return AuthState.error(error);
    });
  }

  @override
  Future<AuthState> signUp(String name, String email, String password) async {
    if (!Validator.isValidPassWord(password)) {
      return const AuthState.error(
        AppException.errorWithMessage('Minimum 5 characters required'),
      );
    }
    if (!Validator.isValidEmail(email)) {
      return const AuthState.error(
        AppException.errorWithMessage('Please enter a valid email address'),
      );
    }
    final params = {
      'name': name,
      'email': email,
      'password': password,
    };
    final loginResponse =
        await _api.post(ApiEndpoints.auth.register, jsonEncode(params));

    return loginResponse.when(success: (success) async {
      final tokenRepository = _ref.read(tokenRepositoryProvider);

      // Convert dynamic to Map<String, dynamic>
      Map<String, dynamic> tokenData;
      if (success is Map<String, dynamic>) {
        tokenData = success;
      } else if (success is String) {
        try {
          tokenData = json.decode(success) as Map<String, dynamic>;
        } catch (e) {
          // If the string is not valid JSON, use it directly as a token
          final token = Token(
              token: success.toString(),
              accessToken: '',
              refreshToken: '',
              accessTokenExpiration: '',
              refreshTokenExpiration: '');
          await tokenRepository.saveToken(token);
          return const AuthState.loggedIn();
        }
      } else {
        // For other types, convert to string
        final token = Token(
            token: success.toString(),
            accessToken: '',
            refreshToken: '',
            accessTokenExpiration: '',
            refreshTokenExpiration: '');
        await tokenRepository.saveToken(token);
        return const AuthState.loggedIn();
      }

      final token = Token(
          token: json.encode(tokenData),
          accessToken: tokenData['accessToken']?.toString() ?? '',
          refreshToken: tokenData['refreshToken']?.toString() ?? '',
          accessTokenExpiration:
              tokenData['accessTokenExpiration']?.toString() ?? '',
          refreshTokenExpiration:
              tokenData['refreshTokenExpiration']?.toString() ?? '');
      await tokenRepository.saveToken(token);

      return const AuthState.loggedIn();
    }, error: (error) {
      return AuthState.error(error);
    });
  }
}
