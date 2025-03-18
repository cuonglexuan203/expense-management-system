import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import '../model/wallet.dart';

part 'wallet_state.freezed.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState.initial() = _Initial;
  const factory WalletState.loading() = _Loading;
  const factory WalletState.success(Wallet wallet) = _Success;
  const factory WalletState.error(AppException error) = _Error;
}
