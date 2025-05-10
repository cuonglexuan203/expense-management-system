import 'package:expense_management_system/feature/statistic/model/category_spending_summary.dart';
import 'package:expense_management_system/feature/statistic/provider/statistics_provider.dart';
import 'package:expense_management_system/feature/statistic/widget/income_expense_pie_chart.dart';
import 'package:expense_management_system/feature/statistic/widget/top_category_list_item.dart';
import 'package:expense_management_system/feature/statistic/widget/trend_line_chart.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_management_system/gen/colors.gen.dart'; // For ColorName

class OverviewStatisticsTab extends ConsumerWidget {
  final AsyncValue<Wallet> walletAsync;
  final int walletId;
  final String selectedPeriod;

  const OverviewStatisticsTab({
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
    final topCategoriesAsync = ref.watch(topExpenseCategoriesProvider(
      walletId: walletId,
      period: selectedPeriod,
    ));

    return walletAsync.when(
      data: (wallet) {
        final incomeAmount = wallet.income.totalAmount;
        final expenseAmount = wallet.expense.totalAmount;
        // final balance = incomeAmount - expenseAmount; // Already in wallet.balanceByPeriod or wallet.balance
        final balance = wallet
            .balanceByPeriod; // Assuming balanceByPeriod is correctly calculated by filteredWalletProvider

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
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            // Modify the padding to include top: 8 - this compensates for the tab bar height
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryGrid(
                  context,
                  balance: balance,
                  income: incomeAmount,
                  expense: expenseAmount,
                  totalTransactions: wallet.income.transactionCount +
                      wallet.expense.transactionCount,
                ),
                const SizedBox(height: 24),
                IncomeExpensePieChart(
                  incomeAmount: incomeAmount,
                  expenseAmount: expenseAmount,
                ),
                const SizedBox(height: 24),
                trendsAsync.when(
                  data: (trendsData) => TrendLineChart(
                    incomeSpots: trendsData['income'] ?? [],
                    expenseSpots: trendsData['expense'] ?? [],
                    period: selectedPeriod,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Text('Error loading trends: $err'),
                ),
                const SizedBox(height: 24),
                topCategoriesAsync.when(
                  data: (categories) =>
                      _buildTopCategoriesSection(context, categories),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Text('Error loading top categories: $err'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error loading wallet summary: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildSummaryGrid(
    BuildContext context, {
    required double balance,
    required double income,
    required double expense,
    required int totalTransactions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Financial Summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
                color: const Color(0xFF2D3142),
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5, // Adjust as needed
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildSummaryCard(
              title: 'Balance',
              amount: balance,
              icon: Icons.account_balance_wallet,
              backgroundColor: ColorName.blue, // Use ColorName
              context: context,
            ),
            _buildSummaryCard(
              title: 'Income',
              amount: income,
              icon: Icons.arrow_downward,
              backgroundColor: Colors.green,
              context: context,
            ),
            _buildSummaryCard(
              title: 'Expenses',
              amount: expense,
              icon: Icons.arrow_upward,
              backgroundColor: Colors.red,
              context: context,
            ),
            _buildSummaryCard(
              title: 'Transactions',
              amount: totalTransactions.toDouble(),
              icon: Icons.receipt_long,
              backgroundColor: Colors.orange,
              isCount: true,
              context: context,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color backgroundColor,
    bool isCount = false,
    required BuildContext context,
  }) {
    // Re-using the style from the original statistics_page.dart
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              isCount ? amount.toInt().toString() : amount.toFormattedString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCategoriesSection(
      BuildContext context, List<CategorySpendingSummary> categories) {
    if (categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
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
        child: Center(
          child: Text(
            'No expense categories data for this period.',
            style: TextStyle(fontFamily: 'Nunito', color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Text(
            'Top Expense Categories',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: const Color(0xFF2D3142),
                ),
          ),
          const SizedBox(height: 16),
          ...categories
              .map((category) => TopCategoryListItem(categorySummary: category))
              .toList(),
        ],
      ),
    );
  }
}
