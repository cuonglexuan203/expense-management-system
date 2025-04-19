// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnboardingRequestImpl _$$OnboardingRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$OnboardingRequestImpl(
      languageCode: json['languageCode'] as String,
      currencyCode: json['currencyCode'] as String,
      selectedCategoryIds: (json['selectedCategoryIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      wallet: WalletRequest.fromJson(json['wallet'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OnboardingRequestImplToJson(
        _$OnboardingRequestImpl instance) =>
    <String, dynamic>{
      'languageCode': instance.languageCode,
      'currencyCode': instance.currencyCode,
      'selectedCategoryIds': instance.selectedCategoryIds,
      'wallet': instance.wallet,
    };
