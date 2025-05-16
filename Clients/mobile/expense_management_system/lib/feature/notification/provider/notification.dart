import 'package:expense_management_system/feature/notification/models/app_notification.dart';
import 'package:expense_management_system/feature/notification/repositories/notification_repository.dart';
import 'package:expense_management_system/shared/pagination/pagination_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationsProvider = StateNotifierProvider<NotificationsNotifier,
    PaginatedState<AppNotification>>(
  (ref) => NotificationsNotifier(ref.read(notificationRepositoryProvider)),
);

class NotificationsNotifier
    extends StateNotifier<PaginatedState<AppNotification>> {
  final NotificationRepository _repository;

  NotificationsNotifier(this._repository)
      : super(PaginatedState.initial<AppNotification>()) {
    fetchNextPage();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.hasReachedEnd) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final nextPage =
          state.items.isEmpty ? 1 : state.paginationInfo.pageNumber + 1;

      final response = await _repository.getNotifications(
        pageNumber: nextPage,
        pageSize: state.paginationInfo.pageSize,
      );

      response.when(
        success: (paginatedResponse) {
          final newItems = paginatedResponse.items;

          if (newItems.isEmpty) {
            state = state.copyWith(
              isLoading: false,
              hasReachedEnd: true,
            );
            return;
          }

          state = state.copyWith(
            items: [...state.items, ...newItems],
            paginationInfo: paginatedResponse.paginationInfo,
            isLoading: false,
            hasReachedEnd: !paginatedResponse.paginationInfo.hasNextPage,
          );
        },
        error: (error) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: error.toString(),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = PaginatedState.initial<AppNotification>();
    await fetchNextPage();
  }

  // Future<void> markNotificationAsRead(int notificationId) async {
  //   try {
  //     final response = await _repository.markAsRead(notificationId);

  //     response.when(
  //       success: (_) {
  //         state = state.copyWith(
  //           items: state.items.map((notification) {
  //             if (notification.id == notificationId) {
  //               // Create a new notification with "Read" status
  //               return notification.copyWith(status: "Read");
  //             }
  //             return notification;
  //           }).toList(),
  //         );
  //       },
  //       error: (_) {
  //         // Handle error silently
  //       },
  //     );
  //   } catch (_) {
  //     // Handle exception silently
  //   }
  // }
}
