// lib/feature/onboarding/repository/onboarding_repository.dart
import 'dart:convert';
import 'dart:developer';
import 'package:expense_management_system/feature/onboarding/model/onboarding.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:expense_management_system/feature/category/model/category.dart';

final onboardingRepositoryProvider =
    Provider((ref) => OnboardingRepository(ref));

class OnboardingRepository {
  OnboardingRepository(this._ref);

  final Ref _ref;
  late final ApiProvider _api = _ref.read(apiProvider);

  Future<List<Category>> getDefaultCategories() async {
    final response = await _api.get(ApiEndpoints.category.getDefault);

    return response.when(
      success: (data) {
        if (data is List) {
          return data
              .map((item) => Category.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          final List<dynamic> categoriesData = data['data'] as List<dynamic>;
          return categoriesData
              .map((item) => Category.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        throw const AppException.errorWithMessage(
            'Invalid categories data format');
      },
      error: (error) {
        throw error;
      },
    );
  }

  Future<bool> checkOnboardingStatus() async {
    try {
      log('Checking onboarding status from server');
      final response = await _api.get(ApiEndpoints.user.getOnboardingStatus);

      return response.when(
        success: (data) {
          // The API returns a boolean directly
          if (data is bool) {
            log('Onboarding status from server: $data');
            return data;
          }

          // Handle string "true"/"false" responses
          if (data is String) {
            return data.toLowerCase() == 'true';
          }

          log('Unexpected onboarding status response format: $data');
          return false; // Default to requiring onboarding if format is unexpected
        },
        error: (error) {
          log('Error checking onboarding status: ${error.toString()}');
          throw error;
        },
      );
    } catch (e) {
      log('Exception checking onboarding status: $e');
      throw AppException.errorWithMessage(e.toString());
    }
  }

  Future<bool> submitOnboarding({
    required OnboardingRequest onboardingRequest,
  }) async {
    // final request = {
    //   'language': onboardingRequest.language,
    //   'currency': onboardingRequest.currency,
    //   'selectedCategoryIds': onboardingRequest.selectedCategoryIds,
    //   'initialWallet': onboardingRequest.initialWallet.toJson(),
    //   'passcode': onboardingRequest.passcode,
    // };

    final response = await _api.post(
        ApiEndpoints.user.onboarding, jsonEncode(onboardingRequest));

    return response.when(
      success: (_) => true,
      error: (error) => throw error,
    );
  }
}
