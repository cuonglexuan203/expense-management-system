// app_start_provider.dart
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expense_management_system/app/provider/connectivity_provider.dart';
import 'package:expense_management_system/feature/auth/provider/auth_provider.dart';
import 'package:expense_management_system/feature/auth/repository/token_repository.dart';
import 'package:expense_management_system/feature/auth/repository/passcode_repository.dart';
import 'package:expense_management_system/feature/auth/state/auth_state.dart';
import 'package:expense_management_system/feature/onboarding/repository/onboarding_repository.dart';
import 'package:expense_management_system/shared/constants/enum.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../state/app_start_state.dart';

part 'app_start_provider.g.dart';

@riverpod
class AppStartNotifier extends _$AppStartNotifier {
  late final TokenRepository _tokenRepository =
      ref.read(tokenRepositoryProvider);
  late final PasscodeRepository _passcodeRepository =
      ref.read(passcodeRepositoryProvider);
  late final OnboardingRepository _onboardingRepository =
      ref.read(onboardingRepositoryProvider);

  FutureOr<AppStartState> build() async {
    final connectionState = ref.watch(connectivityProvider);

    if (connectionState == ConnectionState.offline) {
      return const AppStartState.internetUnAvailable();
    }

    ref.listen<ConnectionState>(connectivityProvider, (previous, current) {
      if (current == ConnectionState.offline) {
        state = const AsyncValue.data(AppStartState.internetUnAvailable());
      } else if (previous == ConnectionState.offline &&
          current == ConnectionState.online) {
        refreshState();
      }
    });

    ref.listen(authNotifierProvider, (_, __) {
      refreshState();
    });

    return checkAuthAndLockStatus();
  }

  Future<bool> hasInternetConnection() async {
    return ref.read(connectivityProvider) == ConnectionState.online;
  }

  // Future<AppStartState> checkAuthAndLockStatus() async {
  //   log("Checking authentication and lock status");

  //   try {
  //     // Check network connectivity first
  //     bool hasInternet = await hasInternetConnection();
  //     if (!hasInternet) {
  //       log("No internet connection");
  //       return const AppStartState.internetUnAvailable();
  //     }

  //     // Check authentication status
  //     final authState = ref.read(authNotifierProvider);
  //     var isAuthenticated = false;

  //     // Use the correct Freezed pattern matching approach for pattern matching
  //     if (authState is AuthStateLoggedIn) {
  //       log("User is logged in according to AuthState");
  //       isAuthenticated = true;
  //     } else if (authState is AuthStateLoggedOut) {
  //       log("User is logged out according to AuthState");
  //       isAuthenticated = false;
  //     } else {
  //       // Handle all other states (initial, loading, error) by checking token
  //       log("Auth state is not definitive (${authState.runtimeType}), checking token");
  //       final token = await _tokenRepository.fetchToken();
  //       if (token != null) {
  //         log("Valid token found in storage");
  //         isAuthenticated = true;
  //       } else {
  //         log("No valid token found in storage");
  //       }
  //     }

  //     if (!isAuthenticated) {
  //       log("Returning unauthenticated state");
  //       return const AppStartState.unauthenticated();
  //     }

  //     // Now we know the user is authenticated, check if they've completed onboarding
  //     final hasCompletedOnboarding =
  //         await _passcodeRepository.hasCompletedOnboarding();
  //     log("Has completed onboarding: $hasCompletedOnboarding");

  //     if (!hasCompletedOnboarding) {
  //       log("Onboarding not completed, returning requireOnboarding state");
  //       return const AppStartState.requireOnboarding();
  //     }

  //     // Check if passcode verification is needed
  //     final isPasscodeSet = await _passcodeRepository.isPasscodeSet();
  //     log("Is passcode set: $isPasscodeSet");

  //     if (isPasscodeSet) {
  //       // Check if we need to verify the passcode
  //       final requiresPasscode =
  //           await _passcodeRepository.shouldRequirePasscode();
  //       log("Should require passcode verification: $requiresPasscode");

