import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';

class TrendLineChart extends StatelessWidget {
  final List<FlSpot> incomeSpots;
  final List<FlSpot> expenseSpots;
  final String period;
  final String chartTitle;
  final List<Color>?
      lineColors; // Example: [Colors.green] for income, [Colors.red] for expense

  const TrendLineChart({
    Key? key,
    required this.incomeSpots,
    required this.expenseSpots,
    required this.period,
    this.chartTitle = 'Transaction Flow',
    this.lineColors,
  }) : super(key: key);

  bool get _showIncomeLine {
    final incomeColor = lineColors?.firstWhere(
      (c) =>
          c == Colors.green ||
          c == const Color(0xFF00B894) ||
          c == Colors.green.shade600,
      orElse: () => Colors.green, // Default check color
    );
    return incomeSpots.isNotEmpty &&
        incomeSpots.any((s) => s.y != 0) &&
        (lineColors == null || (lineColors?.contains(incomeColor) ?? false));
  }

  bool get _showExpenseLine {
    final expenseColor = lineColors?.firstWhere(
      (c) =>
          c == Colors.red ||
          c == const Color(0xFFFF7675) ||
          c == Colors.red.shade600,
      orElse: () => Colors.red, // Default check color
    );
    return expenseSpots.isNotEmpty &&
        expenseSpots.any((s) => s.y != 0) &&
        (lineColors == null || (lineColors?.contains(expenseColor) ?? false));
  }

