// lib/feature/transaction/provider/transaction_suggestion_state.dart
import 'package:expense_management_system/feature/chat/model/extracted_transaction.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_suggestion_state.freezed.dart';

@freezed
class TransactionSuggestionState with _$TransactionSuggestionState {
  const factory TransactionSuggestionState.initial() = Initial;
  const factory TransactionSuggestionState.loading() = Loading;
  const factory TransactionSuggestionState.loaded({
    required List<ExtractedTransaction> transactions,
    required List<Wallet> wallets,
    int? selectedWalletId,
    int? submittingTransactionId,
  }) = Loaded;
  const factory TransactionSuggestionState.success(String message) = _Success;
  const factory TransactionSuggestionState.error(String message) = _Error;
}
