import 'package:flutter_boilerplate/feature/wallet/model/transaction_summary.dart';
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
    @Default(TransactionSummary(totalAmount: 0, transactionCount: 0))
    TransactionSummary income,
    @Default(TransactionSummary(totalAmount: 0, transactionCount: 0))
    TransactionSummary expense,
    String? filterPeriod,
    double? balanceByPeriod,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}
