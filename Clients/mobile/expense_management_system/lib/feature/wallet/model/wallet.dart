import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required int id,
    required String name,
    @Default(0) double balance,
    String? description,
    DateTime? createdAt,
    double? income,
    double? expense,
    String? filterPeriod,
    double? balanceByPeriod,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}
