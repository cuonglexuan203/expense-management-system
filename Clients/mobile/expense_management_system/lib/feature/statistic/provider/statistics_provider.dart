import 'package:expense_management_system/feature/statistic/model/category_spending_summary.dart';
import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/feature/transaction/repository/transaction_repository.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_provider.g.dart';

// Helper to determine date range based on period string
Map<String, DateTime> _getDateRangeFromPeriod(
    String periodApiValue, DateTime now) {
  DateTime startDate;
  DateTime endDate = now;

  if (periodApiValue == TransactionPeriod.currentWeek.apiValue) {
    startDate = now.subtract(Duration(days: now.weekday - 1)); // Monday
    endDate = startDate.add(const Duration(days: 6)); // Sunday
  } else if (periodApiValue == TransactionPeriod.currentMonth.apiValue) {
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0); // Last day of current month
  } else if (periodApiValue == TransactionPeriod.currentYear.apiValue) {
    startDate = DateTime(now.year, 1, 1);
    endDate = DateTime(now.year, 12, 31);
  } else if (periodApiValue == TransactionPeriod.allTime.apiValue) {
    startDate = DateTime(2020); // A very early date for "all time" start
    endDate = now;
  } else {
    // Fallback for any unknown periodApiValue, though this shouldn't happen with enum usage
    print(
        "Unknown periodApiValue in _getDateRangeFromPeriod: $periodApiValue, defaulting to AllTime range");
    startDate = DateTime(2020);
    endDate = now;
  }
  return {'startDate': startDate, 'endDate': endDate};
}

// @riverpod
// Future<Map<String, List<FlSpot>>> transactionTrends(
//   TransactionTrendsRef ref, {
//   required int walletId,
//   required String period, // This 'period' is the apiValue
// }) async {
//   final transactionRepo = ref.watch(transactionRepositoryProvider);
//   final now = DateTime.now();
//   // Use the _getDateRangeFromPeriod that accepts apiValue
//   final dateRange = _getDateRangeFromPeriod(period, now);

//   // Fetch all transactions using the new helper
//   final List<Transaction> transactions =
//       await _fetchAllTransactionsWithPagination(
//     transactionRepo,
//     walletId: walletId,
//     periodApiValue: period,
//     // Pass fromDate and toDate for the repository if it uses them for filtering
//     // For 'AllTime', fromDate/toDate might be null if the periodApiValue itself handles it.
//     // fromDate: period == TransactionPeriod.allTime.apiValue
//     //     ? null
//     //     : dateRange['startDate'],
//     // toDate: period == TransactionPeriod.allTime.apiValue
//     //     ? null
//     //     : dateRange['endDate'],
//     sort: 'ASC', // Sort by date ascending for trend processing
//   );

//   Map<DateTime, double> dailyIncome = {};
//   Map<DateTime, double> dailyExpenses = {};

//   for (var t in transactions) {
//     DateTime keyDate;
//     // Grouping logic based on the apiValue
//     if (period == TransactionPeriod.currentWeek.apiValue ||
//         period == TransactionPeriod.currentMonth.apiValue) {
//       keyDate =
//           DateTime(t.occurredAt.year, t.occurredAt.month, t.occurredAt.day);
//     } else if (period == TransactionPeriod.currentYear.apiValue ||
//         period == TransactionPeriod.allTime.apiValue) {
//       keyDate = DateTime(t.occurredAt.year, t.occurredAt.month, 1);
//     } else {
//       keyDate =
//           DateTime(t.occurredAt.year, t.occurredAt.month, t.occurredAt.day);
//     }

//     if (t.type == 'Income') {
//       dailyIncome[keyDate] = (dailyIncome[keyDate] ?? 0) + t.amount;
//     } else if (t.type == 'Expense') {
//       dailyExpenses[keyDate] = (dailyExpenses[keyDate] ?? 0) + t.amount;
//     }
//   }

