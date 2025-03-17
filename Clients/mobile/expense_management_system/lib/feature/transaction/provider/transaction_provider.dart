import 'package:flutter_boilerplate/feature/transaction/model/transaction.dart';
import 'package:flutter_boilerplate/feature/transaction/repository/transaction_repository.dart';
import 'package:flutter_boilerplate/feature/wallet/provider/wallet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

// Modified to accept a wallet ID instead of a wallet name
@riverpod
Future<List<Transaction>> walletTransactions(
  WalletTransactionsRef ref,
  int walletId,
) async {
  // First, get the wallet to access its name
  final walletAsync = ref.watch(filteredWalletProvider(
    FilterParams(walletId: walletId, period: 'AllTime'),
  ));

  // Watch for wallet changes
  ref.listen(walletChangesProvider, (_, __) {
    ref.invalidateSelf();
  });

  // Use the wallet name to get transactions
  return walletAsync.when(
    data: (wallet) async {
      final repository = ref.watch(transactionRepositoryProvider);
      final response = await repository.getTransactionsByWallet(wallet.name);

      return response.when(
        success: (transactions) => transactions,
        error: (error) => throw Exception(error),
      );
    },
    loading: () => [], // Return empty list while loading
    error: (error, stack) => throw error, // Propagate the error
  );
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
    required String categoryName,
    required double amount,
    required bool isExpense,
    required DateTime occurredAt,
  }) async {
    final type = isExpense ? 'Expense' : 'Income';

    final response = await _repository.createTransaction(
      name: name,
      walletId: walletId,
      category: categoryName,
      amount: amount,
      type: type,
      occurredAt: occurredAt,
    );

    // Notify wallet changes provider to refresh wallet data
    ref.read(walletChangesProvider.notifier).notifyChanges();

    return response.when(
      success: (transaction) => transaction,
      error: (error) {
        state = AsyncError(error, StackTrace.current);
        throw error;
      },
    );
  }
}