  @override
  Widget build(BuildContext context) {
    bool hasMeaningfulData = (_showIncomeLine &&
            (incomeSpots.length > 1 ||
                (incomeSpots.length == 1 && incomeSpots.first.y != 0))) ||
        (_showExpenseLine &&
            (expenseSpots.length > 1 ||
                (expenseSpots.length == 1 && expenseSpots.first.y != 0)));

    if (!hasMeaningfulData &&
        incomeSpots.length <= 1 &&
        expenseSpots.length <= 1) {
      return Container(
        height: 250,
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
            'No transaction data available for trend analysis in this period.',
            style: TextStyle(
                fontFamily: 'Nunito', color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 20, 16), // Adjusted padding
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
            chartTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: const Color(0xFF2D3142),
                ),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.7,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval:
                      _getDynamicInterval(true), // For Y-axis grid
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color(0xFFEAECEF),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: _getDynamicInterval(false), // For X-axis labels
                      getTitlesWidget: _bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: _leftTitleWidgets,
                      interval: _getDynamicInterval(true), // For Y-axis labels
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  if (_showIncomeLine)
                    LineChartBarData(
                      spots: incomeSpots,
                      isCurved: true,
                      color: lineColors?.firstWhere(
                              (c) =>
                                  c == Colors.green ||
                                  c == const Color(0xFF00B894) ||
                                  c == Colors.green.shade600,
                              orElse: () => Colors.green.shade600) ??
                          Colors.green.shade600,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (lineColors?.firstWhere(
                                    (c) =>
                                        c == Colors.green ||
                                        c == const Color(0xFF00B894) ||
                                        c == Colors.green.shade600,
                                    orElse: () => Colors.green.shade600) ??
                                Colors.green.shade600)
                            .withOpacity(0.15),
                      ),
                    ),
                  if (_showExpenseLine)
                    LineChartBarData(
                      spots: expenseSpots,
                      isCurved: true,
                      color: lineColors?.firstWhere(
                              (c) =>
                                  c == Colors.red ||
                                  c == const Color(0xFFFF7675) ||
                                  c == Colors.red.shade600,
                              orElse: () => Colors.red.shade600) ??
                          Colors.red.shade600,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: (lineColors?.firstWhere(
                                    (c) =>
                                        c == Colors.red ||
                                        c == const Color(0xFFFF7675) ||
                                        c == Colors.red.shade600,
                                    orElse: () => Colors.red.shade600) ??
                                Colors.red.shade600)
                            .withOpacity(0.15),
                      ),
                    ),
                ],
                minY: 0,
                maxX: _getMaxX(),
              ),
            ),
          ),
          if (_showIncomeLine || _showExpenseLine) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_showIncomeLine)
                  _buildLegendItem(
                    lineColors?.firstWhere(
                            (c) =>
                                c == Colors.green ||
                                c == const Color(0xFF00B894) ||
                                c == Colors.green.shade600,
                            orElse: () => Colors.green.shade600) ??
                        Colors.green.shade600,
                    'Income',
                  ),
                if (_showIncomeLine && _showExpenseLine)
                  const SizedBox(width: 24),
                if (_showExpenseLine)
                  _buildLegendItem(
                    lineColors?.firstWhere(
                            (c) =>
                                c == Colors.red ||
                                c == const Color(0xFFFF7675) ||
                                c == Colors.red.shade600,
                            orElse: () => Colors.red.shade600) ??
                        Colors.red.shade600,
                    'Expenses',
                  ),
              ],
            ),
          ]
        ],
      ),
    );
  }

  double _getMaxX() {
    double maxIncomeX = incomeSpots.isNotEmpty
        ? incomeSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b)
        : 0;
    double maxExpenseX = expenseSpots.isNotEmpty
        ? expenseSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b)
        : 0;
    double maxX = maxIncomeX > maxExpenseX ? maxIncomeX : maxExpenseX;
    return maxX < 1 && (incomeSpots.isNotEmpty || expenseSpots.isNotEmpty)
        ? 1
        : maxX;
  }

  Widget _buildLegendItem(Color color, String title) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontFamily: 'Nunito',
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  double _getDynamicInterval(bool isYAxis) {
    if (isYAxis) {
      double maxAmount = 0;
      if (_showIncomeLine) {
        maxAmount = incomeSpots
            .map((s) => s.y)
            .fold(maxAmount, (prev, val) => val > prev ? val : prev);
      }
      if (_showExpenseLine) {
        maxAmount = expenseSpots
            .map((s) => s.y)
            .fold(maxAmount, (prev, val) => val > prev ? val : prev);
      }
      if (maxAmount == 0) return 1000; // Default if no data or all data is 0
      if (maxAmount < 10) return 2;
      if (maxAmount < 50) return 10;
      if (maxAmount < 100) return 20;
      if (maxAmount < 500) return 100;
      if (maxAmount < 1000) return 200;
      if (maxAmount < 5000) return 1000;
      if (maxAmount < 10000) return 2000;
      if (maxAmount < 50000) return 10000;
      return (maxAmount / 5)
          .ceilToDouble(); // Aim for about 5 grid lines/labels
    } else {
      // X-axis
      int totalSpots = (_showIncomeLine ? incomeSpots.length : 0) >
              (_showExpenseLine ? expenseSpots.length : 0)
          ? (_showIncomeLine ? incomeSpots.length : 0)
          : (_showExpenseLine ? expenseSpots.length : 0);
      if (totalSpots <= 1) return 1;

      switch (period) {
        case 'Week':
          return totalSpots > 5 ? 2 : 1; // Max 7 spots, label every 1 or 2
        case 'Month':
          return (totalSpots / (totalSpots > 15 ? 7 : 5))
              .ceilToDouble(); // Aim for 5-7 labels
        case 'Quarter':
        case 'Year':
        case 'AllTime':
          return (totalSpots / 6).ceilToDouble(); // Aim for ~6 labels
        default:
          return (totalSpots / 5).ceilToDouble();
      }
    }
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    if (value == meta.max && meta.max == meta.min)
      return Container(); // Avoid label if only one value (0)
    if (value == meta.min && period != 'AllTime' && meta.max > meta.min)
      return Container();

    return SideTitleWidget(
      meta: meta,
      space: 6,
      child: Text(
        value.toFormattedString(),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 10,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    String text = '';
    final now = DateTime.now();
    // This is a simplified date range for labeling, actual data points determine the indices
    final dateRange = _getDateRangeFromPeriod(period, now);
    DateTime startDate = dateRange['startDate']!;
    int spotIndex = value.toInt();

    if (spotIndex < 0) return Container();

    try {
      switch (period) {
        case 'Week': // value is day index (0-6)
          if (spotIndex < 7) {
            DateTime day = startDate.add(Duration(days: spotIndex));
            text = DateFormat('E').format(day); // Mon
          }
          break;
        case 'Month': // value is day index (0-~29)
          DateTime day = startDate.add(Duration(days: spotIndex));
          text = DateFormat('d').format(day); // 1, 5, 10
          break;
        case 'Quarter':
        case 'Year':
        case 'AllTime': // value is month index for these longer periods in provider
          DateTime currentLabelMonth;
          // If startDate is e.g. Jan 1, 2023:
          // spotIndex 0 = Jan, spotIndex 1 = Feb
          int year = startDate.year;
          int month = startDate.month + spotIndex;
          // Adjust year and month if month overflows
          year += (month - 1) ~/ 12;
          month = (month - 1) % 12 + 1;
          currentLabelMonth = DateTime(year, month, 1);
          text = DateFormat('MMM').format(currentLabelMonth); // Jan, Feb
          break;
        default:
          text = (value + 1).toInt().toString();
      }
    } catch (e) {
      text = spotIndex.toString();
    }

    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 10,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }

  Map<String, DateTime> _getDateRangeFromPeriod(String period, DateTime now) {
    DateTime startDate;
    DateTime endDate = now;
    switch (period) {
      case 'Week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        endDate = startDate.add(const Duration(days: 6));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(now.year, now.month + 1, 0);
        break;
      case 'Quarter':
        int currentQuarter = ((now.month - 1) / 3).floor() + 1;
        startDate = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        endDate = DateTime(now.year, startDate.month + 3, 0);
        break;
      case 'Year':
        startDate = DateTime(now.year, 1, 1);
        endDate = DateTime(now.year, 12, 31);
        break;
      case 'AllTime':
      default:
        // For 'AllTime', the provider logic determines the actual start date for data.
        // For labeling, we might need a hint or use a default.
        // The provider's `transactionTrends` uses DateTime(1970) if not specified,
        // but for labels, it's better to infer from data if possible, or use a recent range.
        // Here, we'll assume the provider's spots are indexed from a meaningful start for 'AllTime'.
        // Let's try to make startDate sensitive to the data span if 'AllTime'.
        // This is tricky because spots are just indices.
        // A pragmatic approach for labels for 'AllTime' might be to assume spots are months.
        int maxSpots = 0;
        if (incomeSpots.isNotEmpty) maxSpots = incomeSpots.length;
        if (expenseSpots.isNotEmpty && expenseSpots.length > maxSpots)
          maxSpots = expenseSpots.length;

        if (period == 'AllTime' && maxSpots > 0) {
          // Assume spots are months, count back from 'now'
          int yearsAgo = (maxSpots / 12).ceil();
          startDate = DateTime(now.year - yearsAgo, now.month, 1);
        } else {
          // Default for other cases or if no spots
          startDate = DateTime(now.year, 1, 1);
        }
        endDate = now;
        break;
    }
    if (endDate.isBefore(startDate) && period != 'AllTime') {
      endDate = startDate.add(Duration(days: period == 'Week' ? 6 : 30));
    }
    return {'startDate': startDate, 'endDate': endDate};
  }
}
