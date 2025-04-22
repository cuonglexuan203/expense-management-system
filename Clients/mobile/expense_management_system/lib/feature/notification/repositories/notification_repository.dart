// lib/feature/notification/repository/notification_repository.dart
import 'dart:convert';

import 'package:expense_management_system/feature/notification/models/system_notification.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
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

  Future<Object?> confirmTransaction(int extractedTransactionId) async {
    try {
      final endpoint = ApiEndpoints.extractedTransaction
          .confirmTransaction(extractedTransactionId);

      final response = await _api.post(
        endpoint,
        jsonEncode({}),
      );

      return response.when(
        success: (_) => debugPrint('Transaction confirmed successfully'),
        error: (error) => throw error,
      );
    } catch (e) {
      debugPrint('Error confirming transaction: $e');
      rethrow;
    }
  }

  Future<Object?> rejectTransaction(int extractedTransactionId) async {
    try {
      final endpoint =
          '${ApiEndpoints.base}/extracted-transactions/$extractedTransactionId/reject';

      final response = await _api.post(
        endpoint,
        jsonEncode({}),
      );

      return response.when(
        success: (_) => debugPrint('Transaction rejected successfully'),
        error: (error) => throw error,
      );
    } catch (e) {
      debugPrint('Error rejecting transaction: $e');
      rethrow;
    }
  }
}
