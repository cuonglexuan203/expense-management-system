// lib/feature/schedule/widget/schedule_page.dart
import 'dart:convert';
import 'dart:developer';

import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/app/widget/bottom_nav_bar.dart';
import 'package:expense_management_system/feature/category/provider/category_provider.dart'; // Assume exists
import 'package:expense_management_system/feature/home/provider/home_provider.dart'; // Assume exists
import 'package:expense_management_system/feature/schedule/model/event.dart';
import 'package:expense_management_system/feature/schedule/model/event_rule.dart';
import 'package:expense_management_system/feature/schedule/model/finance_payload.dart';
import 'package:expense_management_system/feature/schedule/provider/event_provider.dart';
import 'package:expense_management_system/feature/schedule/widget/category_selector.dart';
import 'package:expense_management_system/feature/schedule/widget/edit_finance_event_dialog.dart';
import 'package:expense_management_system/feature/schedule/widget/edit_reminder_event_dialog.dart';
import 'package:expense_management_system/feature/schedule/widget/error_field.dart';
import 'package:expense_management_system/feature/schedule/widget/event_title.dart';
import 'package:expense_management_system/feature/schedule/widget/loading_field.dart';
import 'package:expense_management_system/feature/schedule/widget/recurrence_rule_selector.dart';
import 'package:expense_management_system/feature/schedule/widget/wallet_selector.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:expense_management_system/shared/util/bottom_nav_bar_manager.dart';
import 'package:expense_management_system/shared/util/date_time_util.dart'
    as dtUtil;
import 'package:expense_management_system/shared/util/validator.dart';
import 'package:expense_management_system/shared/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// Assume these exist for wallet/category selection
import 'package:expense_management_system/feature/category/model/category.dart'; // Placeholder

