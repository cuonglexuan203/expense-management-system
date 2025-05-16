// lib/feature/event/provider/event_provider.dart
import 'dart:developer';

import 'package:expense_management_system/feature/schedule/model/event.dart';
import 'package:expense_management_system/feature/schedule/repository/event_repository.dart';
// import 'package:expense_management_system/shared/util/date_time_util.dart'; // Assuming normalizeDate exists here
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_calendar/table_calendar.dart';

part 'event_provider.freezed.dart';

@freezed
class EventState with _$EventState {
  const factory EventState({
    required DateTime focusedDay,
    DateTime? selectedDay,
    @Default(CalendarFormat.month) CalendarFormat calendarFormat,
    @Default({})
    Map<DateTime, List<Event>> events, // Events grouped by normalized date
    @Default([]) List<Event> selectedDayEvents, // Events for the selected day
    @Default(false) bool isLoading,
    String? error,
    // Track loaded date ranges to avoid redundant fetches
    DateTime? loadedStartDate,
    DateTime? loadedEndDate,
  }) = _EventState;
}

class EventNotifier extends StateNotifier<EventState> {
  final EventRepository _repository;
  final Ref _ref; // Keep ref if needed for other providers

  EventNotifier(this._repository, this._ref)
      : super(EventState(focusedDay: DateTime.now())) {
    _loadEventsForMonth(state.focusedDay);
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(state.selectedDay, selectedDay)) {
      final normalizedSelectedDay = normalizeDate(selectedDay);
      state = state.copyWith(
        selectedDay: selectedDay,
        focusedDay: focusedDay,
        selectedDayEvents: state.events[normalizedSelectedDay] ?? [],
      );
    }
  }

  void onPageChanged(DateTime focusedDay) {
    if (state.focusedDay.month != focusedDay.month ||
        state.focusedDay.year != focusedDay.year) {
      state = state.copyWith(focusedDay: focusedDay);
      _loadEventsForMonth(focusedDay); // Load data for the new visible month
    } else {
      state = state.copyWith(focusedDay: focusedDay);
    }
  }

  void onFormatChanged(CalendarFormat format) {
    if (state.calendarFormat != format) {
      state = state.copyWith(calendarFormat: format);
    }
  }

  Future<void> refreshEvents() async {
    // Clear loaded range to force reload
    state = state.copyWith(loadedStartDate: null, loadedEndDate: null);
    await _loadEventsForMonth(state.focusedDay, forceReload: true);
  }

  Future<bool> createEvent(Event event) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _repository.createEvent(event);

    return response.when(
      success: (newEvent) {
        final normalizedDate = normalizeDate(newEvent.initialTriggerDateTime);
        final updatedMap = Map<DateTime, List<Event>>.from(state.events);

        updatedMap.update(
          normalizedDate,
          (list) => [...list, newEvent]..sort((a, b) =>
              a.initialTriggerDateTime.compareTo(b.initialTriggerDateTime)),
          ifAbsent: () => [newEvent],
        );

        state = state.copyWith(
          isLoading: false,
          events: updatedMap,
          selectedDayEvents:
              isSameDay(newEvent.initialTriggerDateTime, state.selectedDay)
                  ? updatedMap[normalizedDate] ?? []
                  : state.selectedDayEvents,
        );
        return true; // Indicate success
      },
      error: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
        return false; // Indicate failure
      },
    );
  }

  Future<void> _loadEventsForMonth(DateTime date,
      {bool forceReload = false}) async {
    final firstDayOfMonth = DateTime.utc(date.year, date.month, 1);
    final lastDayOfMonth = DateTime.utc(
        date.year, date.month + 1, 0, 23, 59, 59); // End of the last day

    // Basic check to avoid redundant loading for the same month unless forced
    if (!forceReload &&
        state.loadedStartDate != null &&
        state.loadedEndDate != null &&
        !firstDayOfMonth.isBefore(state.loadedStartDate!) &&
        !lastDayOfMonth.isAfter(state.loadedEndDate!)) {
      // Data for this month range should already be loaded
      // Update selected day events if needed
      final normalizedSelectedDay =
          state.selectedDay != null ? normalizeDate(state.selectedDay!) : null;
      if (normalizedSelectedDay != null &&
          state.events.containsKey(normalizedSelectedDay)) {
        if (!isSameDay(state.selectedDay, date) ||
            state.selectedDayEvents.isEmpty) {
          state = state.copyWith(
              selectedDayEvents: state.events[normalizedSelectedDay] ?? []);
        }
      }
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final response =
        await _repository.getEvents(firstDayOfMonth, lastDayOfMonth);

    response.when(
      success: (items) {
        final newEventsMap = <DateTime, List<Event>>{};
        for (final item in items) {
          final normalizedDate = normalizeDate(item.initialTriggerDateTime);
          newEventsMap.update(
            normalizedDate,
            (list) => [...list, item]..sort((a, b) =>
                a.initialTriggerDateTime.compareTo(b.initialTriggerDateTime)),
            ifAbsent: () => [item],
          );
        }

        // Merge with existing data carefully if not forceReload
        // For simplicity here, we replace the map for the loaded month range
        // A more complex merge might be needed if loading non-contiguous ranges
        final finalMap =
            forceReload ? newEventsMap : {...state.events, ...newEventsMap};

        state = state.copyWith(
          isLoading: false,
          events: finalMap,
          selectedDayEvents: state.selectedDay != null &&
                  state.selectedDay!.month == date.month &&
                  state.selectedDay!.year == date.year
              ? finalMap[normalizeDate(state.selectedDay!)] ?? []
              : state.selectedDayEvents,
          // Update loaded range - simple approach assumes contiguous months
          loadedStartDate: forceReload
              ? firstDayOfMonth
              : (state.loadedStartDate == null
                  ? firstDayOfMonth
                  : (firstDayOfMonth.isBefore(state.loadedStartDate!)
                      ? firstDayOfMonth
                      : state.loadedStartDate)),
          loadedEndDate: forceReload
              ? lastDayOfMonth
              : (state.loadedEndDate == null
                  ? lastDayOfMonth
                  : (lastDayOfMonth.isAfter(state.loadedEndDate!)
                      ? lastDayOfMonth
                      : state.loadedEndDate)),
        );
      },
      error: (error) {
        log('Error loading events for month: ${error}');
        state = state.copyWith(isLoading: false, error: error.toString());
      },
    );
  }

  // Add these methods to EventNotifier class
  Future<bool> updateEvent(Event event) async {
    state = state.copyWith(isLoading: true, error: null);
    final response =
        await _repository.updateEvent(event.scheduledEventId, event);

    return response.when(
      success: (updatedEvent) {
        // Update the event in the events map
        final normalizedDate =
            normalizeDate(updatedEvent.initialTriggerDateTime);
        final updatedMap = Map<DateTime, List<Event>>.from(state.events);

        // Find and update the event
        for (final date in updatedMap.keys) {
          final events = updatedMap[date];
          if (events != null) {
            final index = events.indexWhere(
                (e) => e.scheduledEventId == updatedEvent.scheduledEventId);
            if (index != -1) {
              // Remove the event from its current date
              events.removeAt(index);
              if (events.isEmpty) {
                updatedMap.remove(date);
              }
              break;
            }
          }
        }

        // Add the updated event to its date (which might be different)
        updatedMap.update(
          normalizedDate,
          (list) => [...list, updatedEvent]..sort((a, b) =>
              a.initialTriggerDateTime.compareTo(b.initialTriggerDateTime)),
          ifAbsent: () => [updatedEvent],
        );

        state = state.copyWith(
          isLoading: false,
          events: updatedMap,
          selectedDayEvents:
              isSameDay(updatedEvent.initialTriggerDateTime, state.selectedDay)
                  ? updatedMap[normalizedDate] ?? []
                  : state.selectedDayEvents,
        );
        return true; // Indicate success
      },
      error: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
        return false; // Indicate failure
      },
    );
  }

  Future<bool> deleteEvent(Event event) async {
    state = state.copyWith(isLoading: true, error: null);
    final response = await _repository.deleteEvent(event.scheduledEventId);

    return response.when(
      success: (_) {
        // Remove the event from the events map
        final updatedMap = Map<DateTime, List<Event>>.from(state.events);

        // Find and remove the event
        for (final date in updatedMap.keys) {
          final events = updatedMap[date];
          if (events != null) {
            final index = events.indexWhere(
                (e) => e.scheduledEventId == event.scheduledEventId);
            if (index != -1) {
              events.removeAt(index);
              if (events.isEmpty) {
                updatedMap.remove(date);
              }
              break;
            }
          }
        }

        // Update selected day events if necessary
        final normalizedSelectedDay = state.selectedDay != null
            ? normalizeDate(state.selectedDay!)
            : null;
        final updatedSelectedDayEvents = normalizedSelectedDay != null &&
                updatedMap.containsKey(normalizedSelectedDay)
            ? updatedMap[normalizedSelectedDay]!
            : <Event>[];

        state = state.copyWith(
          isLoading: false,
          events: updatedMap,
          selectedDayEvents: updatedSelectedDayEvents,
        );
        return true; // Indicate success
      },
      error: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
        return false; // Indicate failure
      },
    );
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  return EventNotifier(ref.watch(eventRepositoryProvider), ref);
});
