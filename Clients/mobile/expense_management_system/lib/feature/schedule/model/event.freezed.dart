// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
// Thay đổi từ String? thành dynamic để tương thích với cả int và String
// HOẶC thay đổi thành int? nếu API luôn trả về id là integer
  dynamic get id => throw _privateConstructorUsedError; // hoặc int?
  dynamic get scheduledEventId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  EventType get type => throw _privateConstructorUsedError;
  String get payload =>
      throw _privateConstructorUsedError; // Thêm mapping cho tên trường khác nhau
  @JsonKey(
      name: 'initialTrigger',
      fromJson: dateTimeFromJsonNonNull,
      toJson: dateTimeToJson)
  DateTime get initialTriggerDateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'recurrenceRule')
  EventRule? get rule => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {dynamic id,
      dynamic scheduledEventId,
      String name,
      String? description,
      EventType type,
      String payload,
      @JsonKey(
          name: 'initialTrigger',
          fromJson: dateTimeFromJsonNonNull,
          toJson: dateTimeToJson)
      DateTime initialTriggerDateTime,
      @JsonKey(name: 'recurrenceRule') EventRule? rule,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      DateTime? createdAt,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      DateTime? updatedAt});

  $EventRuleCopyWith<$Res>? get rule;
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? scheduledEventId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? type = null,
    Object? payload = null,
    Object? initialTriggerDateTime = null,
    Object? rule = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      scheduledEventId: freezed == scheduledEventId
          ? _value.scheduledEventId
          : scheduledEventId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventType,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String,
      initialTriggerDateTime: null == initialTriggerDateTime
          ? _value.initialTriggerDateTime
          : initialTriggerDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rule: freezed == rule
          ? _value.rule
          : rule // ignore: cast_nullable_to_non_nullable
              as EventRule?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventRuleCopyWith<$Res>? get rule {
    if (_value.rule == null) {
      return null;
    }

    return $EventRuleCopyWith<$Res>(_value.rule!, (value) {
      return _then(_value.copyWith(rule: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventImplCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$EventImplCopyWith(
          _$EventImpl value, $Res Function(_$EventImpl) then) =
      __$$EventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic id,
      dynamic scheduledEventId,
      String name,
      String? description,
      EventType type,
      String payload,
      @JsonKey(
          name: 'initialTrigger',
          fromJson: dateTimeFromJsonNonNull,
          toJson: dateTimeToJson)
      DateTime initialTriggerDateTime,
      @JsonKey(name: 'recurrenceRule') EventRule? rule,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      DateTime? createdAt,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      DateTime? updatedAt});

  @override
  $EventRuleCopyWith<$Res>? get rule;
}

/// @nodoc
class __$$EventImplCopyWithImpl<$Res>
    extends _$EventCopyWithImpl<$Res, _$EventImpl>
    implements _$$EventImplCopyWith<$Res> {
  __$$EventImplCopyWithImpl(
      _$EventImpl _value, $Res Function(_$EventImpl) _then)
      : super(_value, _then);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? scheduledEventId = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? type = null,
    Object? payload = null,
    Object? initialTriggerDateTime = null,
    Object? rule = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EventImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as dynamic,
      scheduledEventId: freezed == scheduledEventId
          ? _value.scheduledEventId
          : scheduledEventId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EventType,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String,
      initialTriggerDateTime: null == initialTriggerDateTime
          ? _value.initialTriggerDateTime
          : initialTriggerDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rule: freezed == rule
          ? _value.rule
          : rule // ignore: cast_nullable_to_non_nullable
              as EventRule?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$EventImpl extends _Event {
  const _$EventImpl(
      {this.id,
      this.scheduledEventId,
      required this.name,
      this.description,
      required this.type,
      required this.payload,
      @JsonKey(
          name: 'initialTrigger',
          fromJson: dateTimeFromJsonNonNull,
          toJson: dateTimeToJson)
      required this.initialTriggerDateTime,
      @JsonKey(name: 'recurrenceRule') this.rule,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      this.createdAt,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      this.updatedAt})
      : super._();

  factory _$EventImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventImplFromJson(json);

// Thay đổi từ String? thành dynamic để tương thích với cả int và String
// HOẶC thay đổi thành int? nếu API luôn trả về id là integer
  @override
  final dynamic id;
// hoặc int?
  @override
  final dynamic scheduledEventId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final EventType type;
  @override
  final String payload;
// Thêm mapping cho tên trường khác nhau
  @override
  @JsonKey(
      name: 'initialTrigger',
      fromJson: dateTimeFromJsonNonNull,
      toJson: dateTimeToJson)
  final DateTime initialTriggerDateTime;
  @override
  @JsonKey(name: 'recurrenceRule')
  final EventRule? rule;
  @override
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  final DateTime? createdAt;
  @override
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Event(id: $id, scheduledEventId: $scheduledEventId, name: $name, description: $description, type: $type, payload: $payload, initialTriggerDateTime: $initialTriggerDateTime, rule: $rule, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventImpl &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality()
                .equals(other.scheduledEventId, scheduledEventId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            (identical(other.initialTriggerDateTime, initialTriggerDateTime) ||
                other.initialTriggerDateTime == initialTriggerDateTime) &&
            (identical(other.rule, rule) || other.rule == rule) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(scheduledEventId),
      name,
      description,
      type,
      payload,
      initialTriggerDateTime,
      rule,
      createdAt,
      updatedAt);

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      __$$EventImplCopyWithImpl<_$EventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventImplToJson(
      this,
    );
  }
}

abstract class _Event extends Event {
  const factory _Event(
      {final dynamic id,
      final dynamic scheduledEventId,
      required final String name,
      final String? description,
      required final EventType type,
      required final String payload,
      @JsonKey(
          name: 'initialTrigger',
          fromJson: dateTimeFromJsonNonNull,
          toJson: dateTimeToJson)
      required final DateTime initialTriggerDateTime,
      @JsonKey(name: 'recurrenceRule') final EventRule? rule,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      final DateTime? createdAt,
      @JsonKey(
          fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
      final DateTime? updatedAt}) = _$EventImpl;
  const _Event._() : super._();

  factory _Event.fromJson(Map<String, dynamic> json) = _$EventImpl.fromJson;

// Thay đổi từ String? thành dynamic để tương thích với cả int và String
// HOẶC thay đổi thành int? nếu API luôn trả về id là integer
  @override
  dynamic get id; // hoặc int?
  @override
  dynamic get scheduledEventId;
  @override
  String get name;
  @override
  String? get description;
  @override
  EventType get type;
  @override
  String get payload; // Thêm mapping cho tên trường khác nhau
  @override
  @JsonKey(
      name: 'initialTrigger',
      fromJson: dateTimeFromJsonNonNull,
      toJson: dateTimeToJson)
  DateTime get initialTriggerDateTime;
  @override
  @JsonKey(name: 'recurrenceRule')
  EventRule? get rule;
  @override
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  DateTime? get createdAt;
  @override
  @JsonKey(fromJson: dateTimeFromJsonNullable, toJson: dateTimeToJsonNullable)
  DateTime? get updatedAt;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventImplCopyWith<_$EventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
