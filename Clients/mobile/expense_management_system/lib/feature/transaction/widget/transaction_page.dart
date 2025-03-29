import 'dart:async';

import 'package:expense_management_system/app/widget/bottom_nav_bar.dart';
import 'package:expense_management_system/feature/home/provider/home_provider.dart';
import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/feature/transaction/widget/transaction_item.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:expense_management_system/shared/pagination/pagination_state.dart';
import 'package:expense_management_system/shared/route/app_router.dart';
import 'package:expense_management_system/shared/util/bottom_nav_bar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class TransactionPage extends ConsumerStatefulWidget {
  final int walletId;

  const TransactionPage({Key? key, required this.walletId}) : super(key: key);

  @override
  ConsumerState<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends ConsumerState<TransactionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounce;

  TransactionPeriod _selectedPeriod = TransactionPeriod.allTime;
  TransactionType _selectedType = TransactionType.none;
  TransactionSort _selectedSort = TransactionSort.desc;

  late TransactionFilterParams _filterParams;

  @override
  void initState() {
    super.initState();
    _filterParams = TransactionFilterParams(
      walletId: widget.walletId,
      period: _selectedPeriod.apiValue,
      type: _selectedType.apiValue,
      sort: _selectedSort.apiValue,
      search: null,
    );

    _searchController.addListener(_onSearchChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  // Search handling with debounce
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Only update if the search term has changed
      if (_filterParams.search != _searchController.text) {
        setState(() {
          _filterParams = TransactionFilterParams(
            walletId: widget.walletId,
            period: _selectedPeriod.apiValue,
            type: _selectedType.apiValue,
            sort: _selectedSort.apiValue,
            search: _searchController.text.isNotEmpty
                ? _searchController.text
                : null,
          );
          // Refresh the transactions list with new search parameter
          ref
              .read(filteredTransactionsProvider(_filterParams).notifier)
              .refresh();
        });
      }
    });
  }

  void _loadMoreTransactions() {
    ref
        .read(filteredTransactionsProvider(_filterParams).notifier)
        .fetchNextPage();
  }

  void _updateFilters() {
    setState(() {
      _filterParams = TransactionFilterParams(
        walletId: widget.walletId,
        period: _selectedPeriod.apiValue,
        type: _selectedType.apiValue,
        sort: _selectedSort.apiValue,
        search:
            _searchController.text.isNotEmpty ? _searchController.text : null,
      );
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _filterParams = TransactionFilterParams(
        walletId: widget.walletId,
        period: _selectedPeriod.apiValue,
        type: _selectedType.apiValue,
        sort: _selectedSort.apiValue,
        search: null,
      );
      // Refresh the transactions list
      ref.read(filteredTransactionsProvider(_filterParams).notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState =
        ref.watch(walletDetailNotifierProvider(widget.walletId));
    final transactionState =
        ref.watch(filteredTransactionsProvider(_filterParams));

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed title section
            _buildTitleSection(),

            // Scrollable content
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 300) {
                      _loadMoreTransactions();
                    }
                  }
                  return false;
                },
                child: RefreshIndicator(
                  color: ColorName.blue,
                  onRefresh: () async {
                    await ref
                        .read(filteredTransactionsProvider(_filterParams)
                            .notifier)
                        .refresh();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildWalletSummary(),
                        _buildFiltersSection(),
                        _buildTransactionsListContent(transactionState),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a wallet first')),
            );
          }
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF386BF6),
        child: const Icon(Iconsax.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF8FAFD),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (!_isSearching) ...[
                // Regular title view
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Nunito',
                          color: Color(0xFF2D3142),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: ColorName.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                // Search icon button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    color: ColorName.blue,
                    iconSize: 24,
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ),
              ] else ...[
                // Search UI
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search transactions by name...',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF2D3142).withOpacity(0.5),
                          fontFamily: 'Nunito',
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ColorName.blue,
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: _clearSearch,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        color: Color(0xFF2D3142),
                      ),
                      onSubmitted: (value) {
                        // Trigger search on submit
                        _onSearchChanged();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Close search button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: const Color(0xFF2D3142),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _clearSearch();
                      });
                    },
                  ),
                ),
              ],
            ],
          ),
          if (!_isSearching)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Track your financial activity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito',
                  color: const Color(0xFF2D3142).withOpacity(0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget _buildFloatingActionButton() {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       // Navigate to add transaction page
  //     },
  //     backgroundColor: ColorName.blue,
  //     elevation: 4,
  //     child: const Icon(Icons.add, color: Colors.white, size: 28),
  //   );
  // }

  Widget _buildWalletSummary() {
    return ref.watch(walletDetailNotifierProvider(widget.walletId)).maybeWhen(
          success: (wallet) => Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorName.blue,
                  ColorName.blue.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: ColorName.blue.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wallet.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Current Balance',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    wallet.balance.toFormattedString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBalanceInsights(wallet),
                ],
              ),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error) => Center(
            child: Text('Error: $error'),
          ),
          orElse: () => const SizedBox.shrink(),
        );
  }

  Widget _buildBalanceInsights(Wallet wallet) {
    final walletAsync = ref.watch(filteredWalletProvider(
      FilterParams(walletId: wallet.id, period: 'AllTime'),
    ));

    return walletAsync.when(
      data: (wallet) => Row(
        children: [
          Expanded(
            child: _buildInsightCard(
              icon: Icons.trending_up,
              color: Colors.green,
              label: 'Income',
              amount: wallet.income.totalAmount,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildInsightCard(
              icon: Icons.trending_down,
              color: Colors.redAccent,
              label: 'Expense',
              amount: wallet.expense.totalAmount,
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required Color color,
    required String label,
    required double amount,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontFamily: 'Nunito',
                ),
              ),
              Text(
                '\$${amount.toFormattedString()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: const Text(
            'Filter Transactions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito',
              color: Color(0xFF2D3142),
            ),
          ),
          leading: const Icon(
            Icons.filter_list,
            color: ColorName.blue,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildFilterChip(
                    'Period',
                    TransactionPeriod.values,
                    _selectedPeriod,
                    (value) {
                      if (value != null && value != _selectedPeriod) {
                        setState(() {
                          _selectedPeriod = value;
                        });
                        _updateFilters();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildFilterChip(
                    'Type',
                    TransactionType.values,
                    _selectedType,
                    (value) {
                      if (value != null && value != _selectedType) {
                        setState(() {
                          _selectedType = value;
                        });
                        _updateFilters();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildFilterChip(
                    'Sort By',
                    TransactionSort.values,
                    _selectedSort,
                    (value) {
                      if (value != null && value != _selectedSort) {
                        setState(() {
                          _selectedSort = value;
                        });
                        _updateFilters();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip<T>(
    String label,
    List<T> items,
    T selectedItem,
    Function(T?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito',
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items.map((T item) {
              final isSelected = item == selectedItem;
              String itemLabel;

              if (item is TransactionPeriod) {
                itemLabel = item.label;
              } else if (item is TransactionType) {
                itemLabel = item.label;
              } else if (item is TransactionSort) {
                itemLabel = item.label;
              } else {
                itemLabel = item.toString();
              }

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(
                    itemLabel,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF2D3142),
                      fontSize: 13,
                      fontFamily: 'Nunito',
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: ColorName.blue,
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onSelected: (bool selected) {
                    if (selected) onChanged(item);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsListContent(
      PaginatedState<Transaction> transactionState) {
    if (transactionState.isLoading && transactionState.items.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (transactionState.items.isEmpty) {
      return _buildEmptyState();
    }

    // Display search results information if search is active
    Widget searchInfoBanner = const SizedBox.shrink();
    if (_filterParams.search != null && _filterParams.search!.isNotEmpty) {
      searchInfoBanner = Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: ColorName.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Search results for "${_filterParams.search}"',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorName.blue,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
            InkWell(
              onTap: _clearSearch,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorName.blue,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final Map<String, List<Transaction>> groupedTransactions = {};

    for (var transaction in transactionState.items) {
      final date = DateFormat('MMM d, yyyy').format(transaction.occurredAt);
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMM d, yyyy').parse(a);
        final dateB = DateFormat('MMM d, yyyy').parse(b);
        return _selectedSort == TransactionSort.desc
            ? dateB.compareTo(dateA)
            : dateA.compareTo(dateB);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sortedDates.map((date) {
          final transactions = groupedTransactions[date]!;
          return _buildDateSection(date, transactions);
        }).toList(),
        if (transactionState.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(
                    color: ColorName.blue,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Loading more transactions...',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (transactionState.hasReachedEnd && transactionState.items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(1, 16, 1, 50),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'All transactions loaded',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Try changing your filters or add a new transaction',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(String date, List<Transaction> transactions) {
    final now = DateTime.now();
    final today = DateFormat('MMM d, yyyy').format(now);
    final yesterday =
        DateFormat('MMM d, yyyy').format(now.subtract(const Duration(days: 1)));

    String displayDate;
    if (date == today) {
      displayDate = 'Today';
    } else if (date == yesterday) {
      displayDate = 'Yesterday';
    } else {
      displayDate = date;
    }

    // Calculate total for the day
    double totalAmount = 0;
    for (var transaction in transactions) {
      if (transaction.type == 'Income') {
        totalAmount += transaction.amount;
      } else {
        totalAmount -= transaction.amount;
      }
    }

    final isPositive = totalAmount >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                displayDate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito',
                  color: Color(0xFF2D3142),
                ),
              ),
              Text(
                '${isPositive ? '+' : ''}${totalAmount.toFormattedString()}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: isPositive ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ],
          ),
        ),
        ...transactions.map(
          (transaction) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TransactionItem(transaction: transaction),
          ),
        ),
      ],
    );
  }
}
