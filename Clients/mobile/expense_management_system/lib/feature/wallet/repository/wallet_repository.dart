import 'dart:convert';

import 'package:flutter_boilerplate/feature/auth/repository/token_repository.dart';
import 'package:flutter_boilerplate/feature/wallet/model/wallet.dart';
import 'package:flutter_boilerplate/shared/http/api_provider.dart';
import 'package:flutter_boilerplate/shared/http/api_response.dart';
import 'package:flutter_boilerplate/shared/http/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletRepositoryProvider = Provider((ref) => WalletRepository(ref));

class WalletRepository {
  final Ref _ref;
  late final ApiProvider _api = _ref.read(apiProvider);
  late final TokenRepository _tokenRepository =
      _ref.read(tokenRepositoryProvider);

  WalletRepository(this._ref);

  Future<APIResponse<Wallet>> createWallet(String name, double balance) async {
    try {
      final params = {
        'name': name,
        'balance': balance,
      };

      final response = await _api.post(
        'Wallet',
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
      print("Error in createWallet: $e");
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }
}
