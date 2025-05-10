import 'package:expense_management_system/app/widget/bottom_nav_bar.dart';
import 'package:expense_management_system/feature/home/provider/home_provider.dart';
import 'package:expense_management_system/feature/statistic/widget/expense_statistics_tab.dart';
import 'package:expense_management_system/feature/statistic/widget/income_statistics_tab.dart';
import 'package:expense_management_system/feature/statistic/widget/overview_statistics_tab.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:expense_management_system/shared/util/bottom_nav_bar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsPage extends ConsumerStatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends ConsumerState<StatisticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TransactionPeriod _selectedPeriod = TransactionPeriod.currentMonth;
  final List<TransactionPeriod> _periods = TransactionPeriod.values;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);
    int? currentWalletId;

    homeState.maybeWhen(
      loaded: (wallets, selectedIndex) {
        if (wallets.isNotEmpty) {
          currentWalletId =
              (selectedIndex >= 0 && selectedIndex < wallets.length)
                  ? wallets[selectedIndex].id
                  : wallets.first.id;
        }
      },
      orElse: () {},
    );

    final AsyncValue<Wallet>? walletAsync = currentWalletId != null
        ? ref.watch(filteredWalletProvider(
            FilterParams(
                walletId: currentWalletId!, period: _selectedPeriod.apiValue),
          ))
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                // This handle is the key to prevent the overlap
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  floating: true,
                  pinned: true,
                  title: const Text(
                    'Financial Analytics',
                    style: TextStyle(
                      color: Color(0xFF2D3142),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(170),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Track your financial performance',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                              const SizedBox(height: 12),
                              homeState.when(
                                loading: () => const SizedBox(
                                    height: 48,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                                error: (message) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Error: $message',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                ),
                                loaded: (wallets, selectedIndex) {
                                  if (wallets.isEmpty) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      child: Text(
                                        'No wallets found. Please create one.',
                                        style: TextStyle(fontFamily: 'Nunito'),
                                      ),
                                    );
                                  }
                                  return _buildWalletDropdown(
                                      wallets, currentWalletId);
                                },
                              ),
                              const SizedBox(height: 12),
                              _buildPeriodSelector(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TabBar(
                          controller: _tabController,
                          labelColor: ColorName.blue,
                          unselectedLabelColor: Colors.grey[600],
                          indicatorColor: ColorName.blue,
                          indicatorWeight: 3,
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Income'),
                            Tab(text: 'Expenses'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: currentWalletId == null || walletAsync == null
                ? Center(
                    child: homeState.maybeWhen(
                      loading: () => const CircularProgressIndicator(),
                      error: (msg) => Text("Error: $msg",
                          style: const TextStyle(
                              color: Colors.red,
                              fontFamily: 'Nunito',
                              fontSize: 16)),
                      loaded: (wallets, _) => wallets.isEmpty
                          ? const Text("No wallet available for statistics.",
                              style:
                                  TextStyle(fontFamily: 'Nunito', fontSize: 16))
                          : const Text("Loading statistics...",
                              style: TextStyle(
                                  fontFamily: 'Nunito', fontSize: 16)),
                      orElse: () => const Text("Loading wallets...",
                          style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _wrapTabContent(
                        OverviewStatisticsTab(
                          walletAsync: walletAsync,
                          walletId: currentWalletId!,
                          selectedPeriod: _selectedPeriod.apiValue,
                        ),
                      ),
                      _wrapTabContent(
                        IncomeStatisticsTab(
                          walletAsync: walletAsync,
                          walletId: currentWalletId!,
                          selectedPeriod: _selectedPeriod.apiValue,
                        ),
                      ),
                      _wrapTabContent(
                        ExpenseStatisticsTab(
                          walletAsync: walletAsync,
                          walletId: currentWalletId!,
                          selectedPeriod: _selectedPeriod.apiValue,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: ref.watch(currentNavIndexProvider),
        onTap: (index) =>
            BottomNavigationManager.handleNavigation(context, ref, index),
      ),
    );
  }

  Widget _wrapTabContent(Widget tabContent) {
    return Builder(
      builder: (BuildContext context) {
        return CustomScrollView(
          physics:
              const AlwaysScrollableScrollPhysics(), // Ensure this is scrollable
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverFillRemaining(
              // Use SliverFillRemaining instead of SliverPadding+SliverToBoxAdapter
              hasScrollBody: true, // Important to allow scrolling
              child: tabContent,
            ),
          ],
        );
      },
    );
  }

  Widget _buildWalletDropdown(List<Wallet> wallets, int? selectedWalletId) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedWalletId,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down_rounded, color: ColorName.blue),
          hint: const Text("Select Wallet",
              style: TextStyle(fontFamily: 'Nunito')),
          items: wallets.map((wallet) {
            return DropdownMenuItem<int>(
              value: wallet.id,
              child: Text(
                wallet.name,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (int? newId) {
            if (newId != null) {
              final index = wallets.indexWhere((w) => w.id == newId);
              if (index != -1) {
                ref.read(homeNotifierProvider.notifier).selectWallet(index);
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _periods.map((period) {
          final isSelected = period == _selectedPeriod;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                period.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF2D3142),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Nunito',
                ),
              ),
              selected: isSelected,
              selectedColor: ColorName.blue,
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedPeriod = period;
                  });
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
