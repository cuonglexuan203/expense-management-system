// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingRequestImpl _$$OnboardingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingRequestImpl(
      language: json['language'] as String,
      currency: json['currency'] as String,
      selectedCategoryIds: (json['selectedCategoryIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      initialWallet:
          WalletRequest.fromJson(json['initialWallet'] as Map<String, dynamic>),
      passcode: json['passcode'] as String,
    );

Map<String, dynamic> _$$OnboardingRequestImplToJson(
        _$OnboardingRequestImpl instance) =>
    <String, dynamic>{
      'language': instance.language,
      'currency': instance.currency,
      'selectedCategoryIds': instance.selectedCategoryIds,
      'initialWallet': instance.initialWallet,
      'passcode': instance.passcode,
    };
