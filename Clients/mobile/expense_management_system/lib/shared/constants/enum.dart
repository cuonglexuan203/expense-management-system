enum TransactionPeriod {
  allTime('All Time', 'AllTime'),
  currentWeek('This Week', 'CurrentWeek'),
  currentMonth('This Month', 'CurrentMonth'),
  currentYear('This Year', 'CurrentYear');

  final String label;
  final String apiValue;
  const TransactionPeriod(this.label, this.apiValue);
}

enum TransactionType {
  none('All', null),
  expense('Expense', 'Expense'),
  income('Income', 'Income');

  final String label;
  final String? apiValue;
  const TransactionType(this.label, this.apiValue);
}

enum TransactionSort {
  desc('Newest First', 'DESC'),
  asc('Oldest First', 'ASC');

  final String label;
  final String apiValue;
  const TransactionSort(this.label, this.apiValue);
}
