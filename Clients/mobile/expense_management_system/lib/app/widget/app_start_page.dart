import 'package:expense_management_system/app/provider/app_start_provider.dart';
import 'package:expense_management_system/feature/auth/widget/passcode_verification_page.dart';
import 'package:expense_management_system/feature/auth/widget/sign_in_page.dart';
import 'package:expense_management_system/feature/home/widget/home_page.dart';
import 'package:expense_management_system/feature/onboarding/widget/onboarding_page.dart';
import 'package:expense_management_system/shared/widget/connection_unavailable_widget.dart';
import 'package:expense_management_system/shared/widget/error_page.dart';
import 'package:expense_management_system/shared/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppStartPage extends ConsumerWidget {
  const AppStartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStartNotifierProvider);

    return state.when(
      data: (data) {
        return data.maybeWhen(
          initial: () => const LoadingWidget(),
          authenticated: () => const HomePage(),
          unauthenticated: () => SignInPage(),
          internetUnAvailable: () => const ConnectionUnavailableWidget(),
          requirePasscode: () => const PasscodeVerificationPage(),
          requireOnboarding: () => const OnboardingPage(),
          orElse: () => const LoadingWidget(),
        );
      },
      error: (e, st) => const ErrorPage(),
      loading: () => const LoadingWidget(),
    );
  }
}
