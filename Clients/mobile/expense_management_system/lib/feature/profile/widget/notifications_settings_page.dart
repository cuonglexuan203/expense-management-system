import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/notification/models/system_notification.dart';
import 'package:expense_management_system/feature/notification/service/notification_listener_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingsWidget extends ConsumerStatefulWidget {
  const NotificationSettingsWidget({super.key});

  @override
  ConsumerState<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends ConsumerState<NotificationSettingsWidget> {
  bool _hasPermission = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkInitialPermission();
    ref.read(notificationListenerServiceProvider).initialize();
  }

  Future<void> _checkInitialPermission() async {
    setState(() => _isLoading = true);
    final service = ref.read(notificationListenerServiceProvider);
    final permission = await service.checkNotificationListenerPermission();
    if (mounted) {
      setState(() {
        _hasPermission = permission;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestPermission() async {
    final service = ref.read(notificationListenerServiceProvider);
    final openedSettings =
        await service.requestNotificationListenerPermission();
    if (openedSettings) {
      AppSnackBar.showWarning(
          context: context,
          message:
              'Please find and enable notification access permission for the app in system settings.');
    } else {
      AppSnackBar.showError(
          context: context,
          message: 'Unable to open notification access settings.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe stream notification mới để cập nhật UI (ví dụ)
    // ref.listen<AsyncValue<SystemNotification>>(systemNotificationStreamProvider,
    //     (_, next) {
    //   next.whenData((notification) {
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('UI Received: ${notification.title}')),
    //       );
    //     }
    //   });
    // });

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListTile(
      leading: Icon(
        _hasPermission ? Icons.notifications_active : Icons.notifications_off,
        color: _hasPermission ? Colors.green : Colors.grey,
      ),
      title: const Text('Access Notification'),
      subtitle: Text(_hasPermission
          ? 'Granted permission to automatically record transactions'
          : 'Permission not granted, please enable in settings'),
      trailing: ElevatedButton(
        onPressed: _hasPermission ? null : _requestPermission,
        child:
            Text(_hasPermission ? 'Permission granted' : 'Request permission'),
      ),
      onTap: _hasPermission ? null : _requestPermission,
    );
  }
}
