// lib/feature/schedule/widget/edit_reminder_event_dialog.dart
import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/schedule/model/event.dart';
import 'package:expense_management_system/feature/schedule/model/event_rule.dart';
import 'package:expense_management_system/feature/schedule/provider/event_provider.dart';
import 'package:expense_management_system/feature/schedule/widget/recurrence_rule_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EditReminderEventDialog extends ConsumerStatefulWidget {
  final Event event;

  const EditReminderEventDialog({
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EditReminderEventDialog> createState() =>
      _EditReminderEventDialogState();
}

class _EditReminderEventDialogState
    extends ConsumerState<EditReminderEventDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late EventRule _eventRule;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController =
        TextEditingController(text: widget.event.description ?? '');

    // Initialize date and time
    final localDateTime = widget.event.initialTriggerDateTime.toLocal();
    _selectedDate =
        DateTime(localDateTime.year, localDateTime.month, localDateTime.day);
    _selectedTime =
        TimeOfDay(hour: localDateTime.hour, minute: localDateTime.minute);

    // Initialize recurrence rule
    _eventRule =
        widget.event.rule ?? const EventRule(frequency: EventFrequency.once);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final name = _nameController.text;
      final description = _descriptionController.text;

      // Prepare date time
      final localDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final initialTriggerDateTime = localDateTime.toUtc();

      // Create updated event
      final updatedEvent = Event(
        id: widget.event.id,
        scheduledEventId: widget.event.scheduledEventId,
        name: name,
        description: description.isNotEmpty ? description : null,
        type: EventType.reminder,
        payload: '{}',
        initialTriggerDateTime: initialTriggerDateTime,
        rule: _eventRule,
        createdAt: widget.event.createdAt,
      );

      // Save to API
      final success =
          await ref.read(eventProvider.notifier).updateEvent(updatedEvent);

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.of(context).pop();
        AppSnackBar.showSuccess(
          context: context,
          message: 'Reminder updated successfully!',
        );
      } else if (!success && mounted) {
        AppSnackBar.showError(
          context: context,
          message:
              'Failed to update reminder: ${ref.read(eventProvider).error ?? "Unknown error"}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Edit Reminder',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                onPressed: _isLoading ? null : _saveEvent,
              ),
            ],
          ),
        ),
        const Divider(),

        // Form Body
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reminder name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Reminder Name',
                      prefixIcon: Icon(Iconsax.edit),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Iconsax.note_text),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),

                  // Date time picker
                  _buildDateTimePicker(context),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Recurrence rule selector
                  RecurrenceRuleSelector(
                    value: _eventRule,
                    onChanged: (rule) {
                      setState(() => _eventRule = rule);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: theme.colorScheme.primary,
                        onPrimary: theme.colorScheme.onPrimary,
                        surface: theme.colorScheme.surface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                setState(() => _selectedDate = pickedDate);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM d, yyyy').format(_selectedDate),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: theme.colorScheme.primary,
                        onPrimary: theme.colorScheme.onPrimary,
                        surface: theme.colorScheme.surface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedTime != null) {
                setState(() => _selectedTime = pickedTime);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _selectedTime.format(context),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
