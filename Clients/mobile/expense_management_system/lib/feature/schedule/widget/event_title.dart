// Event tile widget for displaying events
import 'package:expense_management_system/feature/schedule/model/event.dart';
import 'package:expense_management_system/feature/schedule/model/event_rule.dart';
import 'package:expense_management_system/feature/schedule/model/finance_payload.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:expense_management_system/shared/util/date_time_util.dart'
    as dtUtil;
import 'package:expense_management_system/shared/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback? onEditPressed;
  final VoidCallback? onDeletePressed;

  const EventTile(
      {required this.event, this.onEditPressed, this.onDeletePressed, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final time = DateFormat.jm().format(event.initialTriggerDateTime);
    final time = dtUtil.formatToLocalTime(event.initialTriggerDateTime);

    final isPastEvent = Validator.isEventInPast(event);

    // Default styling
    Color cardColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    IconData leadingIcon = Icons.event;
    Color iconColor = Colors.blue;
    String subtitle = '';

    // Style based on event type
    if (event.type == EventType.finance) {
      final financePayload = event.financePayload;

      if (financePayload != null) {
        if (financePayload.type == FinanceEventType.income) {
          iconColor = Colors.green;
          leadingIcon = Iconsax.money_recive;
          subtitle = '+${financePayload.amount.toCurrencyString()}';
          cardColor = Colors.green.shade50;
          borderColor = Colors.green.shade100;
        } else {
          iconColor = Colors.red;
          leadingIcon = Iconsax.money_send;
          subtitle = '-${financePayload.amount.toCurrencyString()}';
          cardColor = Colors.red.shade50;
          borderColor = Colors.red.shade100;
        }
      }
    } else {
      // Reminder event
      iconColor = Colors.orange;
      leadingIcon = Icons.notifications_active_outlined;
      cardColor = Colors.orange.shade50;
      borderColor = Colors.orange.shade100;
      subtitle = 'Reminder';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: borderColor),
      ),
      color: cardColor,
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(leadingIcon, color: iconColor),
        ),
        title: Text(
          event.name,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null && event.description!.isNotEmpty)
              Text(
                event.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            Text(
              subtitle,
              style: TextStyle(
                color: event.type == EventType.finance
                    ? (event.financePayload?.type == FinanceEventType.income
                        ? Colors.green
                        : Colors.red)
                    : Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getRecurrenceDescription(event.rule),
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (!isPastEvent)
              PopupMenuButton<String>(
                icon: const Icon(Iconsax.more, size: 20),
                onSelected: (value) {
                  if (value == 'edit' && onEditPressed != null) {
                    onEditPressed!();
                  } else if (value == 'delete' && onDeletePressed != null) {
                    onDeletePressed!();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Iconsax.edit, size: 20),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Iconsax.trash, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _getRecurrenceDescription(EventRule? rule) {
    if (rule == null) return 'Once';
    switch (rule.frequency) {
      // case EventFrequency.once:
      //   return 'Once';
      case EventFrequency.daily:
        if (rule.interval == 1) return 'Daily';
        return 'Every ${rule.interval} days';
      case EventFrequency.weekly:
        if (rule.interval == 1) {
          if (rule.byDayOfWeek?.isNotEmpty ?? false) {
            final days =
                rule.byDayOfWeek!.map((d) => d.substring(0, 3)).join(', ');
            return 'Weekly on $days';
          }
          return 'Weekly';
        }
        return 'Every ${rule.interval} weeks';
      case EventFrequency.monthly:
        if (rule.interval == 1) return 'Monthly';
        return 'Every ${rule.interval} months';
      case EventFrequency.yearly:
        if (rule.interval == 1) return 'Yearly';
        return 'Every ${rule.interval} years';
      default:
        return _capitalizeFirst(rule.frequency.name);
    }
  }
}
