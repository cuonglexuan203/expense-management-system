import 'package:expense_management_system/feature/transaction/model/transaction.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'Income';
    final formattedDate =
        DateFormat('MMM d, yyyy').format(transaction.occurredAt);
    final categoryColor = isIncome ? Colors.green[700] : Colors.red[700];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // Implement tap handler for transaction details
            splashColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.grey.withOpacity(0.05),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  // Category icon with gradient background
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isIncome
                            ? [Colors.green[300]!, Colors.green[600]!]
                            : [Colors.red[300]!, Colors.red[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isIncome ? Colors.green[300]! : Colors.red[300]!)
                                  .withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 18),

                  // Transaction details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.name,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Category pill with hover effect
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: categoryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: categoryColor!.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            transaction.categoryName ?? "Unknown",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Amount and date with improved styling
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'}${transaction.amount.toFormattedString()}',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w800,
                          color: isIncome ? Colors.green[700] : Colors.red[700],
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.grey[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
