import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/feature/transaction/repository/transaction_repository.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/shared/pagination/pagination_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

class TransactionFilterParams {
  final int walletId;
  final String period;
  final String? type;
  final String sort;
  final String? search;
  final DateTime? fromDate;
  final DateTime? toDate;

  const TransactionFilterParams({
    required this.walletId,
    this.period = 'AllTime',
    this.type,
    this.sort = 'DESC',
    this.search,
    this.fromDate,
    this.toDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionFilterParams &&
          walletId == other.walletId &&
          period == other.period &&
          type == other.type &&
          sort == other.sort &&
          search == other.search &&
          fromDate == other.fromDate &&
          toDate == other.toDate;

  @override
  int get hashCode =>
      Object.hash(walletId, period, type, sort, search, fromDate, toDate);
}

final filteredTransactionsProvider = StateNotifierProvider.family<
    FilteredTransactionsNotifier,
    PaginatedState<Transaction>,
    TransactionFilterParams>(
  (ref, params) => FilteredTransactionsNotifier(ref, params),
);

class FilteredTransactionsNotifier
    extends StateNotifier<PaginatedState<Transaction>> {
  final Ref _ref;
  final TransactionFilterParams params;

  FilteredTransactionsNotifier(this._ref, this.params)
      : super(PaginatedState.initial<Transaction>()) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasReachedEnd) return;

    state = state.copyWith(isLoading: true);
    final repository = _ref.read(transactionRepositoryProvider);

    try {
      final nextPage =
          state.items.isEmpty ? 1 : state.paginationInfo.pageNumber + 1;

      final response = await repository.getTransactionsByWalletPaginated(
        params.walletId,
        pageNumber: nextPage,
        pageSize: state.paginationInfo.pageSize,
        period: params.period,
        type: params.type,
        sort: params.sort,
        search: params.search,
      );

      response.when(
        success: (paginatedResponse) {
          if (paginatedResponse.items.isEmpty) {
            state = state.copyWith(
              isLoading: false,
              hasReachedEnd: true,
            );
            return;
          }

          state = state.copyWith(
            items: [...state.items, ...paginatedResponse.items],
            paginationInfo: paginatedResponse.paginationInfo,
            isLoading: false,
            hasReachedEnd: !paginatedResponse.paginationInfo.hasNextPage,
          );
        },
        error: (error) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = PaginatedState.initial<Transaction>();
    await fetchNextPage();
  }
}

@riverpod
class PaginatedTransactions extends _$PaginatedTransactions {
  @override
  PaginatedState<Transaction> build(int walletId) {
    state = PaginatedState.initial<Transaction>();
    fetchNextPage();

    return state;
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasReachedEnd) return;

    state = state.copyWith(isLoading: true);
    final repository = ref.read(transactionRepositoryProvider);

    try {
      final nextPage =
          state.items.isEmpty ? 1 : state.paginationInfo.pageNumber + 1;

      final response = await repository.getTransactionsByWalletPaginated(
        walletId,
        pageNumber: nextPage,
        pageSize: state.paginationInfo.pageSize,
      );

      response.when(
        success: (paginatedResponse) {
          if (paginatedResponse.items.isEmpty) {
            state = state.copyWith(
              isLoading: false,
              hasReachedEnd: true,
            );
            return;
          }

          state = state.copyWith(
            items: [...state.items, ...paginatedResponse.items],
            paginationInfo: paginatedResponse.paginationInfo,
            isLoading: false,
            hasReachedEnd: !paginatedResponse.paginationInfo.hasNextPage,
          );
        },
        error: (error) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = PaginatedState.initial<Transaction>();
    await fetchNextPage();
  }
}

// Transaction Notifier for creating transactions
@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  late final _repository = ref.read(transactionRepositoryProvider);

  @override
  Future<Transaction?> build() async {
    return null; // Initial state is null
  }

  Future<Transaction?> createTransaction({
    required String name,
    required int walletId,
    required int categoryId,
    required double amount,
    required bool isExpense,
    required DateTime occurredAt,
  }) async {
    final type = isExpense ? 'Expense' : 'Income';

    final response = await _repository.createTransaction(
      name: name,
      walletId: walletId,
      categoryId: categoryId,
      amount: amount,
      type: type,
      occurredAt: occurredAt,
    );

    ref.read(walletChangesProvider.notifier).notifyChanges();

    if (ref.exists(paginatedTransactionsProvider(walletId))) {
      ref.read(paginatedTransactionsProvider(walletId).notifier).refresh();
    }

    ref.invalidate(filteredTransactionsProvider);

    return response.when(
      success: (transaction) => transaction,
      error: (error) {
        state = AsyncError(error, StackTrace.current);
        throw error;
      },
    );
  }
}

// Keep the original walletTransactions provider for compatibility
// @riverpod
// Future<List<Transaction>> walletTransactions(
//   WalletTransactionsRef ref,
//   int walletId,
// ) async {
//   // Watch for wallet changes
//   ref.listen(walletChangesProvider, (_, __) {
//     ref.invalidateSelf();
//   });

//   try {
//     final repository = ref.watch(transactionRepositoryProvider);

//     // final wallet = await ref.watch(filteredWalletProvider(
//     //   FilterParams(walletId: walletId, period: 'AllTime'),
//     // ).future);

//     final response = await repository.getTransactionsByWallet(walletId);

//     return response.when(
//       success: (transactions) => transactions,
//       error: (error) => throw Exception(error),
//     );
//   } catch (e) {
//     print('Error fetching transactions: $e');
//     throw e;
//   }
// }
