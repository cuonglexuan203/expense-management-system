import 'dart:async';
import 'dart:developer';

import 'package:expense_management_system/app/provider/app_start_provider.dart';
import 'package:expense_management_system/app/provider/connectivity_provider.dart';
import 'package:expense_management_system/feature/auth/provider/auth_provider.dart';
import 'package:expense_management_system/feature/auth/repository/passcode_repository.dart';
import 'package:expense_management_system/shared/route/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_start_state.dart';

final pendingNavigationProvider =
    StateProvider<String?>((ref) => null, name: 'pendingNavigationProvider');

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    log("App initialized, observer added");
    ref.read(connectivityProvider);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    log("App disposed, observer removed");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("App lifecycle state changed: $state");

    if (state == AppLifecycleState.resumed) {
      ref.read(appStartNotifierProvider.notifier).refreshState();
      log("App resumed, refreshing state (passcode check etc.)");
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      ref.read(passcodeRepositoryProvider).setAppWasBackgrounded();
      log("App going to background - passcode verification will be required after timeout");
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      ref.listen<String?>(pendingNavigationProvider, (previous, next) {
        final router = ref.read(routerProvider);
        final String currentRoute =
            router.routerDelegate.currentConfiguration.last.route.path;
        final appStartState = ref.read(appStartNotifierProvider);
        final bool isAppAuthenticated = appStartState.maybeWhen(
          data: (data) => data.maybeWhen(
            authenticated: () => true,
            orElse: () => false,
          ),
          orElse: () => false,
        );

        if (next != null && next != currentRoute && isAppAuthenticated) {
          router.push(next);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ref.read(pendingNavigationProvider) == next) {
              ref.read(pendingNavigationProvider.notifier).state = null;
            }
          });
        } else if (next != null && !isAppAuthenticated) {}
      });
    } catch (e, stackTrace) {
      log("[Listener 1] Error setting up pending navigation listener in build: $e",
          stackTrace: stackTrace);
    }

    try {
      ref.listen<AsyncValue<AppStartState>>(appStartNotifierProvider,
          (previous, next) {
        final router = ref.read(routerProvider);
        final pendingNav = ref.read(pendingNavigationProvider);
        final String currentRoute =
            router.routerDelegate.currentConfiguration.last.route.path;

        final bool isNowAuthenticated = next.maybeWhen(
          data: (data) => data.maybeWhen(
            authenticated: () => true,
            orElse: () => false,
          ),
          orElse: () => false,
        );
        final bool wasPreviouslyAuthenticated = previous?.maybeWhen(
              data: (data) => data.maybeWhen(
                authenticated: () => true,
                orElse: () => false,
              ),
              orElse: () => false,
            ) ??
            false;

        if (isNowAuthenticated &&
            !wasPreviouslyAuthenticated &&
            pendingNav != null &&
            pendingNav != currentRoute) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ref.read(pendingNavigationProvider) == pendingNav) {
              router.push(pendingNav);
              ref.read(pendingNavigationProvider.notifier).state = null;
            }
          });
        }
      });
    } catch (e, stackTrace) {}

    ref.listen(authNotifierProvider, (previous, next) {
      if (previous != next) {
        log("Auth state changed, refreshing app start state.");
        ref.read(appStartNotifierProvider.notifier).refreshState();
      }
    });

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: GoogleFonts.nunito().fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: Color(0xFF13B9FF),
        ),
        colorScheme: ColorScheme.fromSwatch(
          // ignore: deprecated_member_use
          accentColor: const Color(0xFF13B9FF),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
        primaryTextTheme:
            GoogleFonts.nunitoTextTheme(Theme.of(context).primaryTextTheme),
      ),
      routerConfig: router,
    );
  }
}
