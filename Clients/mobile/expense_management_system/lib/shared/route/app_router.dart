// @CupertinoAutoRouter
// @AdaptiveAutoRouter
// @CustomAutoRouter

import 'package:expense_management_system/app/widget/app_start_page.dart';
import 'package:expense_management_system/feature/auth/widget/passcode_verification_page.dart';
import 'package:expense_management_system/feature/auth/widget/sign_in_page.dart';
import 'package:expense_management_system/feature/auth/widget/sign_up_page.dart';
import 'package:expense_management_system/feature/chat/widget/chat_page.dart';
import 'package:expense_management_system/feature/onboarding/widget/onboarding_page.dart';
import 'package:expense_management_system/feature/profile/widget/profile_page.dart';
import 'package:expense_management_system/feature/transaction/widget/transaction_page.dart';
import 'package:expense_management_system/feature/wallet/widget/create_wallet_page.dart';
import 'package:expense_management_system/feature/wallet/widget/wallet_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _key = GlobalKey<NavigatorState>(debugLabel: 'routerKey');

@riverpod
GoRouter router(RouterRef ref) {
  //final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    navigatorKey: _key,
    //refreshListenable: notifier,
    debugLogDiagnostics: true,
    initialLocation: AppRoute.path,
    routes: $appRoutes,
    //redirect: notifier.redirect,
  );
}

@TypedGoRoute<AppRoute>(path: AppRoute.path)
class AppRoute extends GoRouteData {
  const AppRoute();

  static const path = '/';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppStartPage();
  }
}

@TypedGoRoute<SignInRoute>(path: SignInRoute.path)
class SignInRoute extends GoRouteData {
  const SignInRoute();

  static const path = '/signIn';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignInPage();
  }
}

@TypedGoRoute<SignUpRoute>(path: SignUpRoute.path)
class SignUpRoute extends GoRouteData {
  const SignUpRoute();

  static const path = '/signUp';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignUpPage();
  }
}

@TypedGoRoute<ChatRoute>(path: ChatRoute.path)
class ChatRoute extends GoRouteData {
  const ChatRoute({required this.walletId});

  final int walletId;
  static const path = '/chat/:walletId';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatPage(walletId: walletId);
  }
}

@TypedGoRoute<WalletRoute>(
  path: WalletRoute.path,
  routes: [
    TypedGoRoute<CreateWalletRoute>(
      path: CreateWalletRoute.path,
    ),
    TypedGoRoute<WalletDetailRoute>(
      path: WalletDetailRoute.path,
    ),
  ],
)
class WalletRoute extends GoRouteData {
  const WalletRoute();

  static const path = '/wallet';

  // @override
  // Widget build(BuildContext context, GoRouterState state) {
  //   return ;
  // }
}

class CreateWalletRoute extends GoRouteData {
  const CreateWalletRoute();

  static const path = 'create';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateWalletPage();
  }
}

class WalletDetailRoute extends GoRouteData {
  const WalletDetailRoute({required this.id});

  final int id;
  static const path = ':id';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WalletDetailPage(walletId: id);
  }
}

@TypedGoRoute<TransactionRoute>(path: TransactionRoute.path)
class TransactionRoute extends GoRouteData {
  const TransactionRoute({required this.walletId});

  final int walletId;
  static const path = '/transactions/:walletId';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TransactionPage(walletId: walletId);
  }
}

@TypedGoRoute<ProfileRoute>(path: ProfileRoute.path)
class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  static const path = '/profile';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

@TypedGoRoute<PasscodeVerificationRoute>(path: PasscodeVerificationRoute.path)
class PasscodeVerificationRoute extends GoRouteData {
  const PasscodeVerificationRoute();

  static const path = '/passcode-verification';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PasscodeVerificationPage();
  }
}

@TypedGoRoute<OnboardingRoute>(path: OnboardingRoute.path)
class OnboardingRoute extends GoRouteData {
  const OnboardingRoute();

  static const path = '/onboarding';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const OnboardingPage();
  }
}

class GoNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('did push route ${route} : ${previousRoute}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('did pop route ${route} : ${previousRoute}');
  }
}
