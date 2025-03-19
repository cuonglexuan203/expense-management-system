import 'dart:convert';
import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:expense_management_system/shared/pagination/pagination_info.dart';
import 'package:expense_management_system/shared/pagination/pagination_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider(TransactionRepository.new);

class TransactionRepository {
  TransactionRepository(this._ref);
  final Ref _ref;
  late final ApiProvider _api = _ref.read(apiProvider);

  // Future<APIResponse<List<Transaction>>> getTransactionsByWallet(
  //     int walletId) async {
  //   try {
  //     final response = await _api.get(
  //       ApiEndpoints.transaction.getAll,
  //       query: {'WalletId': walletId},
  //     );

  //     return response.when(
  //       success: (data) {
  //         print('API received: ${data?['items']?.length ?? 0} transactions');

  //         // Handle paginated response with items field
  //         if (data is Map<String, dynamic> && data.containsKey('items')) {
  //           final items = data['items'] as List<dynamic>;
  //           final transactions = items
  //               .map((item) {
  //                 if (item is Map<String, dynamic>) {
  //                   return Transaction.fromJson(item);
  //                 }
  //                 return null;
  //               })
  //               .whereType<Transaction>()
  //               .toList();
  //           print('Successfully parsed ${transactions.length} transactions');

  //           return APIResponse.success(transactions);
  //         }

  //         // Fallback for direct list response
  //         if (data is List) {
  //           final transactions = data
  //               .map((item) {
  //                 if (item is Map<String, dynamic>) {
  //                   return Transaction.fromJson(item);
  //                 }
  //                 return null;
  //               })
  //               .whereType<Transaction>()
  //               .toList();
  //           print('Successfully parsed ${transactions.length} transactions');
  //           return APIResponse.success(transactions);
  //         }

  //         // Return empty list if response format is unexpected
  //         return const APIResponse.success([]);
  //       },
  //       error: APIResponse.error,
  //     );
  //   } catch (e) {
  //     return APIResponse.error(AppException.errorWithMessage(e.toString()));
  //   }
  // }

  // Added createTransaction method with correct API contract
  Future<APIResponse<Transaction>> createTransaction({
    required String name,
    required int walletId,
    required int categoryId,
    required double amount,
    required String type,
    required DateTime occurredAt,
  }) async {
    try {
      final params = {
        'name': name,
        'walletId': walletId,
        'categoryId': categoryId,
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

  Future<APIResponse<PaginatedResponse<Transaction>>>
      getTransactionsByWalletPaginated(int walletId,
          {int pageNumber = 1, int pageSize = 10}) async {
    try {
      final response = await _api.get(
        ApiEndpoints.transaction.getAll,
        query: {
          'WalletId': walletId,
          'PageNumber': pageNumber.toString(),
          'PageSize': pageSize.toString(),
        },
      );

      return response.when(
        success: (data) {
          try {
            if (data is Map<String, dynamic> && data.containsKey('items')) {
              final items = data['items'] as List<dynamic>;
              final transactions = <Transaction>[];

              for (var item in items) {
                try {
                  if (item is Map<String, dynamic>) {
                    var safeItem = Map<String, dynamic>.from(item);
                    if (safeItem['amount'] == null) safeItem['amount'] = 0;

                    final transaction = Transaction.fromJson(safeItem);
                    transactions.add(transaction);
                  }
                } catch (e) {}
              }
              final paginationInfo = PaginationInfo.fromJson(data);

              return APIResponse.success(
                PaginatedResponse(
                  items: transactions,
                  paginationInfo: paginationInfo,
                ),
              );
            } else {
              return const APIResponse.error(
                AppException.errorWithMessage(
                    'Invalid response format: missing items'),
              );
            }
          } catch (parseError) {
            return APIResponse.error(
              AppException.errorWithMessage(
                  'Error parsing transaction data: $parseError'),
            );
          }
        },
        error: (error) {
          return APIResponse.error(error);
        },
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }
}
