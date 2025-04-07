import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/feature/transaction/widget/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionList extends ConsumerWidget {
  final int walletId;
  final String period;

  const TransactionList({
    required this.walletId,
    this.period = 'AllTime',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginatedState =
        ref.watch(filteredTransactionsProvider(TransactionFilterParams(
      walletId: walletId,
      period: period,
    )));
    final transactions = paginatedState.items;
    final isLoading = paginatedState.isLoading;
    final hasError = paginatedState.errorMessage != null;
    final hasReachedEnd = paginatedState.hasReachedEnd;

    if (hasError && transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            Text(
              'Error: ${paginatedState.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(paginatedTransactionsProvider(walletId).notifier)
                    .refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (transactions.isEmpty && !isLoading) {
      return const Center(
        child: Text(
          'No transactions yet',
          style:
              TextStyle(color: Colors.grey, fontSize: 16, fontFamily: 'Nunito'),
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ...transactions
            .map((transaction) => TransactionItem(transaction: transaction)),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (hasReachedEnd && transactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(1, 16, 1, 0),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'All transactions loaded',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
