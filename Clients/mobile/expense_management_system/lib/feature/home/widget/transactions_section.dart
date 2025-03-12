import 'package:flutter/material.dart';
import 'transaction_item.dart';

class TransactionsSection extends StatelessWidget {
  const TransactionsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const TransactionItem(
            icon: 'assets/upwork.png',
            title: 'Upwork',
            date: 'Today',
            amount: '+\$850.00',
            isIncome: true,
          ),
          const TransactionItem(
            icon: 'assets/transfer.png',
            title: 'Transfer',
            date: 'Yesterday',
            amount: '-\$85.00',
            isIncome: false,
          ),
          const TransactionItem(
            icon: 'assets/paypal.png',
            title: 'Paypal',
            date: 'Jan 30, 2022',
            amount: '+\$1,406.00',
            isIncome: true,
          ),
          const TransactionItem(
            icon: 'assets/youtube.png',
            title: 'Youtube',
            date: 'Jan 16, 2022',
            amount: '-\$11.99',
            isIncome: false,
          ),
        ],
      ),
    );
  }
}
