// lib/feature/event/model/finance_payload.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_payload.freezed.dart';
part 'finance_payload.g.dart';

enum FinanceEventType {
  @JsonValue('Income')
  income,
  @JsonValue('Expense')
  expense,
}

@freezed
class FinancePayload with _$FinancePayload {
  const factory FinancePayload({
    required FinanceEventType type,
    required double amount,
    required int walletId,
    required int categoryId,
  }) = _FinancePayload;

  factory FinancePayload.fromJson(Map<String, dynamic> json) =>
      _$FinancePayloadFromJson(json);
}
