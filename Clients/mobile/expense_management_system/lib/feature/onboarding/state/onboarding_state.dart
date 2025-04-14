// lib/feature/onboarding/state/onboarding_state.dart
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expense_management_system/feature/category/model/category.dart';

part 'onboarding_state.freezed.dart';
part 'onboarding_state.g.dart';

// lib/feature/onboarding/state/onboarding_state.dart
@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    required OnboardingStep currentStep,
    required String language,
    required String currency,
    required List<Category> categories,
    required List<int> selectedCategoryIds,
    required String walletName,
    required double initialBalance,
    required String passcode,
    required bool isLoading,
    @Default(false) bool isCurrentStepValid,
    String? errorMessage,
  }) = _OnboardingState;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStateFromJson(json);
}
