// shared/widgets/list_item_transaction.dart
import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItemTransaction extends StatelessWidget {
  final Transaction transaction;

  const ListItemTransaction({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isExpense = transaction.type == 'Expense';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpense
              ? Colors.red.withOpacity(0.1)
              : Colors.green.withOpacity(0.1),
          child: Icon(
            isExpense ? Icons.arrow_upward : Icons.arrow_downward,
            color: isExpense ? Colors.red : Colors.green,
            size: 20,
          ),
        ),
        title: Text(
          transaction.name,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontFamily: 'Nunito'),
        ),
        subtitle: Text(
          '${transaction.categoryName ?? "Uncategorized"} • ${DateFormat('dd MMM yyyy').format(transaction.occurredAt)}',
          style: TextStyle(
              fontSize: 12, fontFamily: 'Nunito', color: Colors.grey[600]),
        ),
        trailing: Text(
          (isExpense ? '-' : '+') + transaction.amount.toFormattedString(),
          style: TextStyle(
            color: isExpense ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
