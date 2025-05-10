// lib/feature/event/repository/event_repository.dart
import 'dart:convert';
import 'dart:developer';

import 'package:expense_management_system/feature/schedule/model/event.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class EventRepository {
  Future<APIResponse<List<Event>>> getEvents(DateTime start, DateTime end);
  Future<APIResponse<Event>> createEvent(Event event);
  Future<APIResponse<Event>> updateEvent(dynamic id, Event event);
  Future<APIResponse<bool>> deleteEvent(dynamic id);
}

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepositoryImpl(ref.watch(apiProvider));
});

class EventRepositoryImpl implements EventRepository {
  final ApiProvider _api;

  EventRepositoryImpl(this._api);

  // @override
  // Future<APIResponse<List<Event>>> getEvents(
  //     DateTime start, DateTime end) async {
  //   try {
  //     final query = {
  //       'FromUtc': start.toUtc().toIso8601String(),
  //       'ToUtc': end.toUtc().toIso8601String(),
  //     };

  //     final response =
  //         await _api.get(ApiEndpoints.event.getOccurrences, query: query);

  //     return response.when(
  //       success: (data) {
  //         if (data is List) {
  //           final events = data
  //               .map((itemJson) =>
  //                   Event.fromJson(itemJson as Map<String, dynamic>))
  //               .toList();
  //           return APIResponse.success(events);
  //         } else {
  //           log('Invalid response format: ${data.runtimeType} for getEvents');
  //           return const APIResponse.error(AppException.errorWithMessage(
  //               'Invalid response format: expected List of events'));
  //         }
  //       },
  //       error: (error) => APIResponse.error(error),
  //     );
  //   } catch (e) {
  //     log('Error fetching events: $e');
  //     if (e is AppException) {
  //       return APIResponse.error(e);
  //     }
  //     return APIResponse.error(AppException.errorWithMessage(
  //         'Failed to load events: ${e.toString()}'));
  //   }
  // }

  @override
  Future<APIResponse<List<Event>>> getEvents(
      DateTime start, DateTime end) async {
    try {
      final query = {
        'FromUtc': start.toUtc().toIso8601String(),
        'ToUtc': end.toUtc().toIso8601String(),
      };

      final response =
          await _api.get(ApiEndpoints.event.getOccurrences, query: query);

      return response.when(
        success: (data) {
          if (data is List) {
            final events = data.map((itemJson) {
              // Convert field names to match your model
              Map<String, dynamic> convertedJson =
                  Map<String, dynamic>.from(itemJson as Map<String, dynamic>);

              // Map eventType to type
              if (convertedJson.containsKey('eventType')) {
                convertedJson['type'] = convertedJson['eventType'];
                convertedJson.remove('eventType');
              }

              // Map scheduledTime to initialTrigger
              if (convertedJson.containsKey('scheduledTime')) {
                convertedJson['initialTrigger'] =
                    convertedJson['scheduledTime'];
                convertedJson.remove('scheduledTime');
              }

              try {
                return Event.fromJson(convertedJson);
              } catch (e) {
                log('Error parsing event: $e');
                throw AppException.errorWithMessage(
                    'Failed to parse event: $e');
              }
            }).toList();

            return APIResponse.success(events);
          } else {
            log('Invalid response format: ${data.runtimeType} for getEvents');
            return const APIResponse.error(AppException.errorWithMessage(
                'Invalid response format: expected List of events'));
          }
        },
        error: (error) => APIResponse.error(error),
      );
    } catch (e) {
      log('Error fetching events: $e');
      if (e is AppException) {
        return APIResponse.error(e);
      }
      return APIResponse.error(AppException.errorWithMessage(
          'Failed to load events: ${e.toString()}'));
    }
  }