//   List<FlSpot> incomeSpots = [];
//   List<FlSpot> expenseSpots = [];
//   DateTime currentDate = dateRange['startDate']!;
//   final DateTime loopEndDate = dateRange['endDate']!;
//   int index = 0;

//   if (period == TransactionPeriod.currentWeek.apiValue ||
//       period == TransactionPeriod.currentMonth.apiValue) {
//     while (currentDate.isBefore(loopEndDate) ||
//         currentDate.isAtSameMomentAs(loopEndDate)) {
//       final dayKey =
//           DateTime(currentDate.year, currentDate.month, currentDate.day);
//       incomeSpots.add(FlSpot(index.toDouble(), dailyIncome[dayKey] ?? 0));
//       expenseSpots.add(FlSpot(index.toDouble(), dailyExpenses[dayKey] ?? 0));
//       currentDate = currentDate.add(const Duration(days: 1));
//       index++;
//     }
//   } else if (period == TransactionPeriod.currentYear.apiValue ||
//       period == TransactionPeriod.allTime.apiValue) {
//     currentDate = DateTime(
//         dateRange['startDate']!.year, dateRange['startDate']!.month, 1);
//     while (currentDate.isBefore(loopEndDate) ||
//         currentDate.isAtSameMomentAs(loopEndDate)) {
//       final monthKey = DateTime(currentDate.year, currentDate.month, 1);
//       incomeSpots.add(FlSpot(index.toDouble(), dailyIncome[monthKey] ?? 0));
//       expenseSpots.add(FlSpot(index.toDouble(), dailyExpenses[monthKey] ?? 0));

//       if (currentDate.month == 12) {
//         currentDate = DateTime(currentDate.year + 1, 1, 1);
//       } else {
//         currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
//       }
//       index++;
//       if (period == TransactionPeriod.allTime.apiValue && index > 60)
//         break; // Limit for AllTime
//     }
//   }

//   if (incomeSpots.isEmpty) incomeSpots.add(const FlSpot(0, 0));
//   if (expenseSpots.isEmpty) expenseSpots.add(const FlSpot(0, 0));

//   return {'income': incomeSpots, 'expense': expenseSpots};
// }

Future<List<Transaction>> _fetchAllTransactionsWithPagination(
  TransactionRepository repo, {
  required int walletId,
  String? type,
  required String periodApiValue,
  DateTime? fromDate, // Explicit fromDate for the repository call
  DateTime? toDate, // Explicit toDate for the repository call
  String sort = 'ASC',
}) async {
  List<Transaction> allTransactions = [];
  int currentPage = 1;
  bool hasMorePages = true;
  const int pageSize = 10; // Page size as requested

  while (hasMorePages) {
    final response = await repo.getTransactionsByWalletPaginated(
      walletId,
      pageNumber: currentPage,
      pageSize: pageSize,
      type: type,
      period: periodApiValue, // Pass the periodApiValue
      // fromDate: fromDate, // Pass the determined fromDate
      // toDate: toDate, // Pass the determined toDate
      sort: sort,
    );

    response.when(
      success: (paginatedData) {
        allTransactions.addAll(paginatedData.items);
        // Use hasNextPage from paginationInfo to determine if there are more pages
        if (paginatedData.paginationInfo.hasNextPage &&
            paginatedData.items.isNotEmpty) {
          currentPage++;
        } else {
          hasMorePages = false;
        }
      },
      error: (e) {
        print(
            "Error fetching page $currentPage for transactions (statistics): $e");
        // Optionally, rethrow or handle error appropriately
        hasMorePages = false; // Stop fetching on error
        throw Exception("Failed to fetch all transactions for statistics: $e");
      },
    );
  }
  return allTransactions;
}

// statistics_provider.dart

