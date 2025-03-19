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
    @Default(0) double balanceByPeriod,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

Map<String, dynamic> _transactionSummaryToJson(TransactionSummary summary) =>
    summary.toJson();