  //       if (requiresPasscode) {
  //         log("Passcode verification required, returning requirePasscode state");
  //         return const AppStartState.requirePasscode();
  //       }
  //     }

  //     // User is authenticated, has completed onboarding, and doesn't need passcode verification
  //     log("User fully authenticated, returning authenticated state");
  //     return const AppStartState.authenticated();
  //   } catch (e) {
  //     log("Error during app state check: $e");
  //     // In case of any error, default to requiring authentication
  //     return const AppStartState.unauthenticated();
  //   }
  // }

  Future<AppStartState> checkAuthAndLockStatus() async {
    log("Checking authentication and lock status");

    try {
      // Check network connectivity first
      bool hasInternet = await hasInternetConnection();
      if (!hasInternet) {
        log("No internet connection");
        return const AppStartState.internetUnAvailable();
      }

      // Check authentication status
      final authState = ref.read(authNotifierProvider);
      var isAuthenticated = false;

      if (authState is AuthStateLoggedIn) {
        log("User is logged in according to AuthState");
        isAuthenticated = true;
      } else if (authState is AuthStateLoggedOut) {
        log("User is logged out according to AuthState");
        isAuthenticated = false;
      } else {
        log("Auth state is not definitive (${authState.runtimeType}), checking token");
        final token = await _tokenRepository.fetchToken();
        if (token != null) {
          log("Valid token found in storage");
          isAuthenticated = true;
        } else {
          log("No valid token found in storage");
        }
      }

      if (!isAuthenticated) {
        log("Returning unauthenticated state");
        return const AppStartState.unauthenticated();
      }

      // NEW: Check onboarding status from server first, then fallback to local storage
      try {
        final hasCompletedOnboardingOnServer =
            await _onboardingRepository.checkOnboardingStatus();
        log("Has completed onboarding (from server): $hasCompletedOnboardingOnServer");

        if (!hasCompletedOnboardingOnServer) {
          log("Onboarding not completed according to server, returning requireOnboarding state");
          return const AppStartState.requireOnboarding();
        }

        // If onboarding is completed on server but not locally, update local storage
        final hasCompletedOnboardingLocally =
            await _passcodeRepository.hasCompletedOnboarding();
        if (hasCompletedOnboardingOnServer && !hasCompletedOnboardingLocally) {
          await _passcodeRepository.setOnboardingCompleted();
        }
      } catch (e) {
        // If server check fails, fall back to local storage
        log("Error checking onboarding status from server: $e, falling back to local check");
        final hasCompletedOnboarding =
            await _passcodeRepository.hasCompletedOnboarding();

        if (!hasCompletedOnboarding) {
          log("Onboarding not completed according to local storage, returning requireOnboarding state");
          return const AppStartState.requireOnboarding();
        }
      }

      // Rest of the existing logic for passcode verification...
      final isPasscodeSet = await _passcodeRepository.isPasscodeSet();
      log("Is passcode set: $isPasscodeSet");

      if (isPasscodeSet) {
        final requiresPasscode =
            await _passcodeRepository.shouldRequirePasscode();
        log("Should require passcode verification: $requiresPasscode");

        if (requiresPasscode) {
          log("Passcode verification required, returning requirePasscode state");
          return const AppStartState.requirePasscode();
        }
      }

      log("User fully authenticated, returning authenticated state");
      return const AppStartState.authenticated();
    } catch (e) {
      log("Error during app state check: $e");
      return const AppStartState.unauthenticated();
    }
  }

  void authenticateUser() {
    log("User authenticated via passcode/biometrics");
    state = const AsyncValue.data(AppStartState.authenticated());
  }

  Future<void> refreshState() async {
    log("Refreshing app state");
    state = const AsyncValue.loading();
    state = AsyncValue.data(await checkAuthAndLockStatus());
  }
}
