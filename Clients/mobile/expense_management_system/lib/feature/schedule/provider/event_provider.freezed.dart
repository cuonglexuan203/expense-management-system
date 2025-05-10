// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EventState {
  DateTime get focusedDay => throw _privateConstructorUsedError;
  DateTime? get selectedDay => throw _privateConstructorUsedError;
  CalendarFormat get calendarFormat => throw _privateConstructorUsedError;
  Map<DateTime, List<Event>> get events =>
      throw _privateConstructorUsedError; // Events grouped by normalized date
  List<Event> get selectedDayEvents =>
      throw _privateConstructorUsedError; // Events for the selected day
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error =>
      throw _privateConstructorUsedError; // Track loaded date ranges to avoid redundant fetches
  DateTime? get loadedStartDate => throw _privateConstructorUsedError;
  DateTime? get loadedEndDate => throw _privateConstructorUsedError;

  /// Create a copy of EventState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventStateCopyWith<EventState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventStateCopyWith<$Res> {
  factory $EventStateCopyWith(
          EventState value, $Res Function(EventState) then) =
      _$EventStateCopyWithImpl<$Res, EventState>;
  @useResult
  $Res call(
      {DateTime focusedDay,
      DateTime? selectedDay,
      CalendarFormat calendarFormat,
      Map<DateTime, List<Event>> events,
      List<Event> selectedDayEvents,
      bool isLoading,
      String? error,
      DateTime? loadedStartDate,
      DateTime? loadedEndDate});
}

