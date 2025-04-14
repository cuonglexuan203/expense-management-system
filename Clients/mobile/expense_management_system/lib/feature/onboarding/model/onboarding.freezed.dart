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
  String get language => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  List<int> get selectedCategoryIds => throw _privateConstructorUsedError;
  WalletRequest get initialWallet => throw _privateConstructorUsedError;
  String get passcode => throw _privateConstructorUsedError;

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
      {String language,
      String currency,
      List<int> selectedCategoryIds,
      WalletRequest initialWallet,
      String passcode});

  $WalletRequestCopyWith<$Res> get initialWallet;
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
    Object? language = null,
    Object? currency = null,
    Object? selectedCategoryIds = null,
    Object? initialWallet = null,
    Object? passcode = null,
  }) {
    return _then(_value.copyWith(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategoryIds: null == selectedCategoryIds
          ? _value.selectedCategoryIds
          : selectedCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      initialWallet: null == initialWallet
          ? _value.initialWallet
          : initialWallet // ignore: cast_nullable_to_non_nullable
              as WalletRequest,
      passcode: null == passcode
          ? _value.passcode
          : passcode // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of OnboardingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletRequestCopyWith<$Res> get initialWallet {
    return $WalletRequestCopyWith<$Res>(_value.initialWallet, (value) {
      return _then(_value.copyWith(initialWallet: value) as $Val);
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
      {String language,
      String currency,
      List<int> selectedCategoryIds,
      WalletRequest initialWallet,
      String passcode});

  @override
  $WalletRequestCopyWith<$Res> get initialWallet;
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
    Object? language = null,
    Object? currency = null,
    Object? selectedCategoryIds = null,
    Object? initialWallet = null,
    Object? passcode = null,
  }) {
    return _then(_$OnboardingRequestImpl(
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategoryIds: null == selectedCategoryIds
          ? _value._selectedCategoryIds
          : selectedCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      initialWallet: null == initialWallet
          ? _value.initialWallet
          : initialWallet // ignore: cast_nullable_to_non_nullable
              as WalletRequest,
      passcode: null == passcode
          ? _value.passcode
          : passcode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingRequestImpl implements _OnboardingRequest {
  const _$OnboardingRequestImpl(
      {required this.language,
      required this.currency,
      required final List<int> selectedCategoryIds,
      required this.initialWallet,
      required this.passcode})
      : _selectedCategoryIds = selectedCategoryIds;

  factory _$OnboardingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingRequestImplFromJson(json);

  @override
  final String language;
  @override
  final String currency;
  final List<int> _selectedCategoryIds;
  @override
  List<int> get selectedCategoryIds {
    if (_selectedCategoryIds is EqualUnmodifiableListView)
      return _selectedCategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCategoryIds);
  }

  @override
  final WalletRequest initialWallet;
  @override
  final String passcode;

  @override
  String toString() {
    return 'OnboardingRequest(language: $language, currency: $currency, selectedCategoryIds: $selectedCategoryIds, initialWallet: $initialWallet, passcode: $passcode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingRequestImpl &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality()
                .equals(other._selectedCategoryIds, _selectedCategoryIds) &&
            (identical(other.initialWallet, initialWallet) ||
                other.initialWallet == initialWallet) &&
            (identical(other.passcode, passcode) ||
                other.passcode == passcode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      language,
      currency,
      const DeepCollectionEquality().hash(_selectedCategoryIds),
      initialWallet,
      passcode);

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
      {required final String language,
      required final String currency,
      required final List<int> selectedCategoryIds,
      required final WalletRequest initialWallet,
      required final String passcode}) = _$OnboardingRequestImpl;

  factory _OnboardingRequest.fromJson(Map<String, dynamic> json) =
      _$OnboardingRequestImpl.fromJson;

  @override
  String get language;
  @override
  String get currency;
  @override
  List<int> get selectedCategoryIds;
  @override
  WalletRequest get initialWallet;
  @override
  String get passcode;

  /// Create a copy of OnboardingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingRequestImplCopyWith<_$OnboardingRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
