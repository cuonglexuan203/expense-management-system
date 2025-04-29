import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/chat/model/extracted_transaction.dart';
import 'package:expense_management_system/feature/chat/repository/chat_repository.dart';
import 'package:expense_management_system/feature/notification/provider/transaction_suggestion_notifier.dart';
import 'package:expense_management_system/feature/notification/state/transaction_suggestion_state.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:expense_management_system/shared/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionSuggestionPage extends ConsumerWidget {
  final int notificationId;

  const TransactionSuggestionPage({required this.notificationId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionSuggestionProvider(notificationId));
    final notifier =
        ref.read(transactionSuggestionProvider(notificationId).notifier);

    ref.listen<TransactionSuggestionState>(
        transactionSuggestionProvider(notificationId), (previous, next) {
      next.maybeWhen(
        error: (message) {
          if (previous is! Loading && previous is! Initial) {
            AppSnackBar.showError(context: context, message: message);
          }
        },
        loaded: (transactions, _, __, ___) {
          if (transactions.isEmpty &&
              previous is Loaded &&
              previous.transactions.isNotEmpty) {
            AppSnackBar.showSuccess(
                context: context, message: 'All suggestions processed!');
            if (context.canPop()) {
              context.pop();
            }
          }
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Suggestions'),
      ),
      body: state.when(
        initial: () => const Center(child: LoadingWidget()),
        loading: () => const LoadingWidget(),
        error: (message) => _buildErrorWidget(context, message, notifier),
        success: (message) => Center(child: Text(message)),
        loaded:
            (transactions, wallets, selectedWalletId, submittingTransactionId) {
          if (transactions.isEmpty) {
            return _buildEmptyWidget(context);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: _buildWalletSection(context, wallets, selectedWalletId,
                    notifier, submittingTransactionId != null),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return _TransactionSuggestionItem(
                      transaction: transaction,
                      selectedWalletId: selectedWalletId,
                      notifier: notifier,
                      submittingTransactionId: submittingTransactionId,
                      hasWallets: wallets.isNotEmpty,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWalletSection(
      BuildContext context,
      List<Wallet> wallets,
      int? selectedWalletId,
      TransactionSuggestionNotifier notifier,
      bool isAnySubmitting) {
    if (wallets.isNotEmpty) {
      return _buildWalletDropdown(
          context, wallets, selectedWalletId, notifier, isAnySubmitting);
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.orange.shade300)),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: Colors.orange.shade800, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'No wallets found. Create a wallet to confirm suggestions.',
                style: TextStyle(color: Colors.orange.shade900, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildWalletDropdown(
      BuildContext context,
      List<Wallet> wallets,
      int? selectedWalletId,
      TransactionSuggestionNotifier notifier,
      bool isSubmitting) {
    return DropdownButtonFormField<int>(
      value: selectedWalletId,
      isExpanded: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_balance_wallet_outlined,
            color: Theme.of(context).colorScheme.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintText: 'Select Wallet',
        filled: isSubmitting,
        fillColor: isSubmitting ? Colors.grey.shade200 : null,
      ),
      onChanged: isSubmitting
          ? null
          : (int? newValue) {
              notifier.selectWallet(newValue);
            },
      items: wallets.map<DropdownMenuItem<int>>((Wallet wallet) {
        return DropdownMenuItem<int>(
          value: wallet.id,
          child: Text(
            wallet.name,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      selectedItemBuilder: (BuildContext context) {
        return wallets.map<Widget>((Wallet item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList();
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message,
      TransactionSuggestionNotifier notifier) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                color: Theme.of(context).colorScheme.error, size: 60),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 8),
            // Text(
            //   message,
            //   textAlign: TextAlign.center,
            //   style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            // ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () => notifier.fetchData(),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                color: Colors.green.shade400, size: 60),
            const SizedBox(height: 16),
            Text(
              'All Clear!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'There are no pending transaction suggestions right now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionSuggestionItem extends StatelessWidget {
  final ExtractedTransaction transaction;
  final int? selectedWalletId;
  final TransactionSuggestionNotifier notifier;
  final int? submittingTransactionId;
  final bool hasWallets;

  const _TransactionSuggestionItem({
    Key? key,
    required this.transaction,
    required this.selectedWalletId,
    required this.notifier,
    required this.submittingTransactionId,
    required this.hasWallets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCurrentItemSubmitting =
        submittingTransactionId == transaction.id;
    final bool isAnySubmitting = submittingTransactionId != null;
    final bool canConfirm =
        hasWallets && selectedWalletId != null && !isAnySubmitting;

    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final amountColor = transaction.type == 'Expense'
        ? Theme.of(context).colorScheme.error
        : Colors.green.shade700;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    transaction.name,
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  transaction.amount.toCurrencyString(),
                  style: textTheme.titleLarge?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (transaction.category != null)
              _buildDetailItem(
                  context, Icons.category_outlined, transaction.category!),
            if (transaction.occurredAt != null)
              _buildDetailItem(context, Icons.calendar_today_outlined,
                  dateFormat.format(transaction.occurredAt!.toLocal())),
            const SizedBox(height: 16),
            Row(
              children: [
                if (!canConfirm && hasWallets)
                  Expanded(
                    child: Text(
                      'Select wallet to confirm',
                      style: TextStyle(
                          color: Colors.orange.shade800, fontSize: 12),
                    ),
                  )
                else
                  const Spacer(),
                _buildActionButton(
                  context: context,
                  label: 'Reject',
                  icon: Icons.cancel_outlined,
                  color: Theme.of(context).colorScheme.error,
                  isLoading: isCurrentItemSubmitting,
                  onPressed: isAnySubmitting
                      ? null
                      : () => notifier.rejectTransaction(transaction.id),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  context: context,
                  label: 'Confirm',
                  icon: Icons.check_circle_outline,
                  color: Colors.green.shade700,
                  isPrimary: true,
                  isLoading: isCurrentItemSubmitting,
                  onPressed: canConfirm
                      ? () => notifier.confirmTransaction(transaction.id)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    bool isPrimary = false,
    bool isLoading = false,
  }) {
    final buttonStyle = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            disabledBackgroundColor: Colors.grey.shade400,
          )
        : OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(
                color: onPressed == null ? Colors.grey.shade400 : color),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            textStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          );

    final content = isLoading
        ? SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: isPrimary ? Colors.white : color))
        : Icon(icon, size: 18);

    return isPrimary
        ? ElevatedButton.icon(
            icon: content,
            label: Text(label),
            style: buttonStyle,
            onPressed: onPressed,
          )
        : OutlinedButton.icon(
            icon: content,
            label: Text(label),
            style: buttonStyle,
            onPressed: onPressed,
          );
  }
}