class SchedulePage extends ConsumerWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(eventProvider);
    final notifier = ref.read(eventProvider.notifier);
    final theme = Theme.of(context);

    List<Event> eventsLoader(DateTime day) {
      final normalizedLocalDay = dtUtil.normalizeDate(day);
      final events = state.events[normalizedLocalDay] ?? [];
      return events;
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB7C5E1),
            Color(0xFF4B7BF9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(eventProvider.notifier).refreshEvents(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Color(0xFFF8FAFD),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Schedule',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Nunito',
                                      color: Color(0xFF2D3142),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 4,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: ColorName.blue,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Tooltip(
                                message:
                                    'Long press or double tap on a day to add an event',
                                child: IconButton(
                                  icon: const Icon(Icons.help_outline,
                                      color: ColorName.blue, size: 24),
                                  color: ColorName.blue,
                                  iconSize: 24,
                                  onPressed: () {
                                    _showHelpDialog(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Plan your financial future',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Nunito',
                              color: const Color(0xFF2D3142).withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Material(
                    elevation: 2.0,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16.0)),
                    color: theme.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 16.0),
                      child: TableCalendar<Event>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: state.focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(state.selectedDay, day),
                        calendarFormat: state.calendarFormat,
                        eventLoader: eventsLoader,
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: CalendarStyle(
                          outsideDaysVisible: false,
                          todayDecoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          markersMaxCount: 3,
                          markerSize: 5.0,
                          markerMargin: const EdgeInsets.symmetric(
                              horizontal: 1.0, vertical: 4.0),
                          weekendTextStyle: TextStyle(
                              color:
                                  theme.colorScheme.primary.withOpacity(0.7)),
                          defaultTextStyle: TextStyle(
                              color: theme.textTheme.bodyLarge?.color),
                          selectedTextStyle:
                              TextStyle(color: theme.colorScheme.onPrimary),
                          todayTextStyle:
                              TextStyle(color: theme.colorScheme.primary),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: true,
                          titleCentered: true,
                          titleTextStyle: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                          formatButtonTextStyle: TextStyle(
                              color: theme.colorScheme.primary, fontSize: 14),
                          formatButtonDecoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          leftChevronIcon: Icon(Icons.chevron_left,
                              color: theme.iconTheme.color),
                          rightChevronIcon: Icon(Icons.chevron_right,
                              color: theme.iconTheme.color),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.6),
                              fontSize: 13),
                          weekendStyle: TextStyle(
                              color: theme.colorScheme.primary.withOpacity(0.6),
                              fontSize: 13),
                        ),
                        onDaySelected: notifier.onDaySelected,
                        onPageChanged: notifier.onPageChanged,
                        onFormatChanged: notifier.onFormatChanged,
                        availableGestures: AvailableGestures.all,
                        onDayLongPressed: (selectedDay, focusedDay) {
                          notifier.onDaySelected(selectedDay, focusedDay);
                          // _showQuickActionSheet(context, ref);
                          _showAddEventDialog(context, ref, EventType.finance);
                        },
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            return GestureDetector(
                              onDoubleTap: () {
                                notifier.onDaySelected(day, focusedDay);
                                // _showQuickActionSheet(context, ref);
                                _showAddEventDialog(
                                    context, ref, EventType.finance);
                              },
                              child: Center(
                                child: Text(
                                  '${day.day}',
                                  style: TextStyle(
                                      color: theme.textTheme.bodyLarge?.color),
                                ),
                              ),
                            );
                          },
                          selectedBuilder: (context, day, focusedDay) {
                            return GestureDetector(
                              onDoubleTap: () {
                                // _showQuickActionSheet(context, ref);
                                _showAddEventDialog(
                                    context, ref, EventType.finance);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary,
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                        color: theme.colorScheme.onPrimary),
                                  ),
                                ),
                              ),
                            );
                          },
                          todayBuilder: (context, day, focusedDay) {
                            return GestureDetector(
                              onDoubleTap: () {
                                notifier.onDaySelected(day, focusedDay);
                                // _showQuickActionSheet(context, ref);
                                _showAddEventDialog(
                                    context, ref, EventType.finance);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                        color: theme.colorScheme.primary),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (state.selectedDay != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat.yMMMMd().format(state.selectedDay!),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (!state.isLoading && state.error == null)
                            _buildItemCountChip(
                                context, state.selectedDayEvents.length),
                        ],
                      ),
                    ),
                  ),
                if (state.isLoading &&
                    state.events.isEmpty &&
                    state.error == null)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: LoadingWidget()),
                  )
                else if (state.error != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child:
                        _buildErrorIndicator(context, state.error!, notifier),
                  )
                else if (state.isLoading && state.error == null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state.error == null &&
                    !(state.isLoading && state.events.isEmpty))
                  _buildEventListSliver(context, ref, state.selectedDayEvents),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: ref.watch(currentNavIndexProvider),
          onTap: (index) =>
              BottomNavigationManager.handleNavigation(context, ref, index),
        ),
      ),
    );
  }

  Widget _buildEventListSliver(
      BuildContext context, WidgetRef ref, List<Event> items) {
    if (items.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 50, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No events scheduled',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Text(
                  'Long press or double tap on this day to add an event.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey.shade500),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add Event',
                      style: TextStyle(color: Colors.white)),
                  // onPressed: () => _showQuickActionSheet(context, ref),
                  onPressed: () =>
                      _showAddEventDialog(context, ref, EventType.finance),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorName.blue, // màu nền xanh
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // tuỳ chọn bo góc
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = items[index];
            return EventTile(
              event: item,
              onEditPressed: () => _showEditEventDialog(context, ref, item),
              onDeletePressed: () =>
                  _showDeleteConfirmation(context, ref, item),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

  Widget _buildItemCountChip(BuildContext context, int count) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: count > 0
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Text(
        '$count ${count == 1 ? 'event' : 'events'}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: count > 0 ? theme.colorScheme.primary : Colors.grey.shade600,
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline,
                color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 8),
            const Text('Schedule Tips'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              context,
              icon: Icons.touch_app,
              title: 'Long press on any day',
              description: 'to quickly add a new event',
            ),
            const SizedBox(height: 12),
            _buildHelpItem(
              context,
              icon: Icons.touch_app_outlined,
              title: 'Double tap on any day',
              description: 'to quickly add a new event',
            ),
            // Removed swipe/tap to edit/delete hints
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it',
                style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showQuickActionSheet(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDate = ref.read(eventProvider).selectedDay;

    if (selectedDate == null) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Important for taller content like dialogs
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Add for ${DateFormat.yMMMMd().format(selectedDate)}',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const Divider(),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Icon(Icons.attach_money, color: Colors.blue),
              ),
              title: const Text('Add Finance Event'),
              onTap: () {
                Navigator.pop(context);
                _showAddEventDialog(context, ref, EventType.finance);
              },
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.withOpacity(0.1),
                child: const Icon(Icons.notifications_active_outlined,
                    color: Colors.orange),
              ),
              title: const Text('Add Reminder'),
              onTap: () {
                Navigator.pop(context);
                _showAddEventDialog(context, ref, EventType.reminder);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIndicator(
      BuildContext context, String message, EventNotifier notifier) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 60;

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined,
                color: Theme.of(context).colorScheme.error, size: 50),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Schedule',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message, // Display the actual error message
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () => notifier.refreshEvents(),
              style: ElevatedButton.styleFrom(
                foregroundColor: ColorName.white,
                backgroundColor: ColorName.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAddEventDialog(
      BuildContext context, WidgetRef ref, EventType initialType) {
    final selectedDate = ref.read(eventProvider).selectedDay ?? DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: _AddEventDialog(
          initialSelectedDate: selectedDate,
          initialEventType: initialType,
        ),
      ),
    );
  }

  // Add this method to the SchedulePage class
  void _showEditEventDialog(BuildContext context, WidgetRef ref, Event event) {
    // Check if event is in the past
    if (Validator.isEventInPast(event)) {
      AppSnackBar.showWarning(
        context: context,
        message: 'Past events cannot be edited',
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: event.type == EventType.finance
            ? EditFinanceEventDialog(event: event)
            : EditReminderEventDialog(event: event),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, WidgetRef ref, Event event) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              final notifier = ref.read(eventProvider.notifier);
              final success = await notifier.deleteEvent(event);

              if (success && context.mounted) {
                AppSnackBar.showSuccess(
                  context: context,
                  message: 'Event deleted successfully!',
                );
              } else if (context.mounted) {
                AppSnackBar.showError(
                  context: context,
                  message:
                      'Failed to delete event: ${ref.read(eventProvider).error ?? "Unknown error"}',
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// --- New Add Event Dialog Widget ---
class _AddEventDialog extends ConsumerStatefulWidget {
  final DateTime initialSelectedDate;
  final EventType initialEventType;
  final Event? event; // Add this parameter for editing mode

  const _AddEventDialog({
    required this.initialSelectedDate,
    required this.initialEventType,
    this.event, // Optional - if provided, we're in edit mode
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<_AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends ConsumerState<_AddEventDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  late EventRule _eventRule;

  // Common fields
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  TimeOfDay? _selectedTime;

  // Finance specific fields
  final _amountController = TextEditingController();
  FinanceEventType _financeType = FinanceEventType.expense;
  Wallet? _selectedWallet; // Assume Wallet model exists
  Category? _selectedCategory; // Assume Category model exists

  // State
  bool _isLoading = false;

  //
  late bool _isEditMode;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.event != null;
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: widget.initialEventType.index);
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();

    _eventRule = const EventRule(
      frequency: EventFrequency.once,
    );

    // If in edit mode, populate fields with existing event data
    if (_isEditMode) {
      final event = widget.event!;
      _nameController.text = event.name;
      if (event.description != null) {
        _descriptionController.text = event.description!;
      }

      // Convert UTC to local for display
      final localDateTime = event.initialTriggerDateTime.toLocal();
      _selectedDate =
          DateTime(localDateTime.year, localDateTime.month, localDateTime.day);
      _selectedTime =
          TimeOfDay(hour: localDateTime.hour, minute: localDateTime.minute);

      // Set the event rule
      // _eventRule = event.rule!;

      // Populate finance-specific fields if it's a finance event
      if (event.type == EventType.finance) {
        final financePayload = event.financePayload;
        if (financePayload != null) {
          _financeType = financePayload.type;
          _amountController.text = financePayload.amount.toString();

          // We'll need to fetch the wallet and category separately
          // They'll be loaded later when the wallet/category providers are ready
        }
      }
    } else {
      // Normal initialization for new events
      _selectedDate = widget.initialSelectedDate;
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final name = _nameController.text;
      final description = _descriptionController.text;
      final time = _selectedTime ?? const TimeOfDay(hour: 0, minute: 0);

      final localDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        time.hour,
        time.minute,
      );

      final initialTriggerDateTime = localDateTime.toUtc();

      Event? newEvent;
      final currentTab =
          _tabController.index == 0 ? EventType.finance : EventType.reminder;

      if (currentTab == EventType.finance) {
        // Finance logic...
        final amount = double.tryParse(_amountController.text);
        if (amount == null ||
            _selectedWallet == null ||
            _selectedCategory == null) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //       content: Text(
          //           'Please fill all finance details (Amount, Wallet, Category)'),
          //       backgroundColor: Colors.red),
          // );
          AppSnackBar.showError(
            context: context,
            message:
                'Please fill all finance details (Amount, Wallet, Category)',
          );
          setState(() => _isLoading = false);
          return;
        }

        final financePayload = FinancePayload(
          type: _financeType,
          amount: amount,
          walletId: _selectedWallet!.id!,
          categoryId: _selectedCategory!.id!,
        );

        newEvent = Event(
          // If editing, keep the original ID, otherwise it will be assigned by the API
          id: _isEditMode ? widget.event!.id : null,
          name: name,
          description: description.isNotEmpty ? description : null,
          type: EventType.finance,
          payload: jsonEncode(financePayload.toJson()),
          initialTriggerDateTime: initialTriggerDateTime,
          rule: _eventRule,
        );
      } else {
        // Reminder Tab
        newEvent = Event(
          id: _isEditMode ? widget.event!.id : null,
          name: name,
          description: description.isNotEmpty ? description : null,
          type: EventType.reminder,
          payload: '{}',
          initialTriggerDateTime: initialTriggerDateTime,
          rule: _eventRule,
        );
      }

      bool success;
      if (_isEditMode) {
        success = await ref.read(eventProvider.notifier).updateEvent(newEvent);
      } else {
        success = await ref.read(eventProvider.notifier).createEvent(newEvent);
      }

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.of(context).pop();
        AppSnackBar.showSuccess(
          context: context,
          message: _isEditMode
              ? 'Event updated successfully!'
              : 'Event created successfully!',
        );
      } else if (!success && mounted) {
        AppSnackBar.showError(
          context: context,
          message: _isEditMode
              ? 'Failed to update event: ${ref.read(eventProvider).error ?? "Unknown error"}'
              : 'Failed to create event: ${ref.read(eventProvider).error ?? "Unknown error"}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  _isEditMode ? 'Edit Event' : 'Add New Event',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
        TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'Finance', icon: Icon(Icons.attach_money)),
            Tab(
                text: 'Reminder',
                icon: Icon(Icons.notifications_active_outlined)),
          ],
        ),
        Expanded(
          child: Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildFinanceTab(context),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildReminderTab(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinanceTab(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Event Name',
            prefixIcon: Icon(Iconsax.edit),
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Name is required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            prefixIcon: Icon(Iconsax.note_text),
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        SegmentedButton<FinanceEventType>(
          segments: const [
            ButtonSegment(
                value: FinanceEventType.expense,
                label: Text('Expense'),
                icon: Icon(Icons.arrow_downward_rounded,
                    color: Colors.redAccent)),
            ButtonSegment(
                value: FinanceEventType.income,
                label: Text('Income'),
                icon: Icon(Icons.arrow_upward_rounded, color: Colors.green)),
          ],
          selected: {_financeType},
          onSelectionChanged: (newSelection) {
            setState(() {
              _financeType = newSelection.first;
              // Reset category selection if filtering is based on type
              _selectedCategory = null;
            });
          },
          style: SegmentedButton.styleFrom(
            selectedForegroundColor: _financeType == FinanceEventType.expense
                ? Colors.redAccent
                : Colors.green,
            selectedBackgroundColor: _financeType == FinanceEventType.expense
                ? Colors.redAccent.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            labelText: 'Amount',
            prefixIcon: Icon(Icons.monetization_on_outlined,
                color: _financeType == FinanceEventType.expense
                    ? Colors.redAccent
                    : Colors.green),
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Amount is required';
            }
            if (double.tryParse(value) == null) {
              return 'Invalid amount';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        WalletSelector(
          // Placeholder Widget
          selectedWallet: _selectedWallet,
          onChanged: (wallet) => setState(() => _selectedWallet = wallet),
        ),
        const SizedBox(height: 12),
        CategorySelector(
          // Placeholder Widget
          selectedCategory: _selectedCategory,
          financeType: _financeType, // Pass type for filtering
          onChanged: (category) => setState(() => _selectedCategory = category),
        ),
        const SizedBox(height: 12),
        _buildDateTimePicker(context),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        RecurrenceRuleSelector(
          value: _eventRule,
          onChanged: (rule) {
            setState(() => _eventRule = rule);
          },
        ),
      ],
    );
  }

  Widget _buildReminderTab(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Reminder Name',
            prefixIcon: Icon(Iconsax.edit),
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Name is required' : null,
        ),
        const SizedBox(height: 12),
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
        _buildDateTimePicker(context),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        RecurrenceRuleSelector(
          value: _eventRule,
          onChanged: (rule) {
            setState(() => _eventRule = rule);
          },
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
                initialTime: _selectedTime ?? TimeOfDay.now(),
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
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Select time',
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
