import 'package:expense_management_system/app/widget/bottom_nav_bar.dart';
import 'package:expense_management_system/app/widget/custom_header,dart';
import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/feature/transaction/repository/transaction_repository.dart';
import 'package:expense_management_system/feature/transaction/widget/transaction_item.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/feature/wallet/state/wallet_state.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:expense_management_system/shared/pagination/pagination_state.dart';
import 'package:expense_management_system/shared/util/bottom_nav_bar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionFilterParams {
  final int walletId;
  final String period;
  final String? type;
  final String sort;

  TransactionFilterParams({
    required this.walletId,
    this.period = 'AllTime',
    this.type,
    this.sort = 'DESC',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionFilterParams &&
          walletId == other.walletId &&
          period == other.period &&
          type == other.type &&
          sort == other.sort;

  @override
  int get hashCode => Object.hash(walletId, period, type, sort);
}

// Provider for filtered transactions
final filteredTransactionsProvider = StateNotifierProvider.family<
    FilteredTransactionsNotifier,
    PaginatedState<Transaction>,
    TransactionFilterParams>(
  (ref, params) => FilteredTransactionsNotifier(ref, params),
);

// State notifier for filtered transactions
class FilteredTransactionsNotifier
    extends StateNotifier<PaginatedState<Transaction>> {
  final Ref _ref;
  final TransactionFilterParams params;

  FilteredTransactionsNotifier(this._ref, this.params)
      : super(PaginatedState.initial<Transaction>()) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasReachedEnd) return;

    state = state.copyWith(isLoading: true);
    final repository = _ref.read(transactionRepositoryProvider);

    try {
      final response = await repository.getTransactionsByWalletPaginated(
        params.walletId,
        pageNumber: state.paginationInfo.pageNumber,
        pageSize: state.paginationInfo.pageSize,
        period: params.period,
        type: params.type,
        sort: params.sort,
      );

      response.when(
        success: (paginatedResponse) {
          state = state.copyWith(
            items: [...state.items, ...paginatedResponse.items],
            paginationInfo: paginatedResponse.paginationInfo,
            isLoading: false,
            hasReachedEnd: !paginatedResponse.paginationInfo.hasNextPage,
          );
        },
        error: (error) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = PaginatedState.initial<Transaction>();
    await fetchNextPage();
  }
}

enum TransactionPeriod {
  allTime('All Time', 'AllTime'),
  currentWeek('This Week', 'CurrentWeek'),
  currentMonth('This Month', 'CurrentMonth'),
  currentYear('This Year', 'CurrentYear');

  final String label;
  final String apiValue;
  const TransactionPeriod(this.label, this.apiValue);
}

enum TransactionType {
  none('All', null),
  expense('Expense', 'Expense'),
  income('Income', 'Income');

  final String label;
  final String? apiValue;
  const TransactionType(this.label, this.apiValue);
}

enum TransactionSort {
  desc('Newest First', 'DESC'),
  asc('Oldest First', 'ASC');

  final String label;
  final String apiValue;
  const TransactionSort(this.label, this.apiValue);
}

class TransactionPage extends ConsumerStatefulWidget {
  final int walletId;

  const TransactionPage({Key? key, required this.walletId}) : super(key: key);

  @override
  ConsumerState<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends ConsumerState<TransactionPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Filter state
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
    );
    _scrollController.addListener(_onScroll);

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
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _loadMoreTransactions();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
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
      );
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
              child: RefreshIndicator(
                color: ColorName.blue,
                onRefresh: () async {
                  await ref
                      .read(
                          filteredTransactionsProvider(_filterParams).notifier)
                      .refresh();
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
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
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: ref.watch(currentNavIndexProvider),
        onTap: (index) =>
            BottomNavigationManager.handleNavigation(context, ref, index),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFF8FAFD),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row with illustrations
          Row(
            children: [
              // Main title with dynamic design
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

              // Action buttons - search and filter
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
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
                      onPressed: () {
                        // Implement search
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.sort),
                      color: ColorName.blue,
                      onPressed: () {
                        // Show quick sort options
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Subtitle/description (optional)
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

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Navigate to add transaction page
      },
      backgroundColor: ColorName.blue,
      elevation: 4,
      child: const Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  Widget _buildBody(
      WalletState walletState, PaginatedState<Transaction> transactionState) {
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildWalletSummary(),
            _buildFiltersSection(),
            Expanded(
              child: RefreshIndicator(
                color: ColorName.blue,
                onRefresh: () async {
                  await ref
                      .read(
                          filteredTransactionsProvider(_filterParams).notifier)
                      .refresh();
                },
                child: _buildContent(walletState, transactionState),
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  Widget _buildContent(
      WalletState walletState, PaginatedState<Transaction> transactionState) {
    if (transactionState.isLoading && transactionState.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactionState.items.isEmpty) {
      return _buildEmptyState();
    }

    return _buildTransactionsListContent(transactionState);
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

    // Group transactions by date
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

        // Loading indicator at the bottom
        if (transactionState.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          ),

        // Add bottom padding to ensure we can scroll past the FAB
        const SizedBox(height: 80),
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

  Widget _buildTransactionsList(PaginatedState<Transaction> transactionState) {
    // Group transactions by date
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

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: sortedDates.length + (transactionState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == sortedDates.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final date = sortedDates[index];
        final transactions = groupedTransactions[date]!;

        return _buildDateSection(date, transactions);
      },
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
