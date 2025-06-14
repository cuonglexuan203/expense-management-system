// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $appRoute,
      $signInRoute,
      $signUpRoute,
      $chatRoute,
      $walletRoute,
      $transactionRoute,
      $scheduleRoute,
      $statisticRoute,
      $profileRoute,
      $passcodeVerificationRoute,
      $onboardingRoute,
      $transactionSuggestionRoute,
    ];

RouteBase get $appRoute => GoRouteData.$route(
      path: '/',
      factory: $AppRouteExtension._fromState,
    );

extension $AppRouteExtension on AppRoute {
  static AppRoute _fromState(GoRouterState state) => const AppRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInRoute => GoRouteData.$route(
      path: '/signIn',
      factory: $SignInRouteExtension._fromState,
    );

extension $SignInRouteExtension on SignInRoute {
  static SignInRoute _fromState(GoRouterState state) => const SignInRoute();

  String get location => GoRouteData.$location(
        '/signIn',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signUpRoute => GoRouteData.$route(
      path: '/signUp',
      factory: $SignUpRouteExtension._fromState,
    );

extension $SignUpRouteExtension on SignUpRoute {
  static SignUpRoute _fromState(GoRouterState state) => const SignUpRoute();

  String get location => GoRouteData.$location(
        '/signUp',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatRoute => GoRouteData.$route(
      path: '/chat/:walletId',
      factory: $ChatRouteExtension._fromState,
    );

extension $ChatRouteExtension on ChatRoute {
  static ChatRoute _fromState(GoRouterState state) => ChatRoute(
        walletId: int.parse(state.pathParameters['walletId']!)!,
      );

  String get location => GoRouteData.$location(
        '/chat/${Uri.encodeComponent(walletId.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $walletRoute => GoRouteData.$route(
      path: '/wallet',
      factory: $WalletRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'create',
          factory: $CreateWalletRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: ':id',
          factory: $WalletDetailRouteExtension._fromState,
        ),
      ],
    );

extension $WalletRouteExtension on WalletRoute {
  static WalletRoute _fromState(GoRouterState state) => const WalletRoute();

  String get location => GoRouteData.$location(
        '/wallet',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CreateWalletRouteExtension on CreateWalletRoute {
  static CreateWalletRoute _fromState(GoRouterState state) =>
      const CreateWalletRoute();

  String get location => GoRouteData.$location(
        '/wallet/create',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $WalletDetailRouteExtension on WalletDetailRoute {
  static WalletDetailRoute _fromState(GoRouterState state) => WalletDetailRoute(
        id: int.parse(state.pathParameters['id']!)!,
      );

  String get location => GoRouteData.$location(
        '/wallet/${Uri.encodeComponent(id.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $transactionRoute => GoRouteData.$route(
      path: '/transactions/:walletId',
      factory: $TransactionRouteExtension._fromState,
    );

extension $TransactionRouteExtension on TransactionRoute {
  static TransactionRoute _fromState(GoRouterState state) => TransactionRoute(
        walletId: int.parse(state.pathParameters['walletId']!)!,
      );

  String get location => GoRouteData.$location(
        '/transactions/${Uri.encodeComponent(walletId.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $scheduleRoute => GoRouteData.$route(
      path: '/schedule',
      factory: $ScheduleRouteExtension._fromState,
    );

extension $ScheduleRouteExtension on ScheduleRoute {
  static ScheduleRoute _fromState(GoRouterState state) => const ScheduleRoute();

  String get location => GoRouteData.$location(
        '/schedule',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $statisticRoute => GoRouteData.$route(
      path: '/statistics',
      factory: $StatisticRouteExtension._fromState,
    );

extension $StatisticRouteExtension on StatisticRoute {
  static StatisticRoute _fromState(GoRouterState state) =>
      const StatisticRoute();

  String get location => GoRouteData.$location(
        '/statistics',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileRoute => GoRouteData.$route(
      path: '/profile',
      factory: $ProfileRouteExtension._fromState,
    );

extension $ProfileRouteExtension on ProfileRoute {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $passcodeVerificationRoute => GoRouteData.$route(
      path: '/passcode-verification',
      factory: $PasscodeVerificationRouteExtension._fromState,
    );

extension $PasscodeVerificationRouteExtension on PasscodeVerificationRoute {
  static PasscodeVerificationRoute _fromState(GoRouterState state) =>
      const PasscodeVerificationRoute();

  String get location => GoRouteData.$location(
        '/passcode-verification',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $onboardingRoute => GoRouteData.$route(
      path: '/onboarding',
      factory: $OnboardingRouteExtension._fromState,
    );

extension $OnboardingRouteExtension on OnboardingRoute {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  String get location => GoRouteData.$location(
        '/onboarding',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $transactionSuggestionRoute => GoRouteData.$route(
      path: '/transaction-suggestion/:notificationId',
      factory: $TransactionSuggestionRouteExtension._fromState,
    );

extension $TransactionSuggestionRouteExtension on TransactionSuggestionRoute {
  static TransactionSuggestionRoute _fromState(GoRouterState state) =>
      TransactionSuggestionRoute(
        notificationId: int.parse(state.pathParameters['notificationId']!)!,
      );

  String get location => GoRouteData.$location(
        '/transaction-suggestion/${Uri.encodeComponent(notificationId.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$routerHash() => r'd2bae0da3ec48d25f5902ecfabf702991b059a79';

/// See also [router].
@ProviderFor(router)
final routerProvider = AutoDisposeProvider<GoRouter>.internal(
  router,
  name: r'routerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$routerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RouterRef = AutoDisposeProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
