// transaction_repository.dart
import 'dart:convert';
import 'package:flutter_boilerplate/feature/transaction/model/transaction.dart';
import 'package:flutter_boilerplate/shared/constants/api_endpoints.dart';
import 'package:flutter_boilerplate/shared/http/api_provider.dart';
import 'package:flutter_boilerplate/shared/http/api_response.dart';
import 'package:flutter_boilerplate/shared/http/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider(TransactionRepository.new);

class TransactionRepository {
  TransactionRepository(this._ref);
  final Ref _ref;
  late final ApiProvider _api = _ref.read(apiProvider);

  Future<APIResponse<List<Transaction>>> getTransactionsByWallet(
      String walletName) async {
    try {
      final response = await _api.get(
        ApiEndpoints.transaction.getAll,
        query: {'Wallet': walletName},
      );

      return response.when(
        success: (data) {
          // Handle paginated response with items field
          if (data is Map<String, dynamic> && data.containsKey('items')) {
            final items = data['items'] as List<dynamic>;
            final transactions = items
                .map((item) {
                  if (item is Map<String, dynamic>) {
                    return Transaction.fromJson(item);
                  }
                  return null;
                })
                .whereType<Transaction>()
                .toList();

            return APIResponse.success(transactions);
          }

          // Fallback for direct list response
          if (data is List) {
            final transactions = data
                .map((item) {
                  if (item is Map<String, dynamic>) {
                    return Transaction.fromJson(item);
                  }
                  return null;
                })
                .whereType<Transaction>()
                .toList();
            return APIResponse.success(transactions);
          }

          // Return empty list if response format is unexpected
          return const APIResponse.success([]);
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }

  // Added createTransaction method with correct API contract
  Future<APIResponse<Transaction>> createTransaction({
    required String name,
    required int walletId,
    required String category,
    required double amount,
    required String type,
    required DateTime occurredAt,
  }) async {
    try {
      final params = {
        'name': name,
        'walletId': walletId,
        'category': category,
        'amount': amount,
        'type': type,
        'occurredAt': occurredAt.toUtc().toIso8601String(),
      };

      final response = await _api.post(
        ApiEndpoints.transaction.create,
        jsonEncode(params),
      );

      return response.when(
        success: (data) {
          final transaction =
              Transaction.fromJson(data as Map<String, dynamic>);
          return APIResponse.success(transaction);
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }
}
