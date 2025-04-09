import 'package:expense_management_system/feature/wallet/model/transaction_summary.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class WalletBalanceCard extends ConsumerStatefulWidget {
  const WalletBalanceCard({
    required this.walletId,
    required this.onPeriodChanged,
    super.key,
  });
  final int walletId;
  // Update callback signature to include dates
  final Function(String period, {DateTime? fromDate, DateTime? toDate})
      onPeriodChanged;

  @override
  ConsumerState<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends ConsumerState<WalletBalanceCard> {
  String _selectedPeriod = 'AllTime';
  bool _isBalanceVisible = false;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(filteredWalletProvider(
        FilterParams(walletId: widget.walletId, period: _selectedPeriod)));

    return walletAsync.when(
      data: (wallet) => _buildCard(wallet),
      loading: () => _buildLoadingCard(),
      error: (error, stack) => _buildErrorCard(error),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorName.blue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: ColorName.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildErrorCard(Object error) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorName.blue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: ColorName.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            'Error loading data: ${error.toString()}',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Wallet wallet) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
      decoration: BoxDecoration(
        color: ColorName.blue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: ColorName.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Balance section
          LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < 380
                  ? Column(
                      children: [
                        _buildTotalBalance(wallet),
                        const SizedBox(height: 12),
                        _buildPeriodBalance(wallet),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTotalBalance(wallet),
                        _buildPeriodBalance(wallet),
                      ],
                    );
            },
          ),

          const SizedBox(height: 15),

          // Time filter row - Now with scrolling for very small screens
          // Modify the time filter row to include Custom date range
          SizedBox(
            height: 40,
            child: isSmallScreen
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildTimeFilterButton('AllTime', 'All'),
                      _buildTimeFilterButton('CurrentWeek', 'Week'),
                      _buildTimeFilterButton('CurrentMonth', 'Month'),
                      _buildTimeFilterButton('CurrentYear', 'Year'),
                      _buildTimeFilterButton('Custom', 'Range', isCustom: true),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: _buildTimeFilterButton('AllTime', 'All')),
                      Expanded(
                          child: _buildTimeFilterButton('CurrentWeek', 'Week')),
                      Expanded(
                          child:
                              _buildTimeFilterButton('CurrentMonth', 'Month')),
                      Expanded(
                          child: _buildTimeFilterButton('CurrentYear', 'Year')),
                      Expanded(
                          child: _buildTimeFilterButton('Custom', 'Range',
                              isCustom: true)),
                    ],
                  ),
          ),

          const SizedBox(height: 15),

          // Income/Expense row - Converts to column on small screens
          LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < 300
                  ? Column(
                      children: [
                        _buildIncomeExpenseItem(
                          icon: Icons.trending_up,
                          label: 'Income',
                          amount: _safeFormatAmount(wallet.income),
                          iconColor: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildIncomeExpenseItem(
                          icon: Icons.trending_down,
                          label: 'Expenses',
                          amount: _safeFormatAmount(wallet.expense),
                          iconColor: Colors.red,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildIncomeExpenseItem(
                            icon: Icons.trending_up,
                            label: 'Income',
                            amount: _safeFormatAmount(wallet.income),
                            iconColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildIncomeExpenseItem(
                            icon: Icons.trending_down,
                            label: 'Expenses',
                            amount: _safeFormatAmount(wallet.expense),
                            iconColor: Colors.red,
                          ),
                        ),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

// Helper methods for cleaner code
  Widget _buildTotalBalance(Wallet wallet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with eye icon
        Row(
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(width: 8),
            // Eye icon toggle button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isBalanceVisible = !_isBalanceVisible;
                  // Optional: Add haptic feedback
                  HapticFeedback.mediumImpact();
                });
              },
              child: Icon(
                _isBalanceVisible ? Iconsax.eye_slash : Iconsax.eye,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Balance amount (shown or hidden)
        FittedBox(
          fit: BoxFit.scaleDown,
          child: _isBalanceVisible
              ? Text(
                  wallet.balance.toFormattedString() ?? '0',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  '* * * * * *',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    fontFamily: 'Nunito',
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPeriodBalance(Wallet wallet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Balance By Period',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito',
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: _isBalanceVisible
              ? Text(
                  wallet.balanceByPeriod.toFormattedString() ?? '0',
                  style: TextStyle(
                    color: wallet.balanceByPeriod < 0
                        ? Colors.red
                        : ColorName.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  '* * * * * *',
                  style: TextStyle(
                    color: wallet.balanceByPeriod < 0
                        ? Colors.red
                        : ColorName.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                    fontFamily: 'Nunito',
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _fromDate != null && _toDate != null
          ? DateTimeRange(start: _fromDate!, end: _toDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorName.blue,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fromDate = picked.start;
        _toDate = picked.end;
        _selectedPeriod = 'Custom';
      });

      widget.onPeriodChanged(
        'Custom',
        fromDate: _fromDate,
        toDate: _toDate,
      );
    }
  }

  // Widget _buildTimeFilterButton(String value, String label) {
  //   final isSelected = _selectedPeriod == value;
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 4),
  //     child: TextButton(
  //       onPressed: () {
  //         setState(() {
  //           _selectedPeriod = value;
  //         });
  //         widget.onPeriodChanged(value);
  //       },
  //       style: ButtonStyle(
  //         backgroundColor: MaterialStateProperty.all(
  //           isSelected ? Colors.white : Colors.transparent,
  //         ),
  //         padding: MaterialStateProperty.all(
  //             EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
  //         shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         )),
  //       ),
  //       child: Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 13,
  //           color: isSelected ? ColorName.blue : Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTimeFilterButton(String value, String label,
      {bool isCustom = false}) {
    final isSelected =
        _selectedPeriod == value || (isCustom && _selectedPeriod == 'Custom');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: () {
          if (isCustom) {
            _showDateRangePicker();
          } else {
            setState(() {
              _selectedPeriod = value;
              _fromDate = null;
              _toDate = null;
            });
            widget.onPeriodChanged(value);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected ? Colors.white : Colors.transparent,
          ),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 6, vertical: 6)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
        ),
        child: isCustom &&
                _selectedPeriod == 'Custom' &&
                _fromDate != null &&
                _toDate != null
            ? Text(
                '${_formatDate(_fromDate!)} - ${_formatDate(_toDate!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? ColorName.blue : Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? ColorName.blue : Colors.white,
                ),
              ),
      ),
    );
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  Widget _buildIncomeExpenseItem({
    required IconData icon,
    required String label,
    required String amount,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF386BF6),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Responsive row for icon and label
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 140;

              return isNarrow
                  ? Column(
                      children: [
                        _buildIconContainer(icon, iconColor),
                        const SizedBox(height: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildIconContainer(icon, iconColor),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ],
                    );
            },
          ),
          const SizedBox(height: 8),
          // Amount text with overflow handling
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

// Helper method for icon container
  Widget _buildIconContainer(IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 20, // Smaller icon size
      ),
    );
  }
}

String _safeFormatAmount(TransactionSummary? summary) {
  if (summary == null || summary.totalAmount == null) return '0';
  return summary.totalAmount.toFormattedString();
}
