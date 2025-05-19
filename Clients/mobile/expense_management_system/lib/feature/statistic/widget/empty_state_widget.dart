// shared/widgets/empty_state_widget.dart
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.icon = Icons.inbox_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Nunito',
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
