import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app/widget/bottom_nav_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/feature/home/provider/books_provider.dart';
import 'package:flutter_boilerplate/feature/home/widget/row_book_widget.dart';
import 'package:flutter_boilerplate/shared/http/app_exception.dart';
import 'package:flutter_boilerplate/shared/route/app_router.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF386BF6),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9DB2CE),
              Color(0xFF386BF6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good afternoon,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Enjetin Morgeana',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Wallet Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF386BF6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Wallets Row
                            Row(
                              children: [
                                // Main Wallet
                                Container(
                                  width: 120,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4B7BF9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.account_balance_wallet,
                                          color: Colors.white, size: 24),
                                      SizedBox(height: 8),
                                      Text(
                                        "Wallet's name",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '\$2,548.00',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // Add New Wallet
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,
                                          color: Colors.white, size: 24),
                                      SizedBox(height: 8),
                                      Text(
                                        'New wallet',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontFamily: 'Nunito',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Balance Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Balance',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '\$2,548.00',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_horiz,
                                      color: Colors.white),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Income/Expenses Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildIncomeExpenseItem(
                                    icon: Icons.arrow_downward,
                                    label: 'Income',
                                    amount: '\$1,840.00',
                                    iconColor: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _buildIncomeExpenseItem(
                                    icon: Icons.arrow_upward,
                                    label: 'Expenses',
                                    amount: '\$284.00',
                                    iconColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Transactions History
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Transactions History',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito',
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTransactionItem(
                        icon: 'assets/upwork.png',
                        title: 'Upwork',
                        date: 'Today',
                        amount: '+\$850.00',
                        isIncome: true,
                      ),
                      _buildTransactionItem(
                        icon: 'assets/transfer.png',
                        title: 'Transfer',
                        date: 'Yesterday',
                        amount: '-\$85.00',
                        isIncome: false,
                      ),
                      _buildTransactionItem(
                        icon: 'assets/paypal.png',
                        title: 'Paypal',
                        date: 'Jan 30, 2022',
                        amount: '+\$1,406.00',
                        isIncome: true,
                      ),
                      _buildTransactionItem(
                        icon: 'assets/youtube.png',
                        title: 'Youtube',
                        date: 'Jan 16, 2022',
                        amount: '-\$11.99',
                        isIncome: false,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            ),
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
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9DB2CE),
              Color(0xFF386BF6),
            ],
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {},
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Iconsax.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildIncomeExpenseItem({
    required IconData icon,
    required String label,
    required String amount,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String icon,
    required String title,
    required String date,
    required String amount,
    required bool isIncome,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
