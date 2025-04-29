import 'dart:convert';
import 'package:expense_management_system/feature/notification/models/device_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';

final deviceTokenRepositoryProvider = Provider((ref) {
  final api = ref.watch(apiProvider);
  return DeviceTokenRepository(api);
});

class DeviceTokenRepository {
  final ApiProvider _api;

  DeviceTokenRepository(this._api);

  Future<Object?> registerToken(DeviceToken deviceToken) async {
    try {
      final response = await _api.post(
        ApiEndpoints.devicesToken.registerToken,
        jsonEncode({
          "token": deviceToken.token,
          "platform": deviceToken.platform.value,
        }),
      );

      return response.when(
        success: (_) => debugPrint('Token registered successfully'),
        error: (error) => throw error,
      );
    } catch (e) {
      debugPrint('Error registering device token: $e');
      rethrow;
    }
  }
}
