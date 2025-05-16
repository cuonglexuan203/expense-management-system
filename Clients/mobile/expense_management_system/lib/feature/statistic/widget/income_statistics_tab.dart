import 'package:expense_management_system/feature/statistic/provider/statistics_provider.dart';
import 'package:expense_management_system/feature/statistic/widget/empty_state_widget.dart';
import 'package:expense_management_system/feature/statistic/widget/error_display_widget.dart';
import 'package:expense_management_system/feature/statistic/widget/list_item_transaction.dart';
import 'package:expense_management_system/feature/statistic/widget/trend_line_chart.dart';
import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart'; // Ensure this is the correct path
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncomeStatisticsTab extends ConsumerWidget {
  final AsyncValue<Wallet> walletAsync;
  final int walletId;
  final String selectedPeriod;

  const IncomeStatisticsTab({
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

    // 1. Create TransactionFilterParams for recent income transactions
    final recentIncomeFilterParams = TransactionFilterParams(
      walletId: walletId,
      type: 'Income',
      period: selectedPeriod,
      sort: 'DESC',
      // pageSize: 5 cannot be set here due to constraints.
      // filteredTransactionsProvider will use its default pageSize (10).
      // We will take the first 5 items from the result.
    );

    // 2. Watch filteredTransactionsProvider
    // This directly returns PaginatedState<Transaction>, not AsyncValue<PaginatedState<Transaction>>
    final recentIncomeState =
        ref.watch(filteredTransactionsProvider(recentIncomeFilterParams));

    return walletAsync.when(
      data: (wallet) {
        final incomeAmount = wallet.income.totalAmount;
        final incomeTransactionCount = wallet.income.transactionCount;

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(filteredWalletProvider(
                FilterParams(walletId: walletId, period: selectedPeriod)));
            ref.invalidate(transactionTrendsProvider(
              walletId: walletId,
              period: selectedPeriod,
            ));
            // 3. Invalidate the correct provider with correct params
            ref.invalidate(
                filteredTransactionsProvider(recentIncomeFilterParams));
            // Optionally, you could call refresh on the notifier if needed, but invalidate is usually sufficient.
            // await ref.read(filteredTransactionsProvider(recentIncomeFilterParams).notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIncomeSummaryCard(
                    context, incomeAmount, incomeTransactionCount, wallet.name),
                const SizedBox(height: 24),
                trendsAsync.when(
                  data: (trendsData) {
                    final incomeSpots = trendsData['income'] ?? [];
                    if (incomeSpots.isEmpty ||
                        incomeSpots.every((s) => s.y == 0)) {
                      return _buildNoDataCard(context, 'Income Trend Data');
                    }
                    return TrendLineChart(
                      incomeSpots: incomeSpots,
                      expenseSpots: const [],
                      period: selectedPeriod,
                      chartTitle: 'Income Flow',
                      lineColors: [Colors.green.shade600],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => ErrorDisplayWidget(
                      message:
                          'Error loading income trends: ${err.toString()}'),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Recent Income Transactions'),
                // 4. Handle PaginatedState directly
                Builder(
                  builder: (context) {
                    // recentIncomeState is PaginatedState<Transaction>

                    // Case 1: Initial loading (no items yet, actively loading)
                    if (recentIncomeState.isLoading &&
                        recentIncomeState.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Case 2: Error occurred (and no items to display as fallback)
                    if (recentIncomeState.errorMessage != null &&
                        recentIncomeState.items.isEmpty) {
                      return ErrorDisplayWidget(
                          message:
                              'Error loading transactions: ${recentIncomeState.errorMessage}');
                    }

                    // Case 3: Data is available
                    if (recentIncomeState.items.isNotEmpty) {
                      // Take the first 5 items for display
                      final transactionsToDisplay =
                          recentIncomeState.items.take(5).toList();

                      // If, after taking 5, the list to display is empty,
                      // it implies the original list was empty.
                      // This scenario is better handled by the next condition.
                      // However, if recentIncomeState.items is not empty,
                      // transactionsToDisplay (from take(5)) will also not be empty.
                      if (transactionsToDisplay.isEmpty) {
                        return const EmptyStateWidget(
                            message:
                                'No income transactions found for this period.');
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactionsToDisplay.length,
                        itemBuilder: (context, index) {
                          final transaction = transactionsToDisplay[index];
                          return ListItemTransaction(transaction: transaction);
                        },
                      );
                    }

                    // Case 4: No data, and not loading (successfully loaded an empty list)
                    if (recentIncomeState.items.isEmpty &&
                        !recentIncomeState.isLoading) {
                      return const EmptyStateWidget(
                          message:
                              'No income transactions found for this period.');
                    }

                    // Case 5: Fallback loading indicator (e.g., refreshing, or if still loading but items might exist)
                    if (recentIncomeState.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Default/Fallback: Should ideally not be reached
                    return const SizedBox.shrink();
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

  Widget _buildIncomeSummaryCard(BuildContext context, double incomeAmount,
      int transactionCount, String walletName) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade600, Colors.green.shade400],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
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
                child: const Icon(Icons.arrow_downward_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Total Income (${_getPeriodDisplayName(selectedPeriod)})',
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
            incomeAmount.toFormattedString(),
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

  String _getPeriodDisplayName(String periodApiValue) {
    for (var periodEnum in TransactionPeriod.values) {
      if (periodEnum.apiValue == periodApiValue) {
        return periodEnum.label;
      }
    }
    return periodApiValue; // Fallback to apiValue if no match found
  }

  Widget _buildNoDataCard(BuildContext context, String dataType) {
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
