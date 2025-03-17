import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app/widget/bottom_nav_bar.dart';
import 'package:flutter_boilerplate/feature/transaction/model/transaction.dart';
import 'package:flutter_boilerplate/feature/transaction/provider/transaction_provider.dart';
import 'package:flutter_boilerplate/feature/wallet/model/wallet.dart';
import 'package:flutter_boilerplate/feature/wallet/provider/wallet_provider.dart';
import 'package:flutter_boilerplate/feature/wallet/widget/add_transaction_page.dart';
import 'package:flutter_boilerplate/gen/colors.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class WalletDetailPage extends ConsumerStatefulWidget {
  final int walletId;
  const WalletDetailPage({super.key, required this.walletId});

  @override
  ConsumerState<WalletDetailPage> createState() => _WalletDetailPageState();
}

class _WalletDetailPageState extends ConsumerState<WalletDetailPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Listen to wallet state changes
    final walletState =
        ref.watch(walletDetailNotifierProvider(widget.walletId));

    // Listen to wallet changes to refresh data
    ref.listen(walletChangesProvider, (previous, next) {
      if (previous != next) {
        // Refresh wallet data when changes occur
        ref.invalidate(walletDetailNotifierProvider(widget.walletId));
        ref.invalidate(walletTransactionsProvider(widget.walletId));
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
                          '\$${wallet.balance}',
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
                              icon: Iconsax.arrow_up_1,
                              label: 'Add Expense',
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
                            const SizedBox(width: 20),
                            _buildActionButton(
                              icon: Iconsax.arrow_down_2,
                              label: 'Add Income',
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
                        // Transaction list with pull-to-refresh
                        Expanded(
                          child: _buildTransactionsList(wallet.id),
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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/chat'),
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF386BF6),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTransactionsList(int walletId) {
    return Consumer(
      builder: (context, ref, child) {
        final transactionsAsync =
            ref.watch(walletTransactionsProvider(walletId));

        return RefreshIndicator(
          onRefresh: () async {
            // Refresh both the wallet and transactions data
            ref.invalidate(walletDetailNotifierProvider(walletId));
            return ref.refresh(walletTransactionsProvider(walletId).future);
          },
          child: transactionsAsync.when(
            data: (transactions) {
              // Use ListView with proper physics even when empty
              return ListView.builder(
                itemCount: transactions.isEmpty ? 1 : transactions.length,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (transactions.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: const Center(
                        child: Text(
                          'No transactions yet',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    );
                  }

                  final transaction = transactions[index];
                  return _buildTransactionItem(transaction);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 32),
                      const SizedBox(height: 16),
                      const Text(
                        'Error loading transactions',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontFamily: 'Nunito',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.type == 'Income';
    final formattedDate =
        DateFormat('MMM d, yyyy').format(transaction.occurredAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome ? Iconsax.arrow_down_2 : Iconsax.arrow_up_1,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Nunito',
                  ),
                ),
                Text(
                  '${transaction.categoryName ?? "Unknown"} • $formattedDate', // Use categoryName
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}\$${transaction.amount}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isIncome ? Colors.green : Colors.red,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: ColorName.blue,
              size: 36,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: ColorName.black,
              fontSize: 12,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}
