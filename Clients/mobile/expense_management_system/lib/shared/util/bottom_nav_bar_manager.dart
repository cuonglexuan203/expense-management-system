import 'package:expense_management_system/feature/home/provider/home_provider.dart';
import 'package:expense_management_system/shared/route/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Provider to track the current navigation index across the app
final currentNavIndexProvider = StateProvider<int>((ref) => 0);

// Class to manage bottom navigation
class BottomNavigationManager {
  static void handleNavigation(BuildContext context, WidgetRef ref, int index) {
    // Get current index
    final currentIndex = ref.read(currentNavIndexProvider);

    // Return if already on the same tab
    if (index == currentIndex && index != 0) return;

    // Update the current index
    ref.read(currentNavIndexProvider.notifier).state = index;

    // Navigate based on the selected tab
    switch (index) {
      case 0: // Home
        context.go('/');
        break;

      case 1: // Transactions
        // Get wallet ID from the current selected wallet
        final walletId = ref.read(homeNotifierProvider).maybeWhen(
              loaded: (wallets, selectedIndex) {
                if (wallets.isNotEmpty) {
                  return wallets[selectedIndex].id;
                }
                return null;
              },
              orElse: () => null,
            );

        if (walletId != null) {
          context.push('/transactions/$walletId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a wallet first')),
          );
          // Reset to home tab if no wallet is selected
          ref.read(currentNavIndexProvider.notifier).state = 0;
        }
        break;

      case 2: // Schedule - placeholder for future implementation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule feature coming soon')),
        );
        // Keep the current tab as selected, don't navigate
        break;

      case 3: // Profile
        context.go('/profile');
        break;

      default:
        context.go('/');
    }
  }
}
