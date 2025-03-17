import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/wallet_repository.dart';
import '../state/wallet_state.dart';
import '../model/wallet.dart';

part 'wallet_provider.g.dart';

// Filter parameters class for wallet summary
class FilterParams {
  final int walletId;
  final String period;

  FilterParams({required this.walletId, required this.period});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterParams &&
          runtimeType == other.runtimeType &&
          walletId == other.walletId &&
          period == other.period;

  @override
  int get hashCode => walletId.hashCode ^ period.hashCode;
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
  // Listen for wallet changes to refresh when transactions are added/modified
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
