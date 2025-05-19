import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
// For ColorName

class IncomeExpensePieChart extends StatelessWidget {
  final double incomeAmount;
  final double expenseAmount;

  const IncomeExpensePieChart({
    Key? key,
    required this.incomeAmount,
    required this.expenseAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool noData = incomeAmount == 0 && expenseAmount == 0;
    final total = incomeAmount + expenseAmount;

    if (noData) {
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
            'No income/expense data for distribution.',
            style: TextStyle(fontFamily: 'Nunito', color: Colors.grey[600]),
            textAlign: TextAlign.center,
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
            'Income/Expense Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: const Color(0xFF2D3142),
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200, // Adjust height as needed
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        if (incomeAmount > 0)
                          PieChartSectionData(
                            value: incomeAmount,
                            title: total > 0
                                ? '${((incomeAmount / total) * 100).round()}%'
                                : '0%',
                            color: Colors
                                .green, // Use specific green from ColorName if available
                            radius: 60,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        if (expenseAmount > 0)
                          PieChartSectionData(
                            value: expenseAmount,
                            title: total > 0
                                ? '${((expenseAmount / total) * 100).round()}%'
                                : '0%',
                            color: Colors
                                .red, // Use specific red from ColorName if available
                            radius: 60,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (incomeAmount > 0)
                        _buildLegendItem(
                          color: Colors.green,
                          title: 'Income',
                          value: incomeAmount.toFormattedString(),
                        ),
                      if (incomeAmount > 0 && expenseAmount > 0)
                        const SizedBox(height: 16),
                      if (expenseAmount > 0)
                        _buildLegendItem(
                          color: Colors.red,
                          title: 'Expenses',
                          value: expenseAmount.toFormattedString(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
      {required Color color, required String title, required String value}) {
    // Re-using the style from the original statistics_page.dart
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito',
                  color: Color(0xFF2D3142),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
