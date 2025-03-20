import 'package:expense_management_system/feature/wallet/model/transaction_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    @JsonKey(name: 'id') required int id,
    required String name,
    @Default(0) double balance,
    String? description,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(
        fromJson: TransactionSummary.fromJson,
        toJson: _transactionSummaryToJson)
    @Default(TransactionSummary(totalAmount: 0, transactionCount: 0))
    TransactionSummary income,
    @JsonKey(
        fromJson: TransactionSummary.fromJson,
        toJson: _transactionSummaryToJson)
    @Default(TransactionSummary(totalAmount: 0, transactionCount: 0))
    TransactionSummary expense,
    String? filterPeriod,
    @Default(0.0) double balanceByPeriod,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

DateTime? _dateTimeFromJson(dynamic value) {
  if (value is String) return DateTime.parse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return null;
}

dynamic _dateTimeToJson(DateTime? date) => date?.toIso8601String();

Map<String, dynamic> _transactionSummaryToJson(TransactionSummary summary) =>
    summary.toJson();