  @override
  Future<APIResponse<Event>> createEvent(Event event) async {
    try {
      final Map<String, dynamic> eventJson = event.toJson();

      eventJson.remove('id');
      eventJson.remove('createdAt');
      eventJson.remove('updatedAt');

      if (eventJson.containsKey('initialTrigger')) {
        eventJson['InitialTriggerDateTime'] = eventJson['initialTrigger'];
        eventJson.remove('initialTrigger');
      }

      if (eventJson.containsKey('recurrenceRule')) {
        final ruleData = eventJson['recurrenceRule'];

        if (ruleData is Map<String, dynamic> &&
            ruleData.containsKey('frequency') &&
            ruleData['frequency'] == 'Once') {
          eventJson['rule'] = null;
        } else if (ruleData is Map<String, dynamic>) {
          ruleData['interval'] = ruleData['interval'] ?? 1;
          ruleData['byDayOfWeek'] = ruleData['byDayOfWeek'] ?? [];
          ruleData['byMonthDay'] = ruleData['byMonthDay'] ?? [];
          ruleData['byMonth'] = ruleData['byMonth'] ?? [];

          eventJson['rule'] = ruleData;
        }

        eventJson.remove('recurrenceRule');
      }

      final response = await _api.post(ApiEndpoints.event.create, eventJson);

      return response.when(
        success: (data) {
          if (data is Map) {
            try {
              final createdEvent = Event.fromJson(data as Map<String, dynamic>);
              return APIResponse.success(createdEvent);
            } catch (e) {
              log('Error parsing created event: $e');
              return APIResponse.error(AppException.errorWithMessage(
                  'Failed to parse server response: $e'));
            }
          } else {
            log('Expected Map but got ${data.runtimeType} for createEvent');
            return const APIResponse.error(AppException.errorWithMessage(
                'Invalid response format: Expected Map'));
          }
        },
        error: (error) => APIResponse.error(error),
      );
    } catch (e) {
      log('Error creating event: $e');
      if (e is AppException) {
        return APIResponse.error(e);
      }
      return APIResponse.error(AppException.errorWithMessage(
          'Failed to create event: ${e.toString()}'));
    }
  }

  @override
  Future<APIResponse<Event>> updateEvent(dynamic id, Event event) async {
    try {
      final Map<String, dynamic> eventJson = event.toJson();

      // Remove fields that shouldn't be sent in update
      // eventJson.remove('id');
      eventJson.remove('createdAt');
      eventJson.remove('updatedAt');

      // Handle initialTrigger field name difference
      if (eventJson.containsKey('initialTrigger')) {
        eventJson['InitialTriggerDateTime'] = eventJson['initialTrigger'];
        eventJson.remove('initialTrigger');
      }

      // Handle recurrenceRule field name difference
      if (eventJson.containsKey('recurrenceRule')) {
        final ruleData = eventJson['recurrenceRule'];

        if (ruleData is Map<String, dynamic> &&
            ruleData.containsKey('frequency') &&
            ruleData['frequency'] == 'Once') {
          eventJson['rule'] = null;
        } else if (ruleData is Map<String, dynamic>) {
          ruleData['interval'] = ruleData['interval'] ?? 1;
          ruleData['byDayOfWeek'] = ruleData['byDayOfWeek'] ?? [];
          ruleData['byMonthDay'] = ruleData['byMonthDay'] ?? [];
          ruleData['byMonth'] = ruleData['byMonth'] ?? [];

          eventJson['rule'] = ruleData;
        }

        eventJson.remove('recurrenceRule');
      }

      final response = await _api.put(
          '${ApiEndpoints.event.base}/${event.scheduledEventId}', eventJson);

      return response.when(
        success: (data) {
          if (data is Map) {
            try {
              final updatedEvent = Event.fromJson(data as Map<String, dynamic>);
              return APIResponse.success(updatedEvent);
            } catch (e) {
              log('Error parsing updated event: $e');
              return APIResponse.error(AppException.errorWithMessage(
                  'Failed to parse server response: $e'));
            }
          } else {
            log('Expected Map but got ${data.runtimeType} for updateEvent');
            return const APIResponse.error(AppException.errorWithMessage(
                'Invalid response format: Expected Map'));
          }
        },
        error: (error) => APIResponse.error(error),
      );
    } catch (e) {
      log('Error updating event: $e');
      if (e is AppException) {
        return APIResponse.error(e);
      }
      return APIResponse.error(AppException.errorWithMessage(
          'Failed to update event: ${e.toString()}'));
    }
  }

  @override
  Future<APIResponse<bool>> deleteEvent(dynamic id) async {
    try {
      final response = await _api.delete('${ApiEndpoints.event.base}/$id');

      return response.when(
        success: (_) {
          return const APIResponse.success(true);
        },
        error: (error) => APIResponse.error(error),
      );
    } catch (e) {
      log('Error deleting event: $e');
      if (e is AppException) {
        return APIResponse.error(e);
      }
      return APIResponse.error(AppException.errorWithMessage(
          'Failed to delete event: ${e.toString()}'));
    }
  }
}
