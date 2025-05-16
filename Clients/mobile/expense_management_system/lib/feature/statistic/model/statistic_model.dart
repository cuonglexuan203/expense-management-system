// // statistics_models.dart

// class TransactionSummary {
//   final double totalIncome;
//   final double totalExpense;
//   final double balance;
//   final List<CategorySummary> topCategories;
//   final List<DailySummary> dailyData;

//   TransactionSummary({
//     required this.totalIncome,
//     required this.totalExpense,
//     required this.balance,
//     required this.topCategories,
//     required this.dailyData,
//   });
// }

// class CategorySummary {
//   final String name;
//   final double amount;
//   final double percentage;

//   CategorySummary({
//     required this.name,
//     required this.amount,
//     required this.percentage,
//   });
// }

// class DailySummary {
//   final DateTime date;
//   final double income;
//   final double expense;

//   DailySummary({
//     required this.date,
//     required this.income,
//     required this.expense,
//   });
// }

// class StatisticsPeriod {
//   final String label;
//   final String value;
//   final DateTime? startDate;
//   final DateTime? endDate;

//   StatisticsPeriod({
//     required this.label,
//     required this.value,
//     this.startDate,
//     this.endDate,
//   });

//   static List<StatisticsPeriod> getPeriods() {
//     final now = DateTime.now();
//     return [
//       StatisticsPeriod(
//         label: 'This Week',
//         value: 'week',
//         startDate: DateTime(now.year, now.month, now.day - now.weekday + 1),
//         endDate: now,
//       ),
//       StatisticsPeriod(
//         label: 'This Month',
//         value: 'month',
//         startDate: DateTime(now.year, now.month, 1),
//         endDate: now,
//       ),
//       StatisticsPeriod(
//         label: 'This Year',
//         value: 'year',
//         startDate: DateTime(now.year, 1, 1),
//         endDate: now,
//       ),
//       StatisticsPeriod(
//         label: 'All Time',
//         value: 'all',
//       ),
//       // Add custom period option
//     ];
//   }
// }
