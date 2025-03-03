import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature/chat/model/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF386BF6) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
              ),
            ),
            if (message.transactionAmount != null)
              Text(
                message.transactionAmount!,
                style: TextStyle(
                  color: message.isUser ? Colors.white70 : Colors.grey,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
