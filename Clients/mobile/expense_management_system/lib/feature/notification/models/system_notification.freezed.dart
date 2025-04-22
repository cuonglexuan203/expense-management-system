// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SystemNotification _$SystemNotificationFromJson(Map<String, dynamic> json) {
  return _SystemNotification.fromJson(json);
}

/// @nodoc
mixin _$SystemNotification {
  String get packageName => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic>? get extras => throw _privateConstructorUsedError;

  /// Serializes this SystemNotification to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemNotificationCopyWith<SystemNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemNotificationCopyWith<$Res> {
  factory $SystemNotificationCopyWith(
          SystemNotification value, $Res Function(SystemNotification) then) =
      _$SystemNotificationCopyWithImpl<$Res, SystemNotification>;
  @useResult
  $Res call(
      {String packageName,
      String title,
      String text,
      int timestamp,
      Map<String, dynamic>? extras});
}

/// @nodoc
class _$SystemNotificationCopyWithImpl<$Res, $Val extends SystemNotification>
    implements $SystemNotificationCopyWith<$Res> {
  _$SystemNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? title = null,
    Object? text = null,
    Object? timestamp = null,
    Object? extras = freezed,
  }) {
    return _then(_value.copyWith(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      extras: freezed == extras
          ? _value.extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SystemNotificationImplCopyWith<$Res>
    implements $SystemNotificationCopyWith<$Res> {
  factory _$$SystemNotificationImplCopyWith(_$SystemNotificationImpl value,
          $Res Function(_$SystemNotificationImpl) then) =
      __$$SystemNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String packageName,
      String title,
      String text,
      int timestamp,
      Map<String, dynamic>? extras});
}

/// @nodoc
class __$$SystemNotificationImplCopyWithImpl<$Res>
    extends _$SystemNotificationCopyWithImpl<$Res, _$SystemNotificationImpl>
    implements _$$SystemNotificationImplCopyWith<$Res> {
  __$$SystemNotificationImplCopyWithImpl(_$SystemNotificationImpl _value,
      $Res Function(_$SystemNotificationImpl) _then)
      : super(_value, _then);

  /// Create a copy of SystemNotification
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? packageName = null,
    Object? title = null,
    Object? text = null,
    Object? timestamp = null,
    Object? extras = freezed,
  }) {
    return _then(_$SystemNotificationImpl(
      packageName: null == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      extras: freezed == extras
          ? _value._extras
          : extras // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemNotificationImpl implements _SystemNotification {
  const _$SystemNotificationImpl(
      {required this.packageName,
      required this.title,
      required this.text,
      required this.timestamp,
      final Map<String, dynamic>? extras})
      : _extras = extras;

  factory _$SystemNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemNotificationImplFromJson(json);

  @override
  final String packageName;
  @override
  final String title;
  @override
  final String text;
  @override
  final int timestamp;
  final Map<String, dynamic>? _extras;
  @override
  Map<String, dynamic>? get extras {
    final value = _extras;
    if (value == null) return null;
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SystemNotification(packageName: $packageName, title: $title, text: $text, timestamp: $timestamp, extras: $extras)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemNotificationImpl &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, packageName, title, text,
      timestamp, const DeepCollectionEquality().hash(_extras));

  /// Create a copy of SystemNotification
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemNotificationImplCopyWith<_$SystemNotificationImpl> get copyWith =>
      __$$SystemNotificationImplCopyWithImpl<_$SystemNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemNotificationImplToJson(
      this,
    );
  }
}

abstract class _SystemNotification implements SystemNotification {
  const factory _SystemNotification(
      {required final String packageName,
      required final String title,
      required final String text,
      required final int timestamp,
      final Map<String, dynamic>? extras}) = _$SystemNotificationImpl;

  factory _SystemNotification.fromJson(Map<String, dynamic> json) =
      _$SystemNotificationImpl.fromJson;

  @override
  String get packageName;
  @override
  String get title;
  @override
  String get text;
  @override
  int get timestamp;
  @override
  Map<String, dynamic>? get extras;

  /// Create a copy of SystemNotification
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemNotificationImplCopyWith<_$SystemNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
