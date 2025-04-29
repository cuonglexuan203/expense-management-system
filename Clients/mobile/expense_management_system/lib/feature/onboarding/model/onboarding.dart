import 'package:freezed_annotation/freezed_annotation.dart';
import 'wallet_request.dart';

part 'onboarding.freezed.dart';
part 'onboarding.g.dart';

@freezed
class OnboardingRequest with _$OnboardingRequest {
  const factory OnboardingRequest({
    required String languageCode,
    required String currencyCode,
    required List<int> selectedCategoryIds,
    required WalletRequest wallet,
    // required String passcode,
  }) = _OnboardingRequest;

  factory OnboardingRequest.fromJson(Map<String, dynamic> json) =>
      _$OnboardingRequestFromJson(json);
}
