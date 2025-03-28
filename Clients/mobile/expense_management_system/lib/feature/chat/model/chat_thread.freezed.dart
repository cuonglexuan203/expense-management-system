// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_thread.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatThread _$ChatThreadFromJson(Map<String, dynamic> json) {
  return _ChatThread.fromJson(json);
}

/// @nodoc
mixin _$ChatThread {
  int get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ChatThread to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatThreadCopyWith<ChatThread> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatThreadCopyWith<$Res> {
  factory $ChatThreadCopyWith(
          ChatThread value, $Res Function(ChatThread) then) =
      _$ChatThreadCopyWithImpl<$Res, ChatThread>;
  @useResult
  $Res call(
      {int id,
      String userId,
      String title,
      bool isActive,
      String type,
      DateTime createdAt});
}

/// @nodoc
class _$ChatThreadCopyWithImpl<$Res, $Val extends ChatThread>
    implements $ChatThreadCopyWith<$Res> {
  _$ChatThreadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? isActive = null,
    Object? type = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatThreadImplCopyWith<$Res>
    implements $ChatThreadCopyWith<$Res> {
  factory _$$ChatThreadImplCopyWith(
          _$ChatThreadImpl value, $Res Function(_$ChatThreadImpl) then) =
      __$$ChatThreadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String userId,
      String title,
      bool isActive,
      String type,
      DateTime createdAt});
}

/// @nodoc
class __$$ChatThreadImplCopyWithImpl<$Res>
    extends _$ChatThreadCopyWithImpl<$Res, _$ChatThreadImpl>
    implements _$$ChatThreadImplCopyWith<$Res> {
  __$$ChatThreadImplCopyWithImpl(
      _$ChatThreadImpl _value, $Res Function(_$ChatThreadImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? isActive = null,
    Object? type = null,
    Object? createdAt = null,
  }) {
    return _then(_$ChatThreadImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatThreadImpl implements _ChatThread {
  const _$ChatThreadImpl(
      {required this.id,
      required this.userId,
      required this.title,
      required this.isActive,
      required this.type,
      required this.createdAt});

  factory _$ChatThreadImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatThreadImplFromJson(json);

  @override
  final int id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final bool isActive;
  @override
  final String type;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ChatThread(id: $id, userId: $userId, title: $title, isActive: $isActive, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatThreadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, title, isActive, type, createdAt);

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatThreadImplCopyWith<_$ChatThreadImpl> get copyWith =>
      __$$ChatThreadImplCopyWithImpl<_$ChatThreadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatThreadImplToJson(
      this,
    );
  }
}

abstract class _ChatThread implements ChatThread {
  const factory _ChatThread(
      {required final int id,
      required final String userId,
      required final String title,
      required final bool isActive,
      required final String type,
      required final DateTime createdAt}) = _$ChatThreadImpl;

  factory _ChatThread.fromJson(Map<String, dynamic> json) =
      _$ChatThreadImpl.fromJson;

  @override
  int get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  bool get isActive;
  @override
  String get type;
  @override
  DateTime get createdAt;

  /// Create a copy of ChatThread
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatThreadImplCopyWith<_$ChatThreadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
