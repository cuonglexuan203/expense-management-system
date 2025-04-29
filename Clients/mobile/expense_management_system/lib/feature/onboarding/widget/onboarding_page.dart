// lib/feature/onboarding/widget/onboarding_page.dart
import 'package:expense_management_system/app/provider/app_start_provider.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_management_system/shared/route/app_router.dart';
import 'package:expense_management_system/feature/onboarding/provider/onboarding_provider.dart';
import 'package:expense_management_system/feature/onboarding/widget/language_currency_step.dart';
import 'package:expense_management_system/feature/onboarding/widget/categories_step.dart';
import 'package:expense_management_system/feature/onboarding/widget/wallet_step.dart';
import 'package:expense_management_system/feature/onboarding/widget/passcode_step.dart';
import 'package:expense_management_system/shared/widget/loading_widget.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingNotifierProvider);

    if (onboardingState.isLoading) {
      return const Scaffold(body: LoadingWidget());
    }

    if (onboardingState.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                onboardingState.errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref.refresh(onboardingNotifierProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar and Progress Indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Set Up Your Account',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      _buildStepIndicator(onboardingState.currentStep),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildStepCircle(OnboardingStep.languageCurrency,
                          onboardingState.currentStep, context),
                      _buildProgressLine(true, context),
                      _buildStepCircle(OnboardingStep.categories,
                          onboardingState.currentStep, context),
                      _buildProgressLine(
                          onboardingState.currentStep !=
                              OnboardingStep.languageCurrency,
                          context),
                      _buildStepCircle(OnboardingStep.wallet,
                          onboardingState.currentStep, context),
                      _buildProgressLine(
                          onboardingState.currentStep ==
                              OnboardingStep.passcode,
                          context),
                      _buildStepCircle(OnboardingStep.passcode,
                          onboardingState.currentStep, context),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getStepTitle(onboardingState.currentStep),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),

            // Step Content
            Expanded(
              child: _buildCurrentStep(onboardingState.currentStep),
            ),

            // Navigation Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (onboardingState.currentStep !=
                      OnboardingStep.languageCurrency)
                    OutlinedButton.icon(
                      onPressed: () {
                        ref
                            .read(onboardingNotifierProvider.notifier)
                            .goToPreviousStep();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 120),
                  ElevatedButton.icon(
                    onPressed: onboardingState.isCurrentStepValid
                        ? () async {
                            if (onboardingState.currentStep ==
                                OnboardingStep.passcode) {
                              final success = await ref
                                  .read(onboardingNotifierProvider.notifier)
                                  .completeOnboarding();
                              if (success) {
                                if (context.mounted) {
                                  ref.invalidate(appStartNotifierProvider);
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                }
                              }
                            } else {
                              ref
                                  .read(onboardingNotifierProvider.notifier)
                                  .goToNextStep();
                            }
                          }
                        : null, // Disable button if step is invalid
                    icon: Icon(
                      onboardingState.currentStep == OnboardingStep.passcode
                          ? Icons.check_circle
                          : Icons.arrow_forward,
                    ),
                    label: Text(
                      onboardingState.currentStep == OnboardingStep.passcode
                          ? 'Complete Setup'
                          : 'Continue',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCircle(
      OnboardingStep step, OnboardingStep currentStep, BuildContext context) {
    final isActive = _isStepActiveOrCompleted(step, currentStep);
    final isCurrent = step == currentStep;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
        shape: BoxShape.circle,
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                )
              ]
            : null,
      ),
      child: Center(
        child: isActive && !isCurrent
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                _getStepNumber(step),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildProgressLine(bool isActive, BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepIndicator(OnboardingStep currentStep) {
    final stepNumber = _getStepNumberInt(currentStep);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Step $stepNumber of 4',
        style: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  bool _isStepActiveOrCompleted(
      OnboardingStep step, OnboardingStep currentStep) {
    switch (currentStep) {
      case OnboardingStep.languageCurrency:
        return step == OnboardingStep.languageCurrency;
      case OnboardingStep.categories:
        return step != OnboardingStep.passcode && step != OnboardingStep.wallet;
      case OnboardingStep.wallet:
        return step != OnboardingStep.passcode;
      case OnboardingStep.passcode:
        return true;
      default:
        return false;
    }
  }

  String _getStepNumber(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.languageCurrency:
        return '1';
      case OnboardingStep.categories:
        return '2';
      case OnboardingStep.wallet:
        return '3';
      case OnboardingStep.passcode:
        return '4';
      default:
        return '';
    }
  }

  int _getStepNumberInt(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.languageCurrency:
        return 1;
      case OnboardingStep.categories:
        return 2;
      case OnboardingStep.wallet:
        return 3;
      case OnboardingStep.passcode:
        return 4;
      default:
        return 0;
    }
  }

  String _getStepTitle(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.languageCurrency:
        return 'Choose Language & Currency';
      case OnboardingStep.categories:
        return 'Select Categories';
      case OnboardingStep.wallet:
        return 'Create Your First Wallet';
      case OnboardingStep.passcode:
        return 'Set Up Passcode';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep(OnboardingStep step) {
    switch (step) {
      case OnboardingStep.languageCurrency:
        return const LanguageCurrencyStep();
      case OnboardingStep.categories:
        return const CategoriesStep();
      case OnboardingStep.wallet:
        return const WalletStep();
      case OnboardingStep.passcode:
        return const PasscodeStep();
      default:
        return const SizedBox.shrink();
    }
  }
}
