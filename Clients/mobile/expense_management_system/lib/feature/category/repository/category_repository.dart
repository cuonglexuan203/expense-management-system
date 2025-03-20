import 'dart:convert';
import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
import 'package:expense_management_system/shared/http/api_response.dart';
import 'package:expense_management_system/shared/http/app_exception.dart';
import 'package:expense_management_system/shared/pagination/pagination_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryRepositoryProvider = Provider(CategoryRepository.new);

class CategoryRepository {
  CategoryRepository(this._ref);
  final Ref _ref;
  late final ApiProvider _api = _ref.read(apiProvider);

  Future<APIResponse<Map<String, dynamic>>> getCategories(
    String flowType, {
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _api.get(
        ApiEndpoints.category.getAll,
        query: {
          'financialFlowType': flowType,
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
        },
      );

      return response.when(
        success: (data) {
          if (data is Map<String, dynamic> && data.containsKey("items")) {
            final items = data["items"] as List<dynamic>;

            final categories = items
                .whereType<Map<String, dynamic>>()
                .map((e) => Category.fromJson(e))
                .toList();

            final pagination = PaginationInfo(
              pageNumber: data["pageNumber"] as int,
              pageSize: data["pageSize"] as int,
              totalPages: data["totalPages"] as int,
              totalCount: data["totalCount"] as int,
              hasPreviousPage: data["hasPreviousPage"] as bool,
              hasNextPage: data["hasNextPage"] as bool,
            );

            return APIResponse.success({
              "categories": categories,
              "pagination": pagination,
            });
          } else {
            return const APIResponse.error(
                AppException.errorWithMessage("Invalid response format"));
          }
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }

  Future<APIResponse<Category>> createCategory(
    String name,
    String flowType, {
    bool isDefault = false,
  }) async {
    try {
      final body = {
        'name': name,
        'isDefault': isDefault,
        'financialFlowType': flowType,
      };

      final response = await _api.post(
        ApiEndpoints.category.create,
        jsonEncode(body),
      );

      return response.when(
        success: (data) {
          final category = Category.fromJson(data as Map<String, dynamic>);
          return APIResponse.success(category);
        },
        error: APIResponse.error,
      );
    } catch (e) {
      return APIResponse.error(AppException.errorWithMessage(e.toString()));
    }
  }
}
