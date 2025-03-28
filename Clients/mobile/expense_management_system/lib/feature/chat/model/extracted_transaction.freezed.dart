// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extracted_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExtractedTransaction _$ExtractedTransactionFromJson(Map<String, dynamic> json) {
  return _ExtractedTransaction.fromJson(json);
}

/// @nodoc
mixin _$ExtractedTransaction {
  int get chatExtractionId => throw _privateConstructorUsedError;
  int get chatMessageId => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  int get transactionId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  DateTime get occurredAt => throw _privateConstructorUsedError;
  int get confirmationMode => throw _privateConstructorUsedError;
  int get confirmationStatus => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ExtractedTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtractedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtractedTransactionCopyWith<ExtractedTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractedTransactionCopyWith<$Res> {
  factory $ExtractedTransactionCopyWith(ExtractedTransaction value,
          $Res Function(ExtractedTransaction) then) =
      _$ExtractedTransactionCopyWithImpl<$Res, ExtractedTransaction>;
  @useResult
  $Res call(
      {int chatExtractionId,
      int chatMessageId,
      String? category,
      int transactionId,
      String name,
      int amount,
      int type,
      DateTime occurredAt,
      int confirmationMode,
      int confirmationStatus,
      DateTime createdAt});
}

/// @nodoc
class _$ExtractedTransactionCopyWithImpl<$Res,
        $Val extends ExtractedTransaction>
    implements $ExtractedTransactionCopyWith<$Res> {
  _$ExtractedTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtractedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatExtractionId = null,
    Object? chatMessageId = null,
    Object? category = freezed,
    Object? transactionId = null,
    Object? name = null,
    Object? amount = null,
    Object? type = null,
    Object? occurredAt = null,
    Object? confirmationMode = null,
    Object? confirmationStatus = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      chatExtractionId: null == chatExtractionId
          ? _value.chatExtractionId
          : chatExtractionId // ignore: cast_nullable_to_non_nullable
              as int,
      chatMessageId: null == chatMessageId
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmationMode: null == confirmationMode
          ? _value.confirmationMode
          : confirmationMode // ignore: cast_nullable_to_non_nullable
              as int,
      confirmationStatus: null == confirmationStatus
          ? _value.confirmationStatus
          : confirmationStatus // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExtractedTransactionImplCopyWith<$Res>
    implements $ExtractedTransactionCopyWith<$Res> {
  factory _$$ExtractedTransactionImplCopyWith(_$ExtractedTransactionImpl value,
          $Res Function(_$ExtractedTransactionImpl) then) =
      __$$ExtractedTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int chatExtractionId,
      int chatMessageId,
      String? category,
      int transactionId,
      String name,
      int amount,
      int type,
      DateTime occurredAt,
      int confirmationMode,
      int confirmationStatus,
      DateTime createdAt});
}

/// @nodoc
class __$$ExtractedTransactionImplCopyWithImpl<$Res>
    extends _$ExtractedTransactionCopyWithImpl<$Res, _$ExtractedTransactionImpl>
    implements _$$ExtractedTransactionImplCopyWith<$Res> {
  __$$ExtractedTransactionImplCopyWithImpl(_$ExtractedTransactionImpl _value,
      $Res Function(_$ExtractedTransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExtractedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatExtractionId = null,
    Object? chatMessageId = null,
    Object? category = freezed,
    Object? transactionId = null,
    Object? name = null,
    Object? amount = null,
    Object? type = null,
    Object? occurredAt = null,
    Object? confirmationMode = null,
    Object? confirmationStatus = null,
    Object? createdAt = null,
  }) {
    return _then(_$ExtractedTransactionImpl(
      chatExtractionId: null == chatExtractionId
          ? _value.chatExtractionId
          : chatExtractionId // ignore: cast_nullable_to_non_nullable
              as int,
      chatMessageId: null == chatMessageId
          ? _value.chatMessageId
          : chatMessageId // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as int,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmationMode: null == confirmationMode
          ? _value.confirmationMode
          : confirmationMode // ignore: cast_nullable_to_non_nullable
              as int,
      confirmationStatus: null == confirmationStatus
          ? _value.confirmationStatus
          : confirmationStatus // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtractedTransactionImpl implements _ExtractedTransaction {
  const _$ExtractedTransactionImpl(
      {required this.chatExtractionId,
      required this.chatMessageId,
      this.category,
      required this.transactionId,
      required this.name,
      required this.amount,
      required this.type,
      required this.occurredAt,
      required this.confirmationMode,
      required this.confirmationStatus,
      required this.createdAt});

  factory _$ExtractedTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtractedTransactionImplFromJson(json);

  @override
  final int chatExtractionId;
  @override
  final int chatMessageId;
  @override
  final String? category;
  @override
  final int transactionId;
  @override
  final String name;
  @override
  final int amount;
  @override
  final int type;
  @override
  final DateTime occurredAt;
  @override
  final int confirmationMode;
  @override
  final int confirmationStatus;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ExtractedTransaction(chatExtractionId: $chatExtractionId, chatMessageId: $chatMessageId, category: $category, transactionId: $transactionId, name: $name, amount: $amount, type: $type, occurredAt: $occurredAt, confirmationMode: $confirmationMode, confirmationStatus: $confirmationStatus, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractedTransactionImpl &&
            (identical(other.chatExtractionId, chatExtractionId) ||
                other.chatExtractionId == chatExtractionId) &&
            (identical(other.chatMessageId, chatMessageId) ||
                other.chatMessageId == chatMessageId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.confirmationMode, confirmationMode) ||
                other.confirmationMode == confirmationMode) &&
            (identical(other.confirmationStatus, confirmationStatus) ||
                other.confirmationStatus == confirmationStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      chatExtractionId,
      chatMessageId,
      category,
      transactionId,
      name,
      amount,
      type,
      occurredAt,
      confirmationMode,
      confirmationStatus,
      createdAt);

  /// Create a copy of ExtractedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractedTransactionImplCopyWith<_$ExtractedTransactionImpl>
      get copyWith =>
          __$$ExtractedTransactionImplCopyWithImpl<_$ExtractedTransactionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtractedTransactionImplToJson(
      this,
    );
  }
}

abstract class _ExtractedTransaction implements ExtractedTransaction {
  const factory _ExtractedTransaction(
      {required final int chatExtractionId,
      required final int chatMessageId,
      final String? category,
      required final int transactionId,
      required final String name,
      required final int amount,
      required final int type,
      required final DateTime occurredAt,
      required final int confirmationMode,
      required final int confirmationStatus,
      required final DateTime createdAt}) = _$ExtractedTransactionImpl;

  factory _ExtractedTransaction.fromJson(Map<String, dynamic> json) =
      _$ExtractedTransactionImpl.fromJson;

  @override
  int get chatExtractionId;
  @override
  int get chatMessageId;
  @override
  String? get category;
  @override
  int get transactionId;
  @override
  String get name;
  @override
  int get amount;
  @override
  int get type;
  @override
  DateTime get occurredAt;
  @override
  int get confirmationMode;
  @override
  int get confirmationStatus;
  @override
  DateTime get createdAt;

  /// Create a copy of ExtractedTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtractedTransactionImplCopyWith<_$ExtractedTransactionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
