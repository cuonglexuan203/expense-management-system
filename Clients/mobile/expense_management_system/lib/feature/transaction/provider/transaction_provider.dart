import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/feature/transaction/repository/transaction_repository.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/shared/pagination/pagination_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

@riverpod
class PaginatedTransactions extends _$PaginatedTransactions {
  @override
  PaginatedState<Transaction> build(int walletId) {
    state = PaginatedState.initial<Transaction>();

    Future.microtask(() async {
      await fetchNextPage();
    });

    return state;
  }

  Future<void> fetchNextPage() async {
    try {
      if (state.isLoading || state.hasReachedEnd) {
        return;
      }

      state = state.copyWith(isLoading: true);

      final repository = ref.read(transactionRepositoryProvider);

      final response = await repository.getTransactionsByWalletPaginated(
        walletId,
        pageNumber: state.paginationInfo.pageNumber,
        pageSize: state.paginationInfo.pageSize,
      );

      response.when(
        success: (paginatedResponse) {
          final newTransactions = paginatedResponse.items;
          final newPaginationInfo = paginatedResponse.paginationInfo;

          state = state.copyWith(
            items: [...state.items, ...newTransactions],
            paginationInfo: newPaginationInfo,
            isLoading: false,
            hasReachedEnd: !newPaginationInfo.hasNextPage,
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
    state = PaginatedState.initial<Transaction>().copyWith(isLoading: true);

    await fetchNextPage();
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

    return response.when(
      success: (transaction) => transaction,
      error: (error) {
        state = AsyncError(error, StackTrace.current);
        throw error;
      },
    );
  }
}
