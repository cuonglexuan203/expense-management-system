// feature/statistic/widget/expense_statistics_tab.dart
import 'package:expense_management_system/feature/statistic/model/category_spending_summary.dart';
import 'package:expense_management_system/feature/statistic/provider/statistics_provider.dart';
import 'package:expense_management_system/feature/statistic/widget/empty_state_widget.dart';
import 'package:expense_management_system/feature/statistic/widget/error_display_widget.dart';
import 'package:expense_management_system/feature/statistic/widget/list_item_transaction.dart';
import 'package:expense_management_system/feature/statistic/widget/top_category_list_item.dart'; // Re-using from overview
import 'package:expense_management_system/feature/statistic/widget/trend_line_chart.dart';
import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseStatisticsTab extends ConsumerWidget {
  final AsyncValue<Wallet> walletAsync;
  final int walletId;
  final String selectedPeriod;

  const ExpenseStatisticsTab({
    Key? key,
    required this.walletAsync,
    required this.walletId,
    required this.selectedPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendsAsync = ref.watch(transactionTrendsProvider(
      walletId: walletId,
      period: selectedPeriod,
    ));

    final topExpenseCategoriesAsync = ref.watch(topExpenseCategoriesProvider(
      walletId: walletId,
      period: selectedPeriod,
    ));

    final recentExpenseParams = TransactionFilterParams(
      walletId: walletId,
      type: 'Expense',
      period:
          selectedPeriod, // Or 'AllTime' for truly "recent" regardless of filter
      sort: 'DESC', // Sort by date descending for "recent"
      // pageSize is handled by the provider's pagination logic
    );
    final recentExpenseTransactionsAsync =
        ref.watch(filteredTransactionsProvider(recentExpenseParams));

    return walletAsync.when(
      data: (wallet) {
        final expenseAmount = wallet.expense.totalAmount;
        final expenseTransactionCount = wallet.expense.transactionCount;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(filteredWalletProvider(
                FilterParams(walletId: walletId, period: selectedPeriod)));
            ref.invalidate(transactionTrendsProvider(
              walletId: walletId,
              period: selectedPeriod,
            ));
            ref.invalidate(topExpenseCategoriesProvider(
              walletId: walletId,
              period: selectedPeriod,
            ));
            ref.invalidate(filteredTransactionsProvider(recentExpenseParams));
            // Or use ref.refresh for StateNotifierProvider.family if you want to re-initialize
            // ref.refresh(filteredTransactionsProvider(recentExpenseParams).notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExpenseSummaryCard(context, expenseAmount,
                    expenseTransactionCount, wallet.name),
                const SizedBox(height: 24),
                trendsAsync.when(
                  data: (trendsData) {
                    final expenseSpots = trendsData['expense'] ?? [];
                    if (expenseSpots.isEmpty ||
                        expenseSpots.every((s) => s.y == 0)) {
                      return _buildNoDataCard(context, 'Expense Trend Data');
                    }
                    return TrendLineChart(
                      incomeSpots: const [], // No income line
                      expenseSpots: expenseSpots,
                      period: selectedPeriod,
                      chartTitle: 'Expense Flow',
                      lineColors: [Colors.red.shade600],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => ErrorDisplayWidget(
                      message:
                          'Error loading expense trends: ${err.toString()}'),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Top Expense Categories'),
                topExpenseCategoriesAsync.when(
                  data: (categories) {
                    if (categories.isEmpty) {
                      return const EmptyStateWidget(
                          message:
                              'No expense categories found for this period.');
                    }
                    return _buildTopCategoriesList(context, categories);
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => ErrorDisplayWidget(
                      message:
                          'Error loading top categories: ${err.toString()}'),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Recent Expense Transactions'),
                Builder(
                  builder: (context) {
                    final state =
                        recentExpenseTransactionsAsync; // state is PaginatedState

                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state.errorMessage != null) {
                      return ErrorDisplayWidget(
                          message:
                              'Error loading transactions: ${state.errorMessage}');
                    } else {
                      final transactions = state.items;
                      if (transactions.isEmpty) {
                        return const EmptyStateWidget(
                            message:
                                'No expense transactions found for this period.');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactions.length > 5
                            ? 5
                            : transactions.length, // Show top 5 recent
                        itemBuilder: (context, index) {
                          final transaction =
                              transactions[index] as Transaction;
                          return ListItemTransaction(transaction: transaction);
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorDisplayWidget(
        message: 'Error loading wallet summary: ${error.toString()}',
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
              color: const Color(0xFF2D3142),
            ),
      ),
    );
  }

  Widget _buildExpenseSummaryCard(BuildContext context, double expenseAmount,
      int transactionCount, String walletName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red.shade600, Colors.red.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_upward_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Total Expenses (${_getPeriodDisplayName(selectedPeriod)})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            expenseAmount.toFormattedString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$transactionCount transactions in "$walletName"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCategoriesList(
      BuildContext context, List<CategorySpendingSummary> categories) {
    return Container(
      padding: const EdgeInsets.all(12), // Reduced padding for list items
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories
            .map((category) => TopCategoryListItem(categorySummary: category))
            .toList(),
      ),
    );
  }

  String _getPeriodDisplayName(String periodApiValue) {
    for (var periodEnum in TransactionPeriod.values) {
      if (periodEnum.apiValue == periodApiValue) {
        return periodEnum.label;
      }
    }
    return periodApiValue; // Fallback to apiValue if no match found
  }

  Widget _buildNoDataCard(BuildContext context, String dataType) {
    // This can be moved to a shared utility file or use EmptyStateWidget
    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insights_rounded, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No $dataType',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito',
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'There is no data to display for the selected period.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Nunito',
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
