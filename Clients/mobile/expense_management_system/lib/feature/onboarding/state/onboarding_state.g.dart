// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingStateImpl _$$OnboardingStateImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingStateImpl(
      currentStep: $enumDecode(_$OnboardingStepEnumMap, json['currentStep']),
      language: json['language'] as String,
      currency: json['currency'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedCategoryIds: (json['selectedCategoryIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      walletName: json['walletName'] as String,
      initialBalance: (json['initialBalance'] as num).toDouble(),
      passcode: json['passcode'] as String,
      isLoading: json['isLoading'] as bool,
      isCurrentStepValid: json['isCurrentStepValid'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$OnboardingStateImplToJson(
        _$OnboardingStateImpl instance) =>
    <String, dynamic>{
      'currentStep': _$OnboardingStepEnumMap[instance.currentStep]!,
      'language': instance.language,
      'currency': instance.currency,
      'categories': instance.categories,
      'selectedCategoryIds': instance.selectedCategoryIds,
      'walletName': instance.walletName,
      'initialBalance': instance.initialBalance,
      'passcode': instance.passcode,
      'isLoading': instance.isLoading,
      'isCurrentStepValid': instance.isCurrentStepValid,
      'errorMessage': instance.errorMessage,
    };

const _$OnboardingStepEnumMap = {
  OnboardingStep.languageCurrency: 'languageCurrency',
  OnboardingStep.categories: 'categories',
  OnboardingStep.wallet: 'wallet',
  OnboardingStep.passcode: 'passcode',
  OnboardingStep.completed: 'completed',
};
