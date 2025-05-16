// // statistics_service.dart

// import 'package:expense_management_system/feature/statistic/model/statistic_model.dart';
// import 'package:expense_management_system/feature/transaction/model/transaction.dart';
// import 'package:expense_management_system/feature/wallet/model/transaction_summary.dart';

// class StatisticsService {
//   // Calculate summary statistics
//   TransactionSummary calculateSummary(
//       List<Transaction> transactions, StatisticsPeriod period) {
//     // Filter transactions by period
//     final filteredTransactions = _filterByPeriod(transactions, period);

//     // Calculate totals
//     final totalIncome = _calculateTotal(filteredTransactions, 'Income');
//     final totalExpense = _calculateTotal(filteredTransactions, 'Expense');
//     final balance = totalIncome - totalExpense;

//     // Get category breakdown
//     final categoryBreakdown = _getCategoryBreakdown(filteredTransactions);

//     // Get daily data for charts
//     final dailyData = _getDailyData(filteredTransactions, period);

//     return TransactionSummary(
//       totalIncome: totalIncome,
//       totalExpense: totalExpense,
//       balance: balance,
//       topCategories: categoryBreakdown,
//       dailyData: dailyData,
//     );
//   }

//   // Filter transactions by period
//   List<Transaction> _filterByPeriod(
//       List<Transaction> transactions, StatisticsPeriod period) {
//     if (period.startDate == null || period.endDate == null) {
//       return transactions; // All time
//     }

//     return transactions.where((t) {
//       return t.occurredAt.isAfter(period.startDate!) &&
//           t.occurredAt.isBefore(period.endDate!.add(const Duration(days: 1)));
//     }).toList();
//   }

//   // Calculate total for a type
//   double _calculateTotal(List<Transaction> transactions, String type) {
//     return transactions
//         .where((t) => t.type == type)
//         .fold(0, (sum, t) => sum + t.amount);
//   }

//   // Get category breakdown
//   List<CategorySummary> _getCategoryBreakdown(List<Transaction> transactions) {
//     // Group transactions by category
//     final Map<String, double> categoryTotals = {};

//     for (var t in transactions) {
//       if (t.type == 'Expense') {
//         // Only for expenses
//         final category = t.categoryName ?? 'Uncategorized';
//         categoryTotals[category] = (categoryTotals[category] ?? 0) + t.amount;
//       }
//     }

//     // Calculate total expenses
//     final totalExpense =
//         categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);

//     // Convert to list of CategorySummary
//     final categoryList = categoryTotals.entries.map((entry) {
//       return CategorySummary(
//         name: entry.key,
//         amount: entry.value,
//         percentage: totalExpense > 0 ? (entry.value / totalExpense) * 100 : 0,
//       );
//     }).toList();

//     // Sort by amount descending
//     categoryList.sort((a, b) => b.amount.compareTo(a.amount));

//     // Return top categories (limit to 5)
//     return categoryList.take(5).toList();
//   }

//   // Get daily data for charts
//   List<DailySummary> _getDailyData(
//       List<Transaction> transactions, StatisticsPeriod period) {
//     if (transactions.isEmpty) return [];

//     // Determine start and end dates
//     final DateTime startDate = period.startDate ??
//         transactions
//             .map((t) => t.occurredAt)
//             .reduce((a, b) => a.isBefore(b) ? a : b);
//     final DateTime endDate = period.endDate ?? DateTime.now();

//     // Create map of dates
//     final Map<DateTime, DailySummary> dailyMap = {};

//     // Initialize map with dates
//     for (var d = startDate;
//         d.isBefore(endDate.add(const Duration(days: 1)));
//         d = d.add(const Duration(days: 1))) {
//       final dateKey = DateTime(d.year, d.month, d.day);
//       dailyMap[dateKey] = DailySummary(
//         date: dateKey,
//         income: 0,
//         expense: 0,
//       );
//     }

//     // Populate with transaction data
//     for (var t in transactions) {
//       final dateKey =
//           DateTime(t.occurredAt.year, t.occurredAt.month, t.occurredAt.day);

//       final existing = dailyMap[dateKey];
//       if (existing != null) {
//         if (t.type == 'Income') {
//           dailyMap[dateKey] = DailySummary(
//             date: existing.date,
//             income: existing.income + t.amount,
//             expense: existing.expense,
//           );
//         } else {
//           dailyMap[dateKey] = DailySummary(
//             date: existing.date,
//             income: existing.income,
//             expense: existing.expense + t.amount,
//           );
//         }
//       }
//     }

//     // Convert to sorted list
//     final dailyList = dailyMap.values.toList();
//     dailyList.sort((a, b) => a.date.compareTo(b.date));

//     return dailyList;
//   }
// }
