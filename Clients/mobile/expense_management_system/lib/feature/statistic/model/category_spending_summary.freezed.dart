// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_spending_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategorySpendingSummary _$CategorySpendingSummaryFromJson(
    Map<String, dynamic> json) {
  return _CategorySpendingSummary.fromJson(json);
}

/// @nodoc
mixin _$CategorySpendingSummary {
  String get categoryName => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this CategorySpendingSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategorySpendingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorySpendingSummaryCopyWith<CategorySpendingSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySpendingSummaryCopyWith<$Res> {
  factory $CategorySpendingSummaryCopyWith(CategorySpendingSummary value,
          $Res Function(CategorySpendingSummary) then) =
      _$CategorySpendingSummaryCopyWithImpl<$Res, CategorySpendingSummary>;
  @useResult
  $Res call({String categoryName, double totalAmount, double percentage});
}

/// @nodoc
class _$CategorySpendingSummaryCopyWithImpl<$Res,
        $Val extends CategorySpendingSummary>
    implements $CategorySpendingSummaryCopyWith<$Res> {
  _$CategorySpendingSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategorySpendingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? totalAmount = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorySpendingSummaryImplCopyWith<$Res>
    implements $CategorySpendingSummaryCopyWith<$Res> {
  factory _$$CategorySpendingSummaryImplCopyWith(
          _$CategorySpendingSummaryImpl value,
          $Res Function(_$CategorySpendingSummaryImpl) then) =
      __$$CategorySpendingSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String categoryName, double totalAmount, double percentage});
}

/// @nodoc
class __$$CategorySpendingSummaryImplCopyWithImpl<$Res>
    extends _$CategorySpendingSummaryCopyWithImpl<$Res,
        _$CategorySpendingSummaryImpl>
    implements _$$CategorySpendingSummaryImplCopyWith<$Res> {
  __$$CategorySpendingSummaryImplCopyWithImpl(
      _$CategorySpendingSummaryImpl _value,
      $Res Function(_$CategorySpendingSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategorySpendingSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryName = null,
    Object? totalAmount = null,
    Object? percentage = null,
  }) {
    return _then(_$CategorySpendingSummaryImpl(
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategorySpendingSummaryImpl implements _CategorySpendingSummary {
  const _$CategorySpendingSummaryImpl(
      {required this.categoryName,
      required this.totalAmount,
      required this.percentage});

  factory _$CategorySpendingSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategorySpendingSummaryImplFromJson(json);

  @override
  final String categoryName;
  @override
  final double totalAmount;
  @override
  final double percentage;

  @override
  String toString() {
    return 'CategorySpendingSummary(categoryName: $categoryName, totalAmount: $totalAmount, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySpendingSummaryImpl &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryName, totalAmount, percentage);

  /// Create a copy of CategorySpendingSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySpendingSummaryImplCopyWith<_$CategorySpendingSummaryImpl>
      get copyWith => __$$CategorySpendingSummaryImplCopyWithImpl<
          _$CategorySpendingSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorySpendingSummaryImplToJson(
      this,
    );
  }
}

abstract class _CategorySpendingSummary implements CategorySpendingSummary {
  const factory _CategorySpendingSummary(
      {required final String categoryName,
      required final double totalAmount,
      required final double percentage}) = _$CategorySpendingSummaryImpl;

  factory _CategorySpendingSummary.fromJson(Map<String, dynamic> json) =
      _$CategorySpendingSummaryImpl.fromJson;

  @override
  String get categoryName;
  @override
  double get totalAmount;
  @override
  double get percentage;

  /// Create a copy of CategorySpendingSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorySpendingSummaryImplCopyWith<_$CategorySpendingSummaryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
