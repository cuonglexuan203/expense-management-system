import 'package:expense_management_system/feature/notification/models/app_notification.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationTile({
    Key? key,
    required this.notification,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set icon and color based on notification type
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'EventReminder':
        iconData = Iconsax.calendar;
        iconColor = Colors.orange;
        break;
      case 'TransactionAlert':
        iconData = Iconsax.money_recive;
        iconColor = Colors.green;
        break;
      case 'SystemMessage':
        iconData = Iconsax.info_circle;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Iconsax.notification;
        iconColor = Colors.grey;
    }

    final bool isRead = notification.status != "Sent";

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : Colors.blue.shade50.withOpacity(0.3),
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Icon(iconData, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a')
                        .format(notification.createdAt.toLocal()),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            if (!isRead)
              Container(
                width: 10.0,
                height: 10.0,
                margin: const EdgeInsets.only(top: 8.0, left: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
