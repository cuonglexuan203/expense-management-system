import 'dart:developer';

import 'package:intl/intl.dart';

/// Parses a non-null JSON string into a non-nullable DateTime object.
///
/// Throws [FormatException] if the input string is invalid.
DateTime dateTimeFromJsonNonNull(String json) {
  final parsedDate = DateTime.tryParse(json);
  if (parsedDate == null) {
    throw FormatException(
        'Expected non-nullable DateTime string but got invalid: "$json"');
  }
  return parsedDate;
}

/// Converts a non-nullable DateTime to ISO 8601 string.
String dateTimeToJson(DateTime dateTime) {
  return dateTime.toIso8601String();
}

/// Parses a nullable JSON string into a nullable DateTime object.
///
/// Returns null if the input is null or parsing fails.
DateTime? dateTimeFromJsonNullable(String? json) {
  if (json == null) return null;
  try {
    final parsedDate = DateTime.tryParse(json);
    if (parsedDate == null && json.isNotEmpty) {
      log('Could not parse DateTime from non-empty JSON string: "$json"');
    }
    return parsedDate;
  } catch (e, stackTrace) {
    log('Unexpected error parsing nullable DateTime: "$json"',
        error: e, stackTrace: stackTrace);
    return null;
  }
}

/// Converts a nullable DateTime to ISO 8601 string.
///
/// Returns null if the input is null.
String? dateTimeToJsonNullable(DateTime? dateTime) {
  return dateTime?.toIso8601String();
}

/// Returns a DateTime normalized to midnight UTC (Y/M/D only).
DateTime normalizeDate(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day);
}

DateTime utcToLocal(DateTime utcDateTime) {
  return utcDateTime.toLocal();
}

String formatToLocalTime(DateTime dateTime, {String format = 'jm'}) {
  final localDateTime = dateTime.isUtc ? utcToLocal(dateTime) : dateTime;
  return DateFormat(format).format(localDateTime);
}
