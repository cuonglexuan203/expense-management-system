// lib/feature/notification/repository/notification_repository.dart
import 'dart:convert';

import 'package:expense_management_system/feature/notification/models/app_notification.dart';
import 'package:expense_management_system/feature/notification/models/system_notification.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:expense_management_system/shared/pagination/pagination_info.dart';
import 'package:expense_management_system/shared/pagination/pagination_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepositoryProvider = Provider((ref) {
  final api = ref.watch(apiProvider);
  return NotificationRepository(api);
});

class NotificationRepository {
  final ApiProvider _api;

  NotificationRepository(this._api);

  Future<Object?> sendSystemNotification(
      SystemNotification notification) async {
    try {
      const endpoint = '${ApiEndpoints.base}/system-notifications';

      final response = await _api.post(
        endpoint,
        jsonEncode(notification.toJson()),
      );

      return response.when(
        success: (_) => debugPrint('System notification sent successfully'),
        error: (error) => throw error,
      );
    } catch (e) {
      debugPrint('Error sending system notification: $e');
      rethrow;
    }
  }

  Future<APIResponse<PaginatedResponse<AppNotification>>> getNotifications({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final query = {
        'PageNumber': pageNumber.toString(),
        'PageSize': pageSize.toString(),
      };

      final response = await _api.get(
        ApiEndpoints.notification.base,
        query: query,
      );

      return response.when(
        success: (data) {
          if (data is Map<String, dynamic> && data.containsKey('items')) {
            final items = data['items'] as List<dynamic>;
            final notifications = items
                .map((item) =>
                    AppNotification.fromJson(item as Map<String, dynamic>))
                .toList();
            final paginationInfo = PaginationInfo.fromJson(data);

            return APIResponse.success(
              PaginatedResponse(
                items: notifications,
                paginationInfo: paginationInfo,
              ),
            );
          } else {
            debugPrint('Invalid notification response format: $data');
            return const APIResponse.error(
              AppException.errorWithMessage('Invalid response format'),
            );
          }
        },
        error: (error) => APIResponse.error(error),
      );
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      return APIResponse.error(
        AppException.errorWithMessage(e.toString()),
      );
    }
  }

  // Future<Object?> rejectTransaction(int extractedTransactionId) async {
  //   try {
  //     final endpoint =
  //         '${ApiEndpoints.base}/extracted-transactions/$extractedTransactionId/reject';

  //     final response = await _api.post(
  //       endpoint,
  //       jsonEncode({}),
  //     );

  //     return response.when(
  //       success: (_) => debugPrint('Transaction rejected successfully'),
  //       error: (error) => throw error,
  //     );
  //   } catch (e) {
  //     debugPrint('Error rejecting transaction: $e');
  //     rethrow;
  //   }
  // }
}
