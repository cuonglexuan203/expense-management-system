import 'package:flutter/material.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:iconsax/iconsax.dart';

class AppSnackBar {
  /// Shows a custom snackbar with specified type and message
  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onDismissed,
  }) {
    final snackBar = _buildSnackBar(
      message: message,
      type: type,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onDismissed: onDismissed,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Shows a success snackbar
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onDismissed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onDismissed: onDismissed,
    );
  }

  /// Shows an error snackbar
  static void showError({
    required BuildContext context,
    required String message,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onDismissed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onDismissed: onDismissed,
    );
  }

  /// Shows a warning snackbar
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onDismissed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onDismissed: onDismissed,
    );
  }

  /// Shows an info snackbar
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onDismissed,
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      onDismissed: onDismissed,
    );
  }

  /// Builds the custom snackbar widget
  static SnackBar _buildSnackBar({
    required String message,
    required SnackBarType type,
    Duration? duration,
    String? actionLabel,
    VoidCallback? onActionPressed,
    VoidCallback? onDismissed,
  }) {
    final snackBarConfig = _getSnackBarConfig(type);

    return SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: snackBarConfig.iconBackgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              snackBarConfig.icon,
              color: snackBarConfig.iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: snackBarConfig.backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 4),
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: snackBarConfig.borderColor,
          width: 1,
        ),
      ),
      action: actionLabel != null && onActionPressed != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: snackBarConfig.actionColor,
              onPressed: onActionPressed,
            )
          : null,
      onVisible: () {
        // Animation can be added here if needed
      },
    );
  }

  /// Get configuration for specific snackbar type
  static _SnackBarConfig _getSnackBarConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          backgroundColor: const Color(0xFF1E3329),
          iconBackgroundColor: const Color(0xFF35A770).withOpacity(0.2),
          borderColor: const Color(0xFF35A770).withOpacity(0.3),
          icon: Iconsax.tick_circle,
          iconColor: const Color(0xFF35A770),
          actionColor: ColorName.blue,
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          backgroundColor: const Color(0xFF3A1F2B),
          iconBackgroundColor: const Color(0xFFE53E3E).withOpacity(0.2),
          borderColor: const Color(0xFFE53E3E).withOpacity(0.3),
          icon: Iconsax.info_circle,
          iconColor: const Color(0xFFE53E3E),
          actionColor: Colors.white70,
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          backgroundColor: const Color(0xFF332D1E),
          iconBackgroundColor: const Color(0xFFEAB308).withOpacity(0.2),
          borderColor: const Color(0xFFEAB308).withOpacity(0.3),
          icon: Iconsax.warning_2,
          iconColor: const Color(0xFFEAB308),
          actionColor: Colors.white70,
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          backgroundColor: const Color(0xFF1A2A36),
          iconBackgroundColor: ColorName.blue.withOpacity(0.2),
          borderColor: ColorName.blue.withOpacity(0.3),
          icon: Iconsax.information,
          iconColor: ColorName.blue,
          actionColor: Colors.white70,
        );
    }
  }
}

/// Types of snackbars available
enum SnackBarType {
  success,
  error,
  warning,
  info,
}

/// Configuration for each snackbar type
class _SnackBarConfig {
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;
  final Color actionColor;

  _SnackBarConfig({
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.borderColor,
    required this.icon,
    required this.iconColor,
    required this.actionColor,
  });
}
