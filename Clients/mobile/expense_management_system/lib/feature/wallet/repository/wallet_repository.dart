import 'dart:convert';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletRepositoryProvider = Provider(WalletRepository.new);

class WalletRepository {
  WalletRepository(this._ref);
  final Ref _ref;
  late final ApiProvider _api = _ref.read(apiProvider);

  Future<APIResponse<Wallet>> createWallet(
    String name,
    double balance, {
    String? description,
  }) async {
    try {
      final params = {
        'name': name,
        'balance': balance,
        'description': description,
      };

      final response = await _api.post(
        ApiEndpoints.wallet.create,
        jsonEncode(params),
      );

      return response.when(
        success: (data) {
          final wallet = Wallet.fromJson(data as Map<String, dynamic>);
          return APIResponse.success(wallet);
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }

  Future<APIResponse<List<Wallet>>> getWallets() async {
    try {
      final response = await _api.get(
        ApiEndpoints.wallet.getAll,
      );

      return response.when(
        success: (data) {
          if (data is List) {
            final wallets = data.map((item) {
              if (item is Map<String, dynamic>) {
                return Wallet.fromJson(item);
              }
              return const Wallet(id: 0, name: 'Unknown');
            }).toList();
            return APIResponse.success(wallets);
          } else {
            return const APIResponse.error(
              AppException.errorWithMessage(
                'Invalid data format: Data is not a list',
              ),
            );
          }
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }

  Future<APIResponse<Wallet>> getWalletSummary(
    int walletId,
    String period, {
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final params = {
        'walletId': walletId,
        'period': period,
        if (fromDate != null) 'fromDate': fromDate.toIso8601String(),
        if (toDate != null) 'toDate': toDate.toIso8601String(),
      };

      final response = await _api.post(
        ApiEndpoints.wallet.walletSummary,
        jsonEncode(params),
      );

      return response.when(
        success: (data) {
          final wallet = Wallet.fromJson(data as Map<String, dynamic>);
          return APIResponse.success(wallet);
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }

  Future<APIResponse<Wallet>> getWalletById(int id) async {
    try {
      final response = await _api.get(
        ApiEndpoints.wallet.getById(id.toString()),
      );

      return response.when(
        success: (data) {
          final wallet = Wallet.fromJson(data as Map<String, dynamic>);
          return APIResponse.success(wallet);
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }
}
