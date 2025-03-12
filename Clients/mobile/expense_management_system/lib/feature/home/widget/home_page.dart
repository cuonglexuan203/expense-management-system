import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app/widget/bottom_nav_bar.dart';
import 'package:flutter_boilerplate/feature/home/provider/greeting_provider.dart';
import 'package:flutter_boilerplate/feature/home/provider/home_provider.dart';
import 'package:flutter_boilerplate/feature/home/state/home_state.dart';
import 'package:flutter_boilerplate/feature/home/widget/empty_balance_card.dart';
import 'package:flutter_boilerplate/feature/home/widget/transactions_section.dart';
import 'package:flutter_boilerplate/feature/home/widget/wallet_balance_card.dart';
import 'package:flutter_boilerplate/feature/home/widget/wallet_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(homeState),
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
          onRefresh: () =>
              ref.read(homeNotifierProvider.notifier).refreshWallets(),
          color: const Color(0xFF386BF6),
          child: _buildContent(homeState),
        ),
      ),
    );
  }

  Widget _buildContent(HomeState homeState) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Header Section
          _buildHeaderSection(),

          // Wallet Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildWalletSection(homeState),
          ),

          const SizedBox(height: 20),

          // Balance Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildBalanceCardSection(homeState),
          ),

          const SizedBox(height: 20),

          // Transactions Section
          const TransactionsSection(),
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
            onPressed: () {},
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
          wallet: selectedWallet,
          onPeriodChanged: (period) {
            ref
                .read(homeNotifierProvider.notifier)
                .updateWalletWithFilter(selectedWallet.id, period);
          },
        );
      },
    );
  }
}
