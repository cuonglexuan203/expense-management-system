import 'package:expense_management_system/feature/chat/model/extracted_transaction.dart';
import 'package:expense_management_system/feature/chat/repository/chat_repository.dart';
import 'package:expense_management_system/feature/notification/state/transaction_suggestion_state.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/repository/wallet_repository.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionSuggestionProvider = StateNotifierProvider.autoDispose
    .family<TransactionSuggestionNotifier, TransactionSuggestionState, int>(
        (ref, notificationId) {
  return TransactionSuggestionNotifier(
    ref.read(chatRepositoryProvider),
    ref.read(walletRepositoryProvider),
    notificationId,
  );
});

class TransactionSuggestionNotifier
    extends StateNotifier<TransactionSuggestionState> {
  final ChatRepository _transactionRepo;
  final WalletRepository _walletRepo;
  final int _notificationId;

  TransactionSuggestionNotifier(
      this._transactionRepo, this._walletRepo, this._notificationId)
      : super(const TransactionSuggestionState.initial()) {
    fetchData();
  }

  Future<void> fetchData() async {
    state = const TransactionSuggestionState.loading();
    try {
      final transactionResponseFuture = _transactionRepo
          .getExtractedTransactionsByNotificationId(_notificationId);
      final walletResponseFuture = _walletRepo.getWallets();

      final results =
          await Future.wait([transactionResponseFuture, walletResponseFuture]);

      final transactionResponse =
          results[0] as APIResponse<List<ExtractedTransaction>>;
      final walletResponse = results[1] as APIResponse<List<Wallet>>;

      List<ExtractedTransaction> transactions = [];
      List<Wallet> wallets = [];
      String? errorMsg;

      transactionResponse.when(
        success: (data) => transactions = data,
        error: (err) => errorMsg = 'Failed to load transactions: ${err}',
      );

      if (errorMsg == null) {
        walletResponse.when(
          success: (data) => wallets = data,
          error: (err) => errorMsg = 'Failed to load wallets: ${err}',
        );
      }

      if (errorMsg != null) {
        state = TransactionSuggestionState.error(errorMsg!);
      } else if (transactions.isEmpty) {
        state = TransactionSuggestionState.loaded(
            transactions: [], wallets: wallets);
      } else {
        state = TransactionSuggestionState.loaded(
          transactions: transactions,
          wallets: wallets,
        );
      }
    } catch (e) {
      state =
          TransactionSuggestionState.error('An unexpected error occurred: $e');
    }
  }

  void selectWallet(int? walletId) {
    state.maybeWhen(
      loaded: (transactions, wallets, _, submittingId) {
        state = TransactionSuggestionState.loaded(
          transactions: transactions,
          wallets: wallets,
          selectedWalletId: walletId,
          submittingTransactionId: submittingId,
        );
      },
      orElse: () {},
    );
  }

  Future<void> confirmTransaction(int transactionId) async {
    await state.maybeWhen(
      loaded: (transactions, wallets, selectedWalletId, submittingId) async {
        if (submittingId != null) return;
        if (selectedWalletId == null) {
          state = const TransactionSuggestionState.error(
              'Please select a wallet first.');
          await Future.delayed(const Duration(seconds: 2));
          state = TransactionSuggestionState.loaded(
            transactions: transactions,
            wallets: wallets,
            selectedWalletId: selectedWalletId,
            submittingTransactionId: null,
          );
          return;
        }

        state = TransactionSuggestionState.loaded(
          transactions: transactions,
          wallets: wallets,
          selectedWalletId: selectedWalletId,
          submittingTransactionId: transactionId,
        );

        final response = await _transactionRepo.confirmExtractedTransaction(
          transactionId: transactionId,
          walletId: selectedWalletId,
          status: 'Confirmed',
        );

        final currentState = state;
        if (currentState is Loaded) {
          final updatedTransactions = currentState.transactions
              .where((t) => t.id != transactionId)
              .toList();

          state = TransactionSuggestionState.loaded(
            transactions: updatedTransactions,
            wallets: currentState.wallets,
            selectedWalletId: currentState.selectedWalletId,
            submittingTransactionId: null,
          );

          state = const TransactionSuggestionState.success(
              'Transaction confirmed successfully.');
          await Future.delayed(const Duration(milliseconds: 100));
          state = TransactionSuggestionState.loaded(
            transactions: updatedTransactions,
            wallets: currentState.wallets,
            selectedWalletId: currentState.selectedWalletId,
            submittingTransactionId: null,
          );
        }
      },
      orElse: () async {},
    );
  }

  Future<void> rejectTransaction(int transactionId) async {
    await state.maybeWhen(
      loaded: (transactions, wallets, selectedWalletId, submittingId) async {
        if (submittingId != null) return;

        state = TransactionSuggestionState.loaded(
          transactions: transactions,
          wallets: wallets,
          selectedWalletId: selectedWalletId,
          submittingTransactionId: transactionId,
        );

        final response = await _transactionRepo.confirmExtractedTransaction(
          transactionId: transactionId,
          walletId: selectedWalletId ?? 0,
          status: 'Rejected',
        );

        final currentState = state;
        if (currentState is Loaded) {
          final updatedTransactions = currentState.transactions
              .where((t) => t.id != transactionId)
              .toList();

          state = TransactionSuggestionState.loaded(
            transactions: updatedTransactions,
            wallets: currentState.wallets,
            selectedWalletId: currentState.selectedWalletId,
            submittingTransactionId: null,
          );

          state = const TransactionSuggestionState.success(
              'Transaction rejected successfully.');
          await Future.delayed(const Duration(milliseconds: 100));
          state = TransactionSuggestionState.loaded(
            transactions: updatedTransactions,
            wallets: currentState.wallets,
            selectedWalletId: currentState.selectedWalletId,
            submittingTransactionId: null,
          );
        }
      },
      orElse: () async {},
    );
  }
}