/// @nodoc
class _$EventStateCopyWithImpl<$Res, $Val extends EventState>
    implements $EventStateCopyWith<$Res> {
  _$EventStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusedDay = null,
    Object? selectedDay = freezed,
    Object? calendarFormat = null,
    Object? events = null,
    Object? selectedDayEvents = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? loadedStartDate = freezed,
    Object? loadedEndDate = freezed,
  }) {
    return _then(_value.copyWith(
      focusedDay: null == focusedDay
          ? _value.focusedDay
          : focusedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDay: freezed == selectedDay
          ? _value.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      calendarFormat: null == calendarFormat
          ? _value.calendarFormat
          : calendarFormat // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, List<Event>>,
      selectedDayEvents: null == selectedDayEvents
          ? _value.selectedDayEvents
          : selectedDayEvents // ignore: cast_nullable_to_non_nullable
              as List<Event>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loadedStartDate: freezed == loadedStartDate
          ? _value.loadedStartDate
          : loadedStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loadedEndDate: freezed == loadedEndDate
          ? _value.loadedEndDate
          : loadedEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventStateImplCopyWith<$Res>
    implements $EventStateCopyWith<$Res> {
  factory _$$EventStateImplCopyWith(
          _$EventStateImpl value, $Res Function(_$EventStateImpl) then) =
      __$$EventStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime focusedDay,
      DateTime? selectedDay,
      CalendarFormat calendarFormat,
      Map<DateTime, List<Event>> events,
      List<Event> selectedDayEvents,
      bool isLoading,
      String? error,
      DateTime? loadedStartDate,
      DateTime? loadedEndDate});
}

/// @nodoc
class __$$EventStateImplCopyWithImpl<$Res>
    extends _$EventStateCopyWithImpl<$Res, _$EventStateImpl>
    implements _$$EventStateImplCopyWith<$Res> {
  __$$EventStateImplCopyWithImpl(
      _$EventStateImpl _value, $Res Function(_$EventStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? focusedDay = null,
    Object? selectedDay = freezed,
    Object? calendarFormat = null,
    Object? events = null,
    Object? selectedDayEvents = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? loadedStartDate = freezed,
    Object? loadedEndDate = freezed,
  }) {
    return _then(_$EventStateImpl(
      focusedDay: null == focusedDay
          ? _value.focusedDay
          : focusedDay // ignore: cast_nullable_to_non_nullable
              as DateTime,
      selectedDay: freezed == selectedDay
          ? _value.selectedDay
          : selectedDay // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      calendarFormat: null == calendarFormat
          ? _value.calendarFormat
          : calendarFormat // ignore: cast_nullable_to_non_nullable
              as CalendarFormat,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as Map<DateTime, List<Event>>,
      selectedDayEvents: null == selectedDayEvents
          ? _value._selectedDayEvents
          : selectedDayEvents // ignore: cast_nullable_to_non_nullable
              as List<Event>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      loadedStartDate: freezed == loadedStartDate
          ? _value.loadedStartDate
          : loadedStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      loadedEndDate: freezed == loadedEndDate
          ? _value.loadedEndDate
          : loadedEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$EventStateImpl implements _EventState {
  const _$EventStateImpl(
      {required this.focusedDay,
      this.selectedDay,
      this.calendarFormat = CalendarFormat.month,
      final Map<DateTime, List<Event>> events = const {},
      final List<Event> selectedDayEvents = const [],
      this.isLoading = false,
      this.error,
      this.loadedStartDate,
      this.loadedEndDate})
      : _events = events,
        _selectedDayEvents = selectedDayEvents;

  @override
  final DateTime focusedDay;
  @override
  final DateTime? selectedDay;
  @override
  @JsonKey()
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<Event>> _events;
  @override
  @JsonKey()
  Map<DateTime, List<Event>> get events {
    if (_events is EqualUnmodifiableMapView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_events);
  }

// Events grouped by normalized date
  final List<Event> _selectedDayEvents;
// Events grouped by normalized date
  @override
  @JsonKey()
  List<Event> get selectedDayEvents {
    if (_selectedDayEvents is EqualUnmodifiableListView)
      return _selectedDayEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedDayEvents);
  }

// Events for the selected day
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;
// Track loaded date ranges to avoid redundant fetches
  @override
  final DateTime? loadedStartDate;
  @override
  final DateTime? loadedEndDate;

  @override
  String toString() {
    return 'EventState(focusedDay: $focusedDay, selectedDay: $selectedDay, calendarFormat: $calendarFormat, events: $events, selectedDayEvents: $selectedDayEvents, isLoading: $isLoading, error: $error, loadedStartDate: $loadedStartDate, loadedEndDate: $loadedEndDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventStateImpl &&
            (identical(other.focusedDay, focusedDay) ||
                other.focusedDay == focusedDay) &&
            (identical(other.selectedDay, selectedDay) ||
                other.selectedDay == selectedDay) &&
            (identical(other.calendarFormat, calendarFormat) ||
                other.calendarFormat == calendarFormat) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            const DeepCollectionEquality()
                .equals(other._selectedDayEvents, _selectedDayEvents) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.loadedStartDate, loadedStartDate) ||
                other.loadedStartDate == loadedStartDate) &&
            (identical(other.loadedEndDate, loadedEndDate) ||
                other.loadedEndDate == loadedEndDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      focusedDay,
      selectedDay,
      calendarFormat,
      const DeepCollectionEquality().hash(_events),
      const DeepCollectionEquality().hash(_selectedDayEvents),
      isLoading,
      error,
      loadedStartDate,
      loadedEndDate);

  /// Create a copy of EventState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventStateImplCopyWith<_$EventStateImpl> get copyWith =>
      __$$EventStateImplCopyWithImpl<_$EventStateImpl>(this, _$identity);
}

abstract class _EventState implements EventState {
  const factory _EventState(
      {required final DateTime focusedDay,
      final DateTime? selectedDay,
      final CalendarFormat calendarFormat,
      final Map<DateTime, List<Event>> events,
      final List<Event> selectedDayEvents,
      final bool isLoading,
      final String? error,
      final DateTime? loadedStartDate,
      final DateTime? loadedEndDate}) = _$EventStateImpl;

  @override
  DateTime get focusedDay;
  @override
  DateTime? get selectedDay;
  @override
  CalendarFormat get calendarFormat;
  @override
  Map<DateTime, List<Event>> get events; // Events grouped by normalized date
  @override
  List<Event> get selectedDayEvents; // Events for the selected day
  @override
  bool get isLoading;
  @override
  String? get error; // Track loaded date ranges to avoid redundant fetches
  @override
  DateTime? get loadedStartDate;
  @override
  DateTime? get loadedEndDate;

  /// Create a copy of EventState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventStateImplCopyWith<_$EventStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
