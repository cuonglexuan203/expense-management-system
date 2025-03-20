import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/feature/transaction/widget/transaction_item.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/feature/wallet/widget/add_transaction_page.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class WalletDetailPage extends ConsumerStatefulWidget {
  final int walletId;
  const WalletDetailPage({super.key, required this.walletId});

  @override
  ConsumerState<WalletDetailPage> createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends ConsumerState<WalletDetailPage> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() {
        try {
          ref
              .read(paginatedTransactionsProvider(widget.walletId).notifier)
              .refresh();
        } catch (e) {
          print('Error initializing provider: $e');
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ref
          .read(paginatedTransactionsProvider(widget.walletId).notifier)
          .fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    final walletState =
        ref.watch(walletDetailNotifierProvider(widget.walletId));

    ref.listen(walletChangesProvider, (previous, next) {
      if (previous != next) {
        ref.invalidate(walletDetailNotifierProvider(widget.walletId));
        ref
            .read(paginatedTransactionsProvider(widget.walletId).notifier)
            .refresh();
      }
    });

    return walletState.when(
      initial: () => _buildLoadingScaffold(),
      loading: () => _buildLoadingScaffold(),
      success: (wallet) => _buildWalletScaffold(context, wallet),
      error: (error) => _buildErrorScaffold(error as String),
    );
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB7C5E1), Color(0xFF4B7BF9)],
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorScaffold(String error) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB7C5E1), Color(0xFF4B7BF9)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                'Error: $error',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletScaffold(BuildContext context, Wallet wallet) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFB7C5E1),
                Color(0xFF4B7BF9),
              ],
            ),
          ),
          child: Column(
            children: [
              // Header with wallet name
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.go('/'),
                    ),
                    Text(
                      wallet.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          wallet.balance.toFormattedString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildActionButton(
                              icon: Iconsax.arrow_down_2,
                              label: 'Add Income',
                              color: Colors.green,
                              isIncome: true,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddTransactionPage(
                                      isExpense: false,
                                      walletId: wallet.id,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  ref
                                      .read(walletChangesProvider.notifier)
                                      .notifyChanges();
                                }
                              },
                            ),
                            const SizedBox(width: 20),
                            _buildActionButton(
                              icon: Iconsax.arrow_up_1,
                              label: 'Add Expense',
                              color: Colors.red,
                              isIncome: false,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddTransactionPage(
                                      isExpense: true,
                                      walletId: wallet.id,
                                    ),
                                  ),
                                );

                                if (result == true) {
                                  // Transaction added, notify changes
                                  ref
                                      .read(walletChangesProvider.notifier)
                                      .notifyChanges();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Tabs
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  decoration: BoxDecoration(
                                    color: ColorName.blue,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Transactions',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Nunito',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: _buildPaginatedTransactionsList(wallet.id),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginatedTransactionsList(int walletId) {
    return Consumer(
      builder: (context, ref, child) {
        final paginatedState =
            ref.watch(paginatedTransactionsProvider(walletId));
        final transactions = paginatedState.items;
        final isLoading = paginatedState.isLoading;
        final hasError = paginatedState.errorMessage != null;

        if (hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 40),
                const SizedBox(height: 10),
                Text(
                  'Error: ${paginatedState.errorMessage}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(paginatedTransactionsProvider(walletId).notifier)
                        .refresh();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (isLoading && transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (transactions.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(paginatedTransactionsProvider(walletId).notifier)
                  .refresh();
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: transactions.length + (isLoading ? 1 : 0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (index == transactions.length && isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final transaction = transactions[index];
                return TransactionItem(transaction: transaction);
              },
            ),
          );
        }

        return const Center(
          child: Text(
            'No transactions yet',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      required Color color,
      required bool isIncome}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isIncome
                    ? [Colors.green[300]!, Colors.green[600]!]
                    : [Colors.red[300]!, Colors.red[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: (isIncome ? Colors.green[300]! : Colors.red[300]!)
                      .withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}

String _safeFormatAmount(num? amount) {
  try {
    if (amount == null) return '0.00';
    return amount.toFormattedString();
  } catch (e) {
    return '0';
  }
}
