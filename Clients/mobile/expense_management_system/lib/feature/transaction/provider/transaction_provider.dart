import 'package:flutter_boilerplate/feature/transaction/model/transaction.dart';
import 'package:flutter_boilerplate/feature/transaction/repository/transaction_repository,dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_provider.g.dart';

@riverpod
Future<List<Transaction>> walletTransactions(
  WalletTransactionsRef ref,
  int walletId,
) async {
  final repository = ref.watch(transactionRepositoryProvider);
  final response = await repository.getTransactionsByWallet(walletId);

  return response.when(
    success: (transactions) => transactions,
    error: (error) => throw Exception(error),
  );
}
