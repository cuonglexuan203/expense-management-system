import 'dart:convert';
import 'package:flutter_boilerplate/feature/auth/repository/token_repository.dart';
import 'package:flutter_boilerplate/feature/wallet/model/wallet.dart';
import 'package:flutter_boilerplate/shared/http/api_provider.dart';
import 'package:flutter_boilerplate/shared/http/api_response.dart';
import 'package:flutter_boilerplate/shared/http/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletRepositoryProvider = Provider(WalletRepository.new);

class WalletRepository {
  WalletRepository(this._ref);
  final Ref _ref;
  late final ApiProvider _api = _ref.read(apiProvider);

  Future<APIResponse<Wallet>> createWallet(String name, double balance,
      {String? description}) async {
    try {
      final params = {
        'name': name,
        'balance': balance,
        'description': description,
      };

      final response = await _api.post(
        'Wallet',
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
        'Wallet',
      );

      return response.when(
        success: (data) {
          if (data is List) {
            final wallets = data.map((item) {
              if (item is Map<String, dynamic>) {
                return Wallet.fromJson(item);
              }
              return Wallet(id: 0, name: 'Unknown');
            }).toList();
            return APIResponse.success(wallets);
          } else {
            return const APIResponse.error(AppException.errorWithMessage(
                'Invalid data format: Data is not a list'));
          }
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }

  Future<APIResponse<Wallet>> getWalletSummary(
      int walletId, String period) async {
    try {
      final params = {"walletId": walletId, "period": period};

      final response = await _api.post(
        'Wallet/wallet-summary',
        jsonEncode(params),
        contentType: ContentType.json,
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
