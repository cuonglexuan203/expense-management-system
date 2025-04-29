// lib/feature/onboarding/provider/onboarding_provider.dart
import 'dart:developer';
import 'package:expense_management_system/feature/auth/repository/passcode_repository.dart';
import 'package:expense_management_system/feature/onboarding/model/onboarding.dart';
import 'package:expense_management_system/feature/onboarding/model/wallet_request.dart';
import 'package:expense_management_system/feature/onboarding/repository/onboarding_repository.dart';
import 'package:expense_management_system/feature/onboarding/state/onboarding_state.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() {
    _loadCategories();

    const defaultLanguage = 'en';
    const defaultCurrency = 'USD';

    return const OnboardingState(
      currentStep: OnboardingStep.languageCurrency,
      language: defaultLanguage,
      currency: defaultCurrency,
      categories: [],
      selectedCategoryIds: [],
      walletName: '',
      initialBalance: 0.0,
      passcode: '',
      isLoading: true,
      isCurrentStepValid: true,
      errorMessage: null,
    );
  }

  bool _checkStepValidity(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.languageCurrency:
        return state.language.isNotEmpty && state.currency.isNotEmpty;
      case OnboardingStep.categories:
        return state.selectedCategoryIds.isNotEmpty;
      case OnboardingStep.wallet:
        return state.walletName.isNotEmpty;
      case OnboardingStep.passcode:
        return state.passcode.length >= 4;
      default:
        return false;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final repository = ref.read(onboardingRepositoryProvider);
      final categories = await repository.getDefaultCategories();

      state = state.copyWith(
        categories: categories,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to load categories: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  void updateLanguageAndCurrency(String language, String currency) {
    state = state.copyWith(
      language: language,
      currency: currency,
    );

    if (state.currentStep == OnboardingStep.languageCurrency) {
      setStepValidity(_checkStepValidity(OnboardingStep.languageCurrency));
    }
  }

  void updateSelectedCategories(List<int> categoryIds) {
    state = state.copyWith(
      selectedCategoryIds: categoryIds,
    );

    if (state.currentStep == OnboardingStep.categories) {
      setStepValidity(_checkStepValidity(OnboardingStep.categories));
    }
  }

  void updateWallet(String name, double balance) {
    state = state.copyWith(
      walletName: name,
      initialBalance: balance,
    );

    if (state.currentStep == OnboardingStep.wallet) {
      setStepValidity(_checkStepValidity(OnboardingStep.wallet));
    }
  }

  void updatePasscode(String passcode) {
    state = state.copyWith(
      passcode: passcode,
    );

    if (state.currentStep == OnboardingStep.passcode) {
      setStepValidity(_checkStepValidity(OnboardingStep.passcode));
    }
  }

  void setStepValidity(bool isValid) {
    state = state.copyWith(isCurrentStepValid: isValid);
  }

  void goToPreviousStep() {
    final currentStep = state.currentStep;
    OnboardingStep previousStep;

    switch (currentStep) {
      case OnboardingStep.categories:
        previousStep = OnboardingStep.languageCurrency;
        break;
      case OnboardingStep.wallet:
        previousStep = OnboardingStep.categories;
        break;
      case OnboardingStep.passcode:
        previousStep = OnboardingStep.wallet;
        break;
      default:
        previousStep = currentStep;
    }

    final isPreviousStepValid = _checkStepValidity(previousStep);

    state = state.copyWith(
      currentStep: previousStep,
      isCurrentStepValid: isPreviousStepValid,
    );
  }

  void goToNextStep() {
    if (!state.isCurrentStepValid) {
      return;
    }

    final currentStep = state.currentStep;
    OnboardingStep nextStep;

    switch (currentStep) {
      case OnboardingStep.languageCurrency:
        nextStep = OnboardingStep.categories;
        break;
      case OnboardingStep.categories:
        nextStep = OnboardingStep.wallet;
        break;
      case OnboardingStep.wallet:
        nextStep = OnboardingStep.passcode;
        break;
      case OnboardingStep.passcode:
        nextStep = OnboardingStep.completed;
        break;
      default:
        nextStep = currentStep;
    }

    final isNextStepValid = _checkStepValidity(nextStep);

    state = state.copyWith(
      currentStep: nextStep,
      isCurrentStepValid: isNextStepValid,
    );
  }

  Future<bool> completeOnboarding() async {
    state = state.copyWith(isLoading: true);

    try {
      final request = OnboardingRequest(
        languageCode: state.language,
        currencyCode: state.currency,
        selectedCategoryIds: state.selectedCategoryIds,
        wallet: WalletRequest(
            name: state.walletName, balance: state.initialBalance),
        // passcode: state.passcode,
      );

      // Get passcode repository
      final passcodeRepository = ref.read(passcodeRepositoryProvider);

      // Store passcode securely if set
      if (state.passcode.isNotEmpty) {
        await passcodeRepository.setPasscode(state.passcode);
        log("Passcode saved during onboarding completion");

        // Explicitly check if biometrics should be enabled
        final localAuth = LocalAuthentication();
        final canCheckBiometrics = await localAuth.canCheckBiometrics;
        final isDeviceSupported = await localAuth.isDeviceSupported();

        if (canCheckBiometrics && isDeviceSupported) {
          // If biometrics are available, enable by default (this is user-friendly)
          await passcodeRepository.setBiometricsEnabled(true);
          log("Biometrics automatically enabled during onboarding completion");
        }
      } else {
        log("WARNING: No passcode was set during onboarding");
      }

      // Mark onboarding as completed
      await passcodeRepository.setOnboardingCompleted();
      // Submit onboarding data to backend
      final repository = ref.read(onboardingRepositoryProvider);
      final success =
          await repository.submitOnboarding(onboardingRequest: request);
      // Commented out for now, as we're focusing on fixing passcode flow

      state = state.copyWith(
        isLoading: false,
        currentStep: OnboardingStep.completed,
      );

      return true;
    } catch (e) {
      // Error handling
      log("Error during onboarding completion: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to complete onboarding: ${e.toString()}',
      );
      return false;
    }
  }
}
