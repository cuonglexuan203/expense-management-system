// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnboardingRequest _$OnboardingRequestFromJson(Map<String, dynamic> json) {
  return _OnboardingRequest.fromJson(json);
}

/// @nodoc
mixin _$OnboardingRequest {
  String get languageCode => throw _privateConstructorUsedError;
  String get currencyCode => throw _privateConstructorUsedError;
  List<int> get selectedCategoryIds => throw _privateConstructorUsedError;
  WalletRequest get wallet => throw _privateConstructorUsedError;

  /// Serializes this OnboardingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingRequestCopyWith<OnboardingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingRequestCopyWith<$Res> {
  factory $OnboardingRequestCopyWith(
          OnboardingRequest value, $Res Function(OnboardingRequest) then) =
      _$OnboardingRequestCopyWithImpl<$Res, OnboardingRequest>;
  @useResult
  $Res call(
      {String languageCode,
      String currencyCode,
      List<int> selectedCategoryIds,
      WalletRequest wallet});

  $WalletRequestCopyWith<$Res> get wallet;
}

/// @nodoc
class _$OnboardingRequestCopyWithImpl<$Res, $Val extends OnboardingRequest>
    implements $OnboardingRequestCopyWith<$Res> {
  _$OnboardingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
    Object? currencyCode = null,
    Object? selectedCategoryIds = null,
    Object? wallet = null,
  }) {
    return _then(_value.copyWith(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategoryIds: null == selectedCategoryIds
          ? _value.selectedCategoryIds
          : selectedCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      wallet: null == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as WalletRequest,
    ) as $Val);
  }

  /// Create a copy of OnboardingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletRequestCopyWith<$Res> get wallet {
    return $WalletRequestCopyWith<$Res>(_value.wallet, (value) {
      return _then(_value.copyWith(wallet: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OnboardingRequestImplCopyWith<$Res>
    implements $OnboardingRequestCopyWith<$Res> {
  factory _$$OnboardingRequestImplCopyWith(_$OnboardingRequestImpl value,
          $Res Function(_$OnboardingRequestImpl) then) =
      __$$OnboardingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String languageCode,
      String currencyCode,
      List<int> selectedCategoryIds,
      WalletRequest wallet});

  @override
  $WalletRequestCopyWith<$Res> get wallet;
}

/// @nodoc
class __$$OnboardingRequestImplCopyWithImpl<$Res>
    extends _$OnboardingRequestCopyWithImpl<$Res, _$OnboardingRequestImpl>
    implements _$$OnboardingRequestImplCopyWith<$Res> {
  __$$OnboardingRequestImplCopyWithImpl(_$OnboardingRequestImpl _value,
      $Res Function(_$OnboardingRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
    Object? currencyCode = null,
    Object? selectedCategoryIds = null,
    Object? wallet = null,
  }) {
    return _then(_$OnboardingRequestImpl(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      currencyCode: null == currencyCode
          ? _value.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategoryIds: null == selectedCategoryIds
          ? _value._selectedCategoryIds
          : selectedCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      wallet: null == wallet
          ? _value.wallet
          : wallet // ignore: cast_nullable_to_non_nullable
              as WalletRequest,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingRequestImpl implements _OnboardingRequest {
  const _$OnboardingRequestImpl(
      {required this.languageCode,
      required this.currencyCode,
      required final List<int> selectedCategoryIds,
      required this.wallet})
      : _selectedCategoryIds = selectedCategoryIds;

  factory _$OnboardingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingRequestImplFromJson(json);

  @override
  final String languageCode;
  @override
  final String currencyCode;
  final List<int> _selectedCategoryIds;
  @override
  List<int> get selectedCategoryIds {
    if (_selectedCategoryIds is EqualUnmodifiableListView)
      return _selectedCategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCategoryIds);
  }

  @override
  final WalletRequest wallet;

  @override
  String toString() {
    return 'OnboardingRequest(languageCode: $languageCode, currencyCode: $currencyCode, selectedCategoryIds: $selectedCategoryIds, wallet: $wallet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingRequestImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            const DeepCollectionEquality()
                .equals(other._selectedCategoryIds, _selectedCategoryIds) &&
            (identical(other.wallet, wallet) || other.wallet == wallet));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, languageCode, currencyCode,
      const DeepCollectionEquality().hash(_selectedCategoryIds), wallet);

  /// Create a copy of OnboardingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingRequestImplCopyWith<_$OnboardingRequestImpl> get copyWith =>
      __$$OnboardingRequestImplCopyWithImpl<_$OnboardingRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingRequestImplToJson(
      this,
    );
  }
}

abstract class _OnboardingRequest implements OnboardingRequest {
  const factory _OnboardingRequest(
      {required final String languageCode,
      required final String currencyCode,
      required final List<int> selectedCategoryIds,
      required final WalletRequest wallet}) = _$OnboardingRequestImpl;

  factory _OnboardingRequest.fromJson(Map<String, dynamic> json) =
      _$OnboardingRequestImpl.fromJson;

  @override
  String get languageCode;
  @override
  String get currencyCode;
  @override
  List<int> get selectedCategoryIds;
  @override
  WalletRequest get wallet;

  /// Create a copy of OnboardingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingRequestImplCopyWith<_$OnboardingRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
