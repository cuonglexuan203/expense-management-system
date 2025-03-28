import 'package:expense_management_system/app/widget/bottom_nav_bar.dart';
import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/feature/transaction/repository/transaction_repository.dart';
import 'package:expense_management_system/feature/transaction/widget/transaction_item.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/feature/wallet/state/wallet_state.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:expense_management_system/shared/pagination/pagination_state.dart';
import 'package:expense_management_system/shared/util/bottom_nav_bar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Filter parameters for transactions
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

class _TransactionPageState extends ConsumerState<TransactionPage> {
  final ScrollController _scrollController = ScrollController();

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
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
      backgroundColor: Colors.white,
      body: _buildBody(walletState, transactionState),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: ref.watch(currentNavIndexProvider),
        onTap: (index) =>
            BottomNavigationManager.handleNavigation(context, ref, index),
      ),
    );
  }

  Widget _buildBody(
      WalletState walletState, PaginatedState<Transaction> transactionState) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(filteredTransactionsProvider(_filterParams).notifier)
                    .refresh();
              },
              child: _buildContent(walletState, transactionState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          const Text(
            'Transactions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWalletInfo(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown<TransactionPeriod>(
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
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterDropdown<TransactionType>(
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
              const SizedBox(width: 8),
              Expanded(
                child: _buildFilterDropdown<TransactionSort>(
                  'Sort',
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWalletInfo() {
    return ref.watch(walletDetailNotifierProvider(widget.walletId)).maybeWhen(
          success: (wallet) => Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    Text(
                      wallet.balance.toFormattedString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildFilterDropdown<T>(
      String label, List<T> items, T selectedItem, Function(T?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<T>(
        value: selectedItem,
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        underline: const SizedBox(),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              value is TransactionPeriod
                  ? value.label
                  : value is TransactionType
                      ? value.label
                      : value is TransactionSort
                          ? value.label
                          : value.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent(
      WalletState walletState, PaginatedState<Transaction> transactionState) {
    if (transactionState.isLoading && transactionState.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactionState.items.isEmpty) {
      return const Center(
        child: Text(
          'No transactions found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'Nunito',
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount:
          transactionState.items.length + (transactionState.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == transactionState.items.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return TransactionItem(transaction: transactionState.items[index]);
      },
    );
  }
}
