// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventRule _$EventRuleFromJson(Map<String, dynamic> json) {
  return _EventRule.fromJson(json);
}

/// @nodoc
mixin _$EventRule {
  EventFrequency get frequency => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  List<String> get byDayOfWeek => throw _privateConstructorUsedError;
  List<int> get byMonthDay => throw _privateConstructorUsedError;
  List<int> get byMonth => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  DateTime? get endDate => throw _privateConstructorUsedError;
  int? get maxOccurrences => throw _privateConstructorUsedError;

  /// Serializes this EventRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventRuleCopyWith<EventRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventRuleCopyWith<$Res> {
  factory $EventRuleCopyWith(EventRule value, $Res Function(EventRule) then) =
      _$EventRuleCopyWithImpl<$Res, EventRule>;
  @useResult
  $Res call(
      {EventFrequency frequency,
      int interval,
      List<String> byDayOfWeek,
      List<int> byMonthDay,
      List<int> byMonth,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      DateTime? endDate,
      int? maxOccurrences});
}

/// @nodoc
class _$EventRuleCopyWithImpl<$Res, $Val extends EventRule>
    implements $EventRuleCopyWith<$Res> {
  _$EventRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? byDayOfWeek = null,
    Object? byMonthDay = null,
    Object? byMonth = null,
    Object? endDate = freezed,
    Object? maxOccurrences = freezed,
  }) {
    return _then(_value.copyWith(
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as EventFrequency,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      byDayOfWeek: null == byDayOfWeek
          ? _value.byDayOfWeek
          : byDayOfWeek // ignore: cast_nullable_to_non_nullable
              as List<String>,
      byMonthDay: null == byMonthDay
          ? _value.byMonthDay
          : byMonthDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonth: null == byMonth
          ? _value.byMonth
          : byMonth // ignore: cast_nullable_to_non_nullable
              as List<int>,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maxOccurrences: freezed == maxOccurrences
          ? _value.maxOccurrences
          : maxOccurrences // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventRuleImplCopyWith<$Res>
    implements $EventRuleCopyWith<$Res> {
  factory _$$EventRuleImplCopyWith(
          _$EventRuleImpl value, $Res Function(_$EventRuleImpl) then) =
      __$$EventRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {EventFrequency frequency,
      int interval,
      List<String> byDayOfWeek,
      List<int> byMonthDay,
      List<int> byMonth,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      DateTime? endDate,
      int? maxOccurrences});
}

/// @nodoc
class __$$EventRuleImplCopyWithImpl<$Res>
    extends _$EventRuleCopyWithImpl<$Res, _$EventRuleImpl>
    implements _$$EventRuleImplCopyWith<$Res> {
  __$$EventRuleImplCopyWithImpl(
      _$EventRuleImpl _value, $Res Function(_$EventRuleImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? byDayOfWeek = null,
    Object? byMonthDay = null,
    Object? byMonth = null,
    Object? endDate = freezed,
    Object? maxOccurrences = freezed,
  }) {
    return _then(_$EventRuleImpl(
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as EventFrequency,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      byDayOfWeek: null == byDayOfWeek
          ? _value._byDayOfWeek
          : byDayOfWeek // ignore: cast_nullable_to_non_nullable
              as List<String>,
      byMonthDay: null == byMonthDay
          ? _value._byMonthDay
          : byMonthDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonth: null == byMonth
          ? _value._byMonth
          : byMonth // ignore: cast_nullable_to_non_nullable
              as List<int>,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maxOccurrences: freezed == maxOccurrences
          ? _value.maxOccurrences
          : maxOccurrences // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventRuleImpl implements _EventRule {
  const _$EventRuleImpl(
      {this.frequency = EventFrequency.once,
      this.interval = 1,
      final List<String> byDayOfWeek = const [],
      final List<int> byMonthDay = const [],
      final List<int> byMonth = const [],
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      this.endDate,
      this.maxOccurrences})
      : _byDayOfWeek = byDayOfWeek,
        _byMonthDay = byMonthDay,
        _byMonth = byMonth;

  factory _$EventRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventRuleImplFromJson(json);

  @override
  @JsonKey()
  final EventFrequency frequency;
  @override
  @JsonKey()
  final int interval;
  final List<String> _byDayOfWeek;
  @override
  @JsonKey()
  List<String> get byDayOfWeek {
    if (_byDayOfWeek is EqualUnmodifiableListView) return _byDayOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byDayOfWeek);
  }

  final List<int> _byMonthDay;
  @override
  @JsonKey()
  List<int> get byMonthDay {
    if (_byMonthDay is EqualUnmodifiableListView) return _byMonthDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byMonthDay);
  }

  final List<int> _byMonth;
  @override
  @JsonKey()
  List<int> get byMonth {
    if (_byMonth is EqualUnmodifiableListView) return _byMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byMonth);
  }

  @override
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  final DateTime? endDate;
  @override
  final int? maxOccurrences;

  @override
  String toString() {
    return 'EventRule(frequency: $frequency, interval: $interval, byDayOfWeek: $byDayOfWeek, byMonthDay: $byMonthDay, byMonth: $byMonth, endDate: $endDate, maxOccurrences: $maxOccurrences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventRuleImpl &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            const DeepCollectionEquality()
                .equals(other._byDayOfWeek, _byDayOfWeek) &&
            const DeepCollectionEquality()
                .equals(other._byMonthDay, _byMonthDay) &&
            const DeepCollectionEquality().equals(other._byMonth, _byMonth) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.maxOccurrences, maxOccurrences) ||
                other.maxOccurrences == maxOccurrences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      frequency,
      interval,
      const DeepCollectionEquality().hash(_byDayOfWeek),
      const DeepCollectionEquality().hash(_byMonthDay),
      const DeepCollectionEquality().hash(_byMonth),
      endDate,
      maxOccurrences);

  /// Create a copy of EventRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventRuleImplCopyWith<_$EventRuleImpl> get copyWith =>
      __$$EventRuleImplCopyWithImpl<_$EventRuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventRuleImplToJson(
      this,
    );
  }
}

abstract class _EventRule implements EventRule {
  const factory _EventRule(
      {final EventFrequency frequency,
      final int interval,
      final List<String> byDayOfWeek,
      final List<int> byMonthDay,
      final List<int> byMonth,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      final DateTime? endDate,
      final int? maxOccurrences}) = _$EventRuleImpl;

  factory _EventRule.fromJson(Map<String, dynamic> json) =
      _$EventRuleImpl.fromJson;

  @override
  EventFrequency get frequency;
  @override
  int get interval;
  @override
  List<String> get byDayOfWeek;
  @override
  List<int> get byMonthDay;
  @override
  List<int> get byMonth;
  @override
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  DateTime? get endDate;
  @override
  int? get maxOccurrences;

  /// Create a copy of EventRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventRuleImplCopyWith<_$EventRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
