import 'package:flutter_boilerplate/feature/home/state/home_state.dart';
import 'package:flutter_boilerplate/feature/wallet/model/wallet.dart';
import 'package:flutter_boilerplate/feature/wallet/provider/wallet_provider.dart';
import 'package:flutter_boilerplate/feature/wallet/repository/wallet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  bool _initialFetchDone = false;

  @override
  HomeState build() {
    ref
      ..keepAlive()
      ..listen(walletChangesProvider, (_, __) {
        refreshWallets();
      });

    if (!_initialFetchDone) {
      _initialFetchDone = true;
      Future.microtask(_fetchWallets);
    }

    return state;
  }

  Future<void> _fetchWallets() async {
    final walletRepository = ref.read(walletRepositoryProvider);
    final response = await walletRepository.getWallets();

    response.when(
      success: (wallets) {
        if (wallets.isEmpty) {
          state = const HomeState.loaded(wallets: []);
        } else {
          state = HomeState.loaded(wallets: wallets);
        }
      },
      error: (appException) {
        state = HomeState.error(appException.toString());
      },
    );
  }

  void selectWallet(int index) {
    state.maybeWhen(
      loaded: (wallets, _) async {
        if (index >= 0 && index < wallets.length) {
          state = HomeState.loaded(
            wallets: wallets,
            selectedWalletIndex: index,
          );

          final walletRepository = ref.read(walletRepositoryProvider);
          final selectedWallet = wallets[index];
          final response = await walletRepository.getWalletSummary(
              selectedWallet.id, "AllTime");

          response.when(
            success: (updatedWallet) {
              List<Wallet> updatedWallets = List.from(wallets);
              updatedWallets[index] = updatedWallet;

              state = HomeState.loaded(
                wallets: updatedWallets,
                selectedWalletIndex: index,
              );
            },
            error: (_) {},
          );
        }
      },
      orElse: () {},
    );
  }

  Future<void> updateWalletWithFilter(int walletId, String period) async {
    await state.maybeWhen(
      loaded: (wallets, selectedIndex) async {
        final selectedWallet = wallets.firstWhere((w) => w.id == walletId,
            orElse: () => wallets[selectedIndex]);

        final walletRepository = ref.read(walletRepositoryProvider);
        final response = await walletRepository.getWalletSummary(
          selectedWallet.id,
          period,
        );

        response.when(
          success: (updatedWallet) {
            final index = wallets.indexWhere((w) => w.id == walletId);
            if (index != -1) {
              List<Wallet> updatedWallets = List.from(wallets);
              updatedWallets[index] = updatedWallet;
              state = HomeState.loaded(
                wallets: updatedWallets,
                selectedWalletIndex: index,
              );
            }
          },
          error: (_) {},
        );
      },
      orElse: () {},
    );
  }

  Future<void> refreshWallets() async {
    state = const HomeState.loading();
    _fetchWallets();
  }
}
