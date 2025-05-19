// lib/feature/notification/page/notifications_page.dart
import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/notification/models/app_notification.dart';
import 'package:expense_management_system/feature/notification/provider/notification.dart';
import 'package:expense_management_system/feature/notification/widget/notifications_title.dart';
import 'package:expense_management_system/shared/pagination/pagination_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _loadMoreIfNeeded();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll - 200);
  }

  void _loadMoreIfNeeded() {
    final notificationState = ref.read(notificationsProvider);
    if (!notificationState.isLoading && !notificationState.hasReachedEnd) {
      ref.read(notificationsProvider.notifier).fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Iconsax.more),
        //     onPressed: () {
        //       showModalBottomSheet(
        //         context: context,
        //         builder: (context) => SafeArea(
        //           child: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               ListTile(
        //                 leading: const Icon(Iconsax.tick_circle),
        //                 title: const Text('Mark all as read'),
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                   // You would implement mark all as read functionality here
        //                   AppSnackBar.showInfo(
        //                     context: context,
        //                     message: 'All notifications marked as read',
        //                   );
        //                 },
        //               ),
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
        color: Theme.of(context).primaryColor,
        child: state.errorMessage != null
            ? _buildErrorState(state.errorMessage!)
            : state.items.isEmpty && !state.isLoading
                ? _buildEmptyState()
                : _buildNotificationList(state),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.notification, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'We\'ll notify you when something important happens',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.warning_2, size: 64, color: Colors.orange),
          const SizedBox(height: 16),
          const Text(
            'Oops!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Failed to load notifications: $errorMessage',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(notificationsProvider.notifier).refresh(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList(PaginatedState<AppNotification> state) {
    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: state.items.length + (state.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.items.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              // child: CircularProgressIndicator(),
            ),
          );
        }

        final notification = state.items[index];
        return NotificationTile(
          notification: notification,
          onTap: () {
            // Tampilkan snackbar
            AppSnackBar.showInfo(
              context: context,
              message: 'Notification ${notification.title}',
            );
          },
        );
      },
    );
  }
}