@riverpod
Future<Map<String, List<FlSpot>>> transactionTrends(
  TransactionTrendsRef ref, {
  required int walletId,
  required String period, // This 'period' is the apiValue
}) async {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final now = DateTime.now();
  final dateRange = _getDateRangeFromPeriod(
      period, now); // startDate cho AllTime là DateTime(2020)

  final List<Transaction> transactions =
      await _fetchAllTransactionsWithPagination(
    transactionRepo,
    walletId: walletId,
    periodApiValue: period,
    // fromDate và toDate nên được truyền nếu backend hỗ trợ lọc theo khoảng ngày chính xác
    // fromDate: period == TransactionPeriod.allTime.apiValue ? null : dateRange['startDate'],
    // toDate: period == TransactionPeriod.allTime.apiValue ? null : dateRange['endDate'],
    sort: 'ASC',
  );

  if (transactions.isEmpty) {
    // Nếu không có giao dịch nào cả, trả về spots rỗng (sẽ được TrendLineChart xử lý)
    return {
      'income': [const FlSpot(0, 0)],
      'expense': [const FlSpot(0, 0)],
    };
  }

  Map<DateTime, double> monthlyIncome = {};
  Map<DateTime, double> monthlyExpenses = {};
  Map<DateTime, double> dailyIncomeForShortPeriods = {};
  Map<DateTime, double> dailyExpensesForShortPeriods = {};

  // Xác định ngày bắt đầu và kết thúc thực tế từ dữ liệu giao dịch cho "AllTime"
  DateTime actualStartDate = transactions.first.occurredAt;
  DateTime actualEndDate = transactions.last.occurredAt;

  for (var t in transactions) {
    if (t.occurredAt.isBefore(actualStartDate)) actualStartDate = t.occurredAt;
    if (t.occurredAt.isAfter(actualEndDate)) actualEndDate = t.occurredAt;

    if (period == TransactionPeriod.currentWeek.apiValue ||
        period == TransactionPeriod.currentMonth.apiValue) {
      final keyDate =
          DateTime(t.occurredAt.year, t.occurredAt.month, t.occurredAt.day);
      if (t.type == 'Income') {
        dailyIncomeForShortPeriods[keyDate] =
            (dailyIncomeForShortPeriods[keyDate] ?? 0) + t.amount;
      } else if (t.type == 'Expense') {
        dailyExpensesForShortPeriods[keyDate] =
            (dailyExpensesForShortPeriods[keyDate] ?? 0) + t.amount;
      }
    } else {
      // For Year and AllTime, group by month
      final keyDate = DateTime(t.occurredAt.year, t.occurredAt.month, 1);
      if (t.type == 'Income') {
        monthlyIncome[keyDate] = (monthlyIncome[keyDate] ?? 0) + t.amount;
      } else if (t.type == 'Expense') {
        monthlyExpenses[keyDate] = (monthlyExpenses[keyDate] ?? 0) + t.amount;
      }
    }
  }

  List<FlSpot> incomeSpots = [];
  List<FlSpot> expenseSpots = [];
  int index = 0;

  if (period == TransactionPeriod.currentWeek.apiValue ||
      period == TransactionPeriod.currentMonth.apiValue) {
    DateTime currentDate =
        dateRange['startDate']!; // Sử dụng dateRange từ period selector
    final DateTime loopEndDate = dateRange['endDate']!;
    while (currentDate.isBefore(loopEndDate) ||
        currentDate.isAtSameMomentAs(loopEndDate)) {
      final dayKey =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      incomeSpots.add(
          FlSpot(index.toDouble(), dailyIncomeForShortPeriods[dayKey] ?? 0));
      expenseSpots.add(
          FlSpot(index.toDouble(), dailyExpensesForShortPeriods[dayKey] ?? 0));
      currentDate = currentDate.add(const Duration(days: 1));
      index++;
    }
  } else {
    // For Year and AllTime
    // Điều chỉnh startDate cho vòng lặp dựa trên dữ liệu thực tế hoặc một khoảng thời gian hợp lý
    DateTime loopStartDate;
    DateTime loopActualEndDate = DateTime(actualEndDate.year,
        actualEndDate.month, 1); // Tháng cuối cùng có dữ liệu

    if (period == TransactionPeriod.allTime.apiValue) {
      // Hiển thị tối đa 60 tháng gần nhất có dữ liệu, hoặc từ tháng đầu tiên có dữ liệu nếu ít hơn 60 tháng
      DateTime sixtyMonthsAgo = DateTime(loopActualEndDate.year,
          loopActualEndDate.month - 59, 1); // 60 tháng bao gồm tháng hiện tại
      DateTime firstTransactionMonth =
          DateTime(actualStartDate.year, actualStartDate.month, 1);
      loopStartDate = sixtyMonthsAgo.isAfter(firstTransactionMonth)
          ? sixtyMonthsAgo
          : firstTransactionMonth;
    } else {
      // For Year
      loopStartDate = DateTime(
          dateRange['startDate']!.year, dateRange['startDate']!.month, 1);
    }

    DateTime currentDate = loopStartDate;
    while (currentDate.isBefore(loopActualEndDate) ||
        currentDate.isAtSameMomentAs(loopActualEndDate)) {
      final monthKey = DateTime(currentDate.year, currentDate.month, 1);
      incomeSpots.add(FlSpot(index.toDouble(), monthlyIncome[monthKey] ?? 0));
      expenseSpots
          .add(FlSpot(index.toDouble(), monthlyExpenses[monthKey] ?? 0));

      if (currentDate.month == 12) {
        currentDate = DateTime(currentDate.year + 1, 1, 1);
      } else {
        currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
      }
      index++;
      // Không cần break sớm nữa nếu loopStartDate và loopActualEndDate đã hợp lý
    }
  }

  if (incomeSpots.isEmpty) incomeSpots.add(const FlSpot(0, 0));
  if (expenseSpots.isEmpty) expenseSpots.add(const FlSpot(0, 0));

  return {'income': incomeSpots, 'expense': expenseSpots};
}

