// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnboardingState _$OnboardingStateFromJson(Map<String, dynamic> json) {
  return _OnboardingState.fromJson(json);
}

/// @nodoc
mixin _$OnboardingState {
  OnboardingStep get currentStep => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  List<Category> get categories => throw _privateConstructorUsedError;
  List<int> get selectedCategoryIds => throw _privateConstructorUsedError;
  String get walletName => throw _privateConstructorUsedError;
  double get initialBalance => throw _privateConstructorUsedError;
  String get passcode => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isCurrentStepValid => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this OnboardingState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingStateCopyWith<OnboardingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStateCopyWith<$Res> {
  factory $OnboardingStateCopyWith(
          OnboardingState value, $Res Function(OnboardingState) then) =
      _$OnboardingStateCopyWithImpl<$Res, OnboardingState>;
  @useResult
  $Res call(
      {OnboardingStep currentStep,
      String language,
      String currency,
      List<Category> categories,
      List<int> selectedCategoryIds,
      String walletName,
      double initialBalance,
      String passcode,
      bool isLoading,
      bool isCurrentStepValid,
      String? errorMessage});
}

/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res, $Val extends OnboardingState>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? language = null,
    Object? currency = null,
    Object? categories = null,
    Object? selectedCategoryIds = null,
    Object? walletName = null,
    Object? initialBalance = null,
    Object? passcode = null,
    Object? isLoading = null,
    Object? isCurrentStepValid = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as OnboardingStep,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      selectedCategoryIds: null == selectedCategoryIds
          ? _value.selectedCategoryIds
          : selectedCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      walletName: null == walletName
          ? _value.walletName
          : walletName // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as double,
      passcode: null == passcode
          ? _value.passcode
          : passcode // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentStepValid: null == isCurrentStepValid
          ? _value.isCurrentStepValid
          : isCurrentStepValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingStateImplCopyWith<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  factory _$$OnboardingStateImplCopyWith(_$OnboardingStateImpl value,
          $Res Function(_$OnboardingStateImpl) then) =
      __$$OnboardingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OnboardingStep currentStep,
      String language,
      String currency,
      List<Category> categories,
      List<int> selectedCategoryIds,
      String walletName,
      double initialBalance,
      String passcode,
      bool isLoading,
      bool isCurrentStepValid,
      String? errorMessage});
}

/// @nodoc
class __$$OnboardingStateImplCopyWithImpl<$Res>
    extends _$OnboardingStateCopyWithImpl<$Res, _$OnboardingStateImpl>
    implements _$$OnboardingStateImplCopyWith<$Res> {
  __$$OnboardingStateImplCopyWithImpl(
      _$OnboardingStateImpl _value, $Res Function(_$OnboardingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStep = null,
    Object? language = null,
    Object? currency = null,
    Object? categories = null,
    Object? selectedCategoryIds = null,
    Object? walletName = null,
    Object? initialBalance = null,
    Object? passcode = null,
    Object? isLoading = null,
    Object? isCurrentStepValid = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$OnboardingStateImpl(
      currentStep: null == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as OnboardingStep,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      selectedCategoryIds: null == selectedCategoryIds
          ? _value._selectedCategoryIds
          : selectedCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      walletName: null == walletName
          ? _value.walletName
          : walletName // ignore: cast_nullable_to_non_nullable
              as String,
      initialBalance: null == initialBalance
          ? _value.initialBalance
          : initialBalance // ignore: cast_nullable_to_non_nullable
              as double,
      passcode: null == passcode
          ? _value.passcode
          : passcode // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCurrentStepValid: null == isCurrentStepValid
          ? _value.isCurrentStepValid
          : isCurrentStepValid // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingStateImpl implements _OnboardingState {
  const _$OnboardingStateImpl(
      {required this.currentStep,
      required this.language,
      required this.currency,
      required final List<Category> categories,
      required final List<int> selectedCategoryIds,
      required this.walletName,
      required this.initialBalance,
      required this.passcode,
      required this.isLoading,
      this.isCurrentStepValid = false,
      this.errorMessage})
      : _categories = categories,
        _selectedCategoryIds = selectedCategoryIds;

  factory _$OnboardingStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingStateImplFromJson(json);

  @override
  final OnboardingStep currentStep;
  @override
  final String language;
  @override
  final String currency;
  final List<Category> _categories;
  @override
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<int> _selectedCategoryIds;
  @override
  List<int> get selectedCategoryIds {
    if (_selectedCategoryIds is EqualUnmodifiableListView)
      return _selectedCategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCategoryIds);
  }

  @override
  final String walletName;
  @override
  final double initialBalance;
  @override
  final String passcode;
  @override
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCurrentStepValid;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'OnboardingState(currentStep: $currentStep, language: $language, currency: $currency, categories: $categories, selectedCategoryIds: $selectedCategoryIds, walletName: $walletName, initialBalance: $initialBalance, passcode: $passcode, isLoading: $isLoading, isCurrentStepValid: $isCurrentStepValid, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingStateImpl &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality()
                .equals(other._selectedCategoryIds, _selectedCategoryIds) &&
            (identical(other.walletName, walletName) ||
                other.walletName == walletName) &&
            (identical(other.initialBalance, initialBalance) ||
                other.initialBalance == initialBalance) &&
            (identical(other.passcode, passcode) ||
                other.passcode == passcode) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCurrentStepValid, isCurrentStepValid) ||
                other.isCurrentStepValid == isCurrentStepValid) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentStep,
      language,
      currency,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_selectedCategoryIds),
      walletName,
      initialBalance,
      passcode,
      isLoading,
      isCurrentStepValid,
      errorMessage);

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      __$$OnboardingStateImplCopyWithImpl<_$OnboardingStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingStateImplToJson(
      this,
    );
  }
}

abstract class _OnboardingState implements OnboardingState {
  const factory _OnboardingState(
      {required final OnboardingStep currentStep,
      required final String language,
      required final String currency,
      required final List<Category> categories,
      required final List<int> selectedCategoryIds,
      required final String walletName,
      required final double initialBalance,
      required final String passcode,
      required final bool isLoading,
      final bool isCurrentStepValid,
      final String? errorMessage}) = _$OnboardingStateImpl;

  factory _OnboardingState.fromJson(Map<String, dynamic> json) =
      _$OnboardingStateImpl.fromJson;

  @override
  OnboardingStep get currentStep;
  @override
  String get language;
  @override
  String get currency;
  @override
  List<Category> get categories;
  @override
  List<int> get selectedCategoryIds;
  @override
  String get walletName;
  @override
  double get initialBalance;
  @override
  String get passcode;
  @override
  bool get isLoading;
  @override
  bool get isCurrentStepValid;
  @override
  String? get errorMessage;

  /// Create a copy of OnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingStateImplCopyWith<_$OnboardingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
