import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_spending_summary.freezed.dart';
part 'category_spending_summary.g.dart';

@freezed
class CategorySpendingSummary with _$CategorySpendingSummary {
  const factory CategorySpendingSummary({
    required String categoryName,
    required double totalAmount,
    required double percentage,
    // IconData? icon, // Optional: Icon for the category
    // Color? color, // Optional: Color for the category
  }) = _CategorySpendingSummary;

  factory CategorySpendingSummary.fromJson(Map<String, dynamic> json) =>
      _$CategorySpendingSummaryFromJson(json);
}
