import 'package:freezed_annotation/freezed_annotation.dart';
import 'wallet_request.dart';

part 'onboarding.freezed.dart';
part 'onboarding.g.dart';

@freezed
class OnboardingRequest with _$OnboardingRequest {
  const factory OnboardingRequest({
    required String language,
    required String currency,
    required List<int> selectedCategoryIds,
    required WalletRequest initialWallet,
    required String passcode,
  }) = _OnboardingRequest;

  factory OnboardingRequest.fromJson(Map<String, dynamic> json) =>
      _$OnboardingRequestFromJson(json);
}
