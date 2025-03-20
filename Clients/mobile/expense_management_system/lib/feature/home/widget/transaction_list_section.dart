import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/feature/transaction/widget/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NonScrollableTransactionList extends ConsumerWidget {
  final int walletId;

  const NonScrollableTransactionList({required this.walletId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginatedState = ref.watch(paginatedTransactionsProvider(walletId));
    final transactions = paginatedState.items;
    final isLoading = paginatedState.isLoading;
    final hasError = paginatedState.errorMessage != null;

    if (!isLoading &&
        !paginatedState.hasReachedEnd &&
        transactions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(paginatedTransactionsProvider(walletId).notifier)
            .fetchNextPage();
      });
    }

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

    return Column(
      children: [
        ...transactions
            .map((transaction) => TransactionItem(transaction: transaction)),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (!paginatedState.hasReachedEnd)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: InkWell(
              onTap: () {
                ref
                    .read(paginatedTransactionsProvider(walletId).notifier)
                    .fetchNextPage();
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Load more',
                    style: TextStyle(color: Color(0xFF386BF6))),
              ),
            ),
          ),
      ],
    );
  }
}
