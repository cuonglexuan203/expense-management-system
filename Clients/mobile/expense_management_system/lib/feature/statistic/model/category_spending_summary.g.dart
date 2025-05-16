// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_spending_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategorySpendingSummaryImpl _$$CategorySpendingSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$CategorySpendingSummaryImpl(
      categoryName: json['categoryName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$CategorySpendingSummaryImplToJson(
        _$CategorySpendingSummaryImpl instance) =>
    <String, dynamic>{
      'categoryName': instance.categoryName,
      'totalAmount': instance.totalAmount,
      'percentage': instance.percentage,
    };
