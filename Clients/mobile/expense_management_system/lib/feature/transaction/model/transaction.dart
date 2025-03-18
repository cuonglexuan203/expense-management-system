import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required String name,
    required int walletId,
    String? walletName,
    String? categoryName,
    @JsonKey(fromJson: _amountFromJson) required double amount,
    String? description,
    required String type,
    required DateTime occurredAt,
    DateTime? createdAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

double _amountFromJson(dynamic value) {
  if (value == null) return 0.0;
  return (value as num).toDouble();
}
