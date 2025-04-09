import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/wallet_repository.dart';
import '../state/wallet_state.dart';
import '../model/wallet.dart';

part 'wallet_provider.g.dart';

// Filter parameters class for wallet summary
class FilterParams {
  final int walletId;
  final String period;
  final DateTime? fromDate;
  final DateTime? toDate;

  FilterParams({
    required this.walletId,
    required this.period,
    this.fromDate,
    this.toDate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterParams &&
          runtimeType == other.runtimeType &&
          walletId == other.walletId &&
          period == other.period &&
          fromDate == other.fromDate &&
          toDate == other.toDate;

  @override
  int get hashCode => Object.hash(walletId, period, fromDate, toDate);
}

@riverpod
class WalletChanges extends _$WalletChanges {
  @override
  int build() => 0;

  void notifyChanges() {
    state = state + 1;
  }
}

@riverpod
class WalletNotifier extends _$WalletNotifier {
  late final WalletRepository _repository = ref.read(walletRepositoryProvider);

  @override
  WalletState build() {
    return const WalletState.initial();
  }

  Future<void> createWallet(String name, double balance,
      {String? description}) async {
    state = const WalletState.loading();
    final response =
        await _repository.createWallet(name, balance, description: description);

    state = response.when(
      success: (wallet) {
        ref.read(walletChangesProvider.notifier).notifyChanges();
        return WalletState.success(wallet);
      },
      error: (error) => WalletState.error(error),
    );
  }
}

@riverpod
class WalletDetailNotifier extends _$WalletDetailNotifier {
  late final WalletRepository _repository = ref.read(walletRepositoryProvider);

  @override
  WalletState build(int walletId) {
    _fetchWalletById(walletId);
    return const WalletState.loading();
  }

  Future<void> _fetchWalletById(int id) async {
    state = const WalletState.loading();
    final response = await _repository.getWalletById(id);

    state = response.when(
      success: (wallet) => WalletState.success(wallet),
      error: (error) => WalletState.error(error),
    );
  }
}

// New provider that returns filtered wallet data with proper income/expense totals
@riverpod
Future<Wallet> filteredWallet(
    FilteredWalletRef ref, FilterParams params) async {
  ref.listen(walletChangesProvider, (_, __) {
    ref.invalidateSelf();
  });

  final repository = ref.read(walletRepositoryProvider);
  final response = await repository.getWalletSummary(
    params.walletId,
    params.period,
  );

  return response.when(
    success: (wallet) => wallet,
    error: (error) => throw error,
  );
}
