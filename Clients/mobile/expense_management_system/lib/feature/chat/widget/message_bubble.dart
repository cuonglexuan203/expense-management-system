import 'package:flutter/material.dart';
import 'package:expense_management_system/feature/chat/model/message.dart';
import 'package:expense_management_system/feature/chat/model/extracted_transaction.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final Function(int)? onConfirmTransaction;

  const MessageBubble({
    super.key,
    required this.message,
    this.onConfirmTransaction,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra role của message (case-insensitive)
    final isUserMessage = message.role.toLowerCase() == "user";

    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUserMessage ? ColorName.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(15).copyWith(
            bottomRight: isUserMessage ? const Radius.circular(0) : null,
            bottomLeft: !isUserMessage ? const Radius.circular(0) : null,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  color: isUserMessage ? Colors.white : Colors.black87,
                  fontFamily: 'Nunito',
                ),
              ),
              const SizedBox(height: 4),
              // Hiển thị thời gian gửi tin nhắn
              Text(
                DateFormat('HH:mm').format(message.createdAt),
                style: TextStyle(
                  color: isUserMessage
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black54,
                  fontSize: 10,
                ),
                textAlign: isUserMessage ? TextAlign.right : TextAlign.left,
              ),
              if (message.extractedTransactions.isNotEmpty)
                _buildExtractedTransactions(context),
            ],
          ),
        ),
      ),
    );
  }

  // Giữ nguyên phương thức _buildExtractedTransactions và _buildTransactionCard
  Widget _buildExtractedTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.black26),
        ...message.extractedTransactions
            .map((transaction) => _buildTransactionCard(context, transaction))
            .toList(),
      ],
    );
  }

  Widget _buildTransactionCard(
      BuildContext context, ExtractedTransaction transaction) {
    // Format currency
    final amountFormat = NumberFormat.currency(
      symbol: '',
      decimalDigits: 0,
    );

    // Determine transaction type
    String typeText = 'Unknown';
    Color typeColor = Colors.grey;

    if (transaction.type == 1) {
      typeText = 'Expense';
      typeColor = Colors.red;
    } else if (transaction.type == 2) {
      typeText = 'Income';
      typeColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    transaction.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    typeText,
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${amountFormat.format(transaction.amount)} VND',
                  style: TextStyle(
                    color: typeColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                if (transaction.confirmationStatus == 0 &&
                    onConfirmTransaction != null)
                  ElevatedButton(
                    onPressed: () =>
                        onConfirmTransaction!(transaction.chatExtractionId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorName.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