@riverpod
Future<List<CategorySpendingSummary>> topExpenseCategories(
  TopExpenseCategoriesRef ref, {
  required int walletId,
  required String period, // This 'period' is the apiValue
}) async {
  final transactionRepo = ref.watch(transactionRepositoryProvider);
  final now = DateTime.now();
  // Use the _getDateRangeFromPeriod that accepts apiValue
  final dateRange = _getDateRangeFromPeriod(period, now);

  // Fetch all expense transactions using the new helper
  final List<Transaction> expenseTransactions =
      await _fetchAllTransactionsWithPagination(
    transactionRepo,
    walletId: walletId,
    type: 'Expense',
    periodApiValue: period,
    // fromDate: period == TransactionPeriod.allTime.apiValue
    //     ? null
    //     : dateRange['startDate'],
    // toDate: period == TransactionPeriod.allTime.apiValue
    //     ? null
    //     : dateRange['endDate'],
    // sort is not strictly needed for category sum, but default 'ASC' is fine
  );

  if (expenseTransactions.isEmpty) {
    return [];
  }

  final totalExpenseAmount =
      expenseTransactions.fold<double>(0, (sum, item) => sum + item.amount);
  if (totalExpenseAmount == 0) {
    return [];
  }

  final Map<String, double> categoryTotals = {};
  for (var transaction in expenseTransactions) {
    final category = transaction.categoryName ?? 'Uncategorized';
    categoryTotals[category] =
        (categoryTotals[category] ?? 0) + transaction.amount;
  }

  var sortedCategories = categoryTotals.entries
      .map((entry) => CategorySpendingSummary(
            categoryName: entry.key,
            totalAmount: entry.value,
            percentage: (entry.value / totalExpenseAmount) * 100,
            // icon: _getIconForCategory(entry.key), // Keep or remove as per your design
            // color: _getColorForCategory(entry.key), // Keep or remove
          ))
      .toList();

  sortedCategories.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

  return sortedCategories.take(5).toList();
}
