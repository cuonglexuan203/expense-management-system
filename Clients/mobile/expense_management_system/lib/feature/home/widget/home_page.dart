import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/app/widget/bottom_nav_bar.dart';
import 'package:expense_management_system/feature/home/provider/greeting_provider.dart';
import 'package:expense_management_system/feature/home/provider/home_provider.dart';
import 'package:expense_management_system/feature/home/state/home_state.dart';
import 'package:expense_management_system/feature/home/widget/empty_balance_card.dart';
import 'package:expense_management_system/feature/home/widget/transaction_list_section.dart';
import 'package:expense_management_system/feature/home/widget/wallet_balance_card.dart';
import 'package:expense_management_system/feature/home/widget/wallet_list.dart';
import 'package:expense_management_system/feature/notification/widget/notifications_page.dart';
import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/shared/route/app_router.dart';
import 'package:expense_management_system/shared/util/bottom_nav_bar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  String _currentPeriod = 'AllTime';
  DateTime? _fromDate; // Add this
  DateTime? _toDate; // Add this

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _loadMoreIfNeeded();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  void _loadMoreIfNeeded() {
    final homeState = ref.read(homeNotifierProvider)
      ..maybeWhen(
        loaded: (wallets, selectedIndex) {
          if (wallets.isNotEmpty) {
            final walletId = wallets[selectedIndex].id;

            final filterParams = TransactionFilterParams(
              walletId: walletId,
              period: _currentPeriod,
              fromDate: _fromDate,
              toDate: _toDate,
            );

            final paginatedState =
                ref.read(filteredTransactionsProvider(filterParams));

            if (!paginatedState.isLoading && !paginatedState.hasReachedEnd) {
              ref
                  .read(filteredTransactionsProvider(filterParams).notifier)
                  .fetchNextPage();
            }
          }
        },
        orElse: () {},
      );
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(homeState),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: ref.watch(currentNavIndexProvider),
        onTap: (index) =>
            BottomNavigationManager.handleNavigation(context, ref, index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final selectedWalletId = ref.read(homeNotifierProvider).maybeWhen(
                loaded: (wallets, selectedIndex) => wallets[selectedIndex].id,
                orElse: () => null,
              );
          if (selectedWalletId != null) {
            ChatRoute(walletId: selectedWalletId).push(context);
          } else {
            AppSnackBar.showWarning(
                context: context, message: 'Please select a wallet first');
          }
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF386BF6),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget _buildBody(HomeState homeState) {
    return Container(
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
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(homeNotifierProvider.notifier).refreshWallets();
            // Refresh transactions for current wallet if available
            homeState.maybeWhen(
              loaded: (wallets, selectedIndex) {
                if (wallets.isNotEmpty) {
                  ref
                      .read(paginatedTransactionsProvider(
                              wallets[selectedIndex].id)
                          .notifier)
                      .refresh();
                }
              },
              orElse: () {},
            );
          },
          color: const Color(0xFF386BF6),
          child: _buildContent(homeState),
        ),
      ),
    );
  }

  Widget _buildContent(HomeState homeState) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (notification.metrics.pixels >=
              notification.metrics.maxScrollExtent - 200) {
            _loadMoreIfNeeded();
          }
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(homeNotifierProvider.notifier).refreshWallets();
          homeState.maybeWhen(
            loaded: (wallets, selectedIndex) {
              if (wallets.isNotEmpty) {
                ref
                    .read(
                        paginatedTransactionsProvider(wallets[selectedIndex].id)
                            .notifier)
                    .refresh();
              }
            },
            orElse: () {},
          );
        },
        color: const Color(0xFF386BF6),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeaderSection(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildWalletSection(homeState),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildBalanceCardSection(homeState),
              ),
              const SizedBox(height: 20),
              _buildTransactionSectionContainer(homeState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionSectionContainer(HomeState homeState) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),
              // TextButton(
              //   onPressed: () {},
              //   child: const Text('See all'),
              // ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTransactions(homeState),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    final greeting = ref.watch(greetingProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito',
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Enjetin Morgeana',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Iconsax.notification,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSection(HomeState homeState) {
    return homeState.when(
      loading: () => const Center(
        child: SizedBox(
          height: 120,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
      error: (message) => SizedBox(
        height: 120,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $message',
                style: const TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(homeNotifierProvider.notifier).refreshWallets(),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      loaded: (wallets, selectedIndex) => WalletList(
        wallets: wallets,
        selectedIndex: selectedIndex,
        onWalletSelected: (index) {
          ref.read(homeNotifierProvider.notifier).selectWallet(index);
        },
      ),
    );
  }

  Widget _buildBalanceCardSection(HomeState homeState) {
    return homeState.when(
      loading: () => const Center(
        child: SizedBox(
          height: 170,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
      error: (message) => Container(),
      loaded: (wallets, selectedIndex) {
        if (wallets.isEmpty) {
          return const EmptyBalanceCard();
        }

        final selectedWallet = wallets[selectedIndex];
        return WalletBalanceCard(
          walletId: selectedWallet.id,
          onPeriodChanged: (period, {DateTime? fromDate, DateTime? toDate}) {
            // Update local state
            setState(() {
              _currentPeriod = period;
              _fromDate = fromDate;
              _toDate = toDate;
            });

            // Update wallet summary with date range
            ref.invalidate(filteredWalletProvider(
              FilterParams(
                walletId: selectedWallet.id,
                period: period,
                fromDate: fromDate,
                toDate: toDate,
              ),
            ));

            // Refresh transactions with date range
            ref
                .read(filteredTransactionsProvider(
                  TransactionFilterParams(
                    walletId: selectedWallet.id,
                    period: period,
                    fromDate: fromDate,
                    toDate: toDate,
                  ),
                ).notifier)
                .refresh();
          },
        );
      },
    );
  }

  Widget _buildTransactions(HomeState homeState) {
    return homeState.when(
        loading: () => const Center(),
        error: (_) => const Center(
              child: SizedBox(
                height: 200,
                child: Text('Error loading transactions',
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
        loaded: (wallets, selectedIndex) {
          if (wallets.isEmpty) {
            return const Center(
              child: SizedBox(
                height: 200,
                child: Text('No wallet selected',
                    style: TextStyle(color: Colors.grey)),
              ),
            );
          }

          final walletId = wallets[selectedIndex].id;
          // Use filteredTransactionsProvider with current period
          return TransactionList(
            walletId: walletId,
            period: _currentPeriod,
            fromDate: _fromDate,
            toDate: _toDate,
          );
        });
  }
}
