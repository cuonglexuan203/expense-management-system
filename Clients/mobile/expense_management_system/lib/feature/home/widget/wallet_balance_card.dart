import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature/wallet/model/wallet.dart';
import 'package:flutter_boilerplate/gen/colors.gen.dart';
import 'package:iconsax/iconsax.dart';

class WalletBalanceCard extends StatefulWidget {
  const WalletBalanceCard({
    required this.wallet,
    required this.onPeriodChanged,
    super.key,
  });
  final Wallet wallet;
  final Function(String) onPeriodChanged;

  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  String _selectedPeriod = 'AllTime';

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.wallet.balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Iconsax.more,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Time filter row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeFilterButton('AllTime', 'All'),
              _buildTimeFilterButton('CurrentWeek', 'Week'),
              _buildTimeFilterButton('CurrentMonth', 'Month'),
              _buildTimeFilterButton('CurrentYear', 'Year'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildIncomeExpenseItem(
                  icon: Icons.arrow_downward,
                  label: 'Income',
                  amount:
                      '\$${widget.wallet.income?.toStringAsFixed(2) ?? '0.00'}',
                  iconColor: Colors.white70,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildIncomeExpenseItem(
                  icon: Icons.arrow_upward,
                  label: 'Expenses',
                  amount:
                      '\$${widget.wallet.expense?.toStringAsFixed(2) ?? '0.00'}',
                  iconColor: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilterButton(String value, String label) {
    final isSelected = _selectedPeriod == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {
          setState(() {
            _selectedPeriod = value;
          });
          widget.onPeriodChanged(value);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            isSelected ? Colors.white : Colors.transparent,
          ),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? ColorName.blue : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseItem({
    required IconData icon,
    required String label,
    required String amount,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF386BF6),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
            ),
          ),
        ],
      ),
    );
  }
}
