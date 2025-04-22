// app.dart
import 'dart:developer';

import 'package:expense_management_system/app/provider/app_start_provider.dart';
import 'package:expense_management_system/app/provider/connectivity_provider.dart';
import 'package:expense_management_system/feature/auth/provider/auth_provider.dart';
import 'package:expense_management_system/feature/auth/repository/passcode_repository.dart';
import 'package:expense_management_system/shared/route/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App is going to background or getting minimized
      // Start counting the timer for passcode verification by NOT updating the verification time
      ref.read(passcodeRepositoryProvider).setAppWasBackgrounded();
      log("App going to background - passcode verification will be required after timeout");
    } else if (state == AppLifecycleState.resumed) {
      // App is coming back to foreground
      ref.read(passcodeRepositoryProvider).clearAppBackgroundedFlag();
      log("App returning to foreground, checking if passcode verification is needed");
      ref.read(appStartNotifierProvider.notifier).refreshState();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      if (previous != next) {
        // Refresh app start state when auth state changes
        ref.read(appStartNotifierProvider.notifier).refreshState();
      }
    });
    final router = ref.watch(routerProvider);

    // return MaterialApp.router(
    //   theme: ThemeData(
    //     fontFamily: GoogleFonts.nunito().fontFamily,
    //     visualDensity: VisualDensity.adaptivePlatformDensity,
    //     appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
    //     colorScheme: ColorScheme.fromSwatch(
    //       accentColor: const Color(0xFF13B9FF),
    //     ),
    //   ),
    //   routerConfig: router,
    // );
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: GoogleFonts.nunito().fontFamily, // Set default font
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          color: Color(0xFF13B9FF),
          // Optionally set text theme for AppBar as well
          // textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).appBarTheme.textTheme),
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFF13B9FF),
        ),
        // Apply font to text themes if needed for more control
        textTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).textTheme),
        primaryTextTheme:
            GoogleFonts.nunitoTextTheme(Theme.of(context).primaryTextTheme),
        // accentTextTheme: GoogleFonts.nunitoTextTheme(Theme.of(context).accentTextTheme),
      ),
      routerConfig: router,
    );
  }

// @override
// Widget build(BuildContext context,WidgetRef ref) {
//   final goRouter = ref.watch(goRouterProvider);
//
//   return MaterialApp.router(
//     builder: (context, child) => ResponsiveWrapper.builder(
//         child,
//         maxWidth: 1200,
//         minWidth: 480,
//         defaultScale: true,
//         breakpoints: [
//           const ResponsiveBreakpoint.resize(480, name: MOBILE),
//           const ResponsiveBreakpoint.autoScale(800, name: TABLET),
//           const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
//           const ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
//           const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
//         ],
//         background: Container(color: const Color(0xFFF5F5F5)),),
//
//     theme: ThemeData(
//       visualDensity: VisualDensity.adaptivePlatformDensity,
//       appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
//       colorScheme: ColorScheme.fromSwatch(
//         accentColor: const Color(0xFF13B9FF),
//       ),
//     ),
//     routerConfig: goRouter,
//   );
// }
//
// @override
// Widget build(BuildContext context,WidgetRef ref) {
//   return MaterialApp(
//     builder: (context, child) => ResponsiveWrapper.builder(
//         child,
//         maxWidth: 1200,
//         minWidth: 480,
//         defaultScale: true,
//         breakpoints: [
//           const ResponsiveBreakpoint.resize(480, name: MOBILE),
//                     const ResponsiveBreakpoint.autoScale(800, name: TABLET),
//                     const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
//                     const ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
//                     const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
//         ],
//         background: Container(color: Color(0xFFF5F5F5))),
//    home: HomePage(),
//   );
// }
}
