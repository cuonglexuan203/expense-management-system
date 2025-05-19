import 'package:expense_management_system/feature/statistic/model/category_spending_summary.dart'; // Path from your provided file
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
// import 'package:expense_management_system/gen/colors.gen.dart'; // If specific ColorName colors are needed

class TopCategoryListItem extends StatelessWidget {
  final CategorySpendingSummary categorySummary;

  const TopCategoryListItem({
    Key? key,
    required this.categorySummary,
  }) : super(key: key);

  // Helper to get a placeholder icon and color based on category name
  // This should ideally be more sophisticated or data-driven from your backend/assets
  IconData _getIconForCategory(String categoryName) {
    final nameLower = categoryName.toLowerCase();
    if (nameLower.contains('food') || nameLower.contains('restaurant'))
      return Icons.restaurant_outlined;
    if (nameLower.contains('transport') || nameLower.contains('travel'))
      return Icons.directions_car_filled_outlined;
    if (nameLower.contains('shopping') || nameLower.contains('cloth'))
      return Icons.shopping_bag_outlined;
    if (nameLower.contains('utilit') || nameLower.contains('bill'))
      return Icons.receipt_long_outlined;
    if (nameLower.contains('health') || nameLower.contains('medical'))
      return Icons.medical_services_outlined;
    if (nameLower.contains('entertain')) return Icons.movie_outlined;
    if (nameLower.contains('grocer')) return Icons.local_grocery_store_outlined;
    if (nameLower.contains('home') || nameLower.contains('rent'))
      return Icons.home_outlined;
    if (nameLower.contains('education')) return Icons.school_outlined;
    return Icons.category_outlined; // Default icon
  }

  Color _getColorForCategory(String categoryName) {
    final nameLower = categoryName.toLowerCase();
    // Assign specific colors or use a hashing mechanism for more variety
    if (nameLower.contains('food')) return Colors.orange.shade700;
    if (nameLower.contains('transport')) return Colors.blue.shade700;
    if (nameLower.contains('shopping')) return Colors.purple.shade700;
    if (nameLower.contains('utilit')) return Colors.teal.shade700;
    if (nameLower.contains('health')) return Colors.redAccent.shade700;
    if (nameLower.contains('entertain')) return Colors.indigo.shade700;
    if (nameLower.contains('grocer')) return Colors.green.shade700;
    if (nameLower.contains('home')) return Colors.brown.shade700;
    if (nameLower.contains('education')) return Colors.cyan.shade700;

    // Fallback color generation based on hash
    final hash = categoryName.hashCode;
    return Color((hash & 0x007F7F7F) | 0xFF808080)
        .withOpacity(1.0); // Ensure some brightness
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIconForCategory(categorySummary.categoryName);
    final color = _getColorForCategory(categorySummary.categoryName);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categorySummary.categoryName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Nunito',
                    color: Color(0xFF2D3142),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  categorySummary.totalAmount.toFormattedString(),
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Nunito',
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${categorySummary.percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 60, // Fixed width for the progress bar
                height: 6,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: categorySummary.percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
