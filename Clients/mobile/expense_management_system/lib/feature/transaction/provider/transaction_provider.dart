// transaction_provider.dart
import 'package:flutter_boilerplate/feature/transaction/model/transaction.dart';
import 'package:flutter_boilerplate/feature/transaction/repository/transaction_repository.dart';
import 'package:flutter_boilerplate/feature/wallet/provider/wallet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

@riverpod
Future<List<Transaction>> walletTransactions(
  WalletTransactionsRef ref,
  String walletName,
) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final response = await repository.getTransactionsByWallet(walletName);

  return response.when(
    success: (transactions) => transactions,
    error: (error) => throw Exception(error),
  );
}

// Added TransactionNotifier for creating transactions
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
