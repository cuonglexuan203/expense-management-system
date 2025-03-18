import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = _Loading;

  const factory HomeState.loaded({
    required List<Wallet> wallets,
    @Default(0) int selectedWalletIndex,
  }) = _Loaded;

  const factory HomeState.error(String message) = _Error;
}
