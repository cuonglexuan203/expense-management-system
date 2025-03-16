// lib/feature/category/repository/category_repository.dart
import 'dart:convert';
import 'package:flutter_boilerplate/feature/category/model/category.dart';
import 'package:flutter_boilerplate/shared/constants/api_endpoints.dart';
import 'package:flutter_boilerplate/shared/http/api_provider.dart';
import 'package:flutter_boilerplate/shared/http/api_response.dart';
import 'package:flutter_boilerplate/shared/http/app_exception.dart';
import 'package:flutter_boilerplate/shared/model/pagination_info.dart';
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
          if (data is Map<String, dynamic> && data.containsKey('items')) {
            final items = data['items'] as List<dynamic>;
            final categories = items
                .map((item) => Category.fromJson(item as Map<String, dynamic>))
                .toList();

            // Extract pagination info
            final paginationInfo = PaginationInfo.fromJson({
              'pageNumber': data['pageNumber'] as int? ?? 1,
              'pageSize': data['pageSize'] as int? ?? items.length,
              'totalPages': data['totalPages'] as int? ?? 1,
              'totalCount': data['totalCount'] as int? ?? items.length,
              'hasNextPage': data['hasNextPage'] as bool? ?? false,
            });

            return APIResponse.success({
              'categories': categories,
              'pagination': paginationInfo,
            });
          }

          return const APIResponse.error(
            AppException.errorWithMessage('Invalid response format'),
          );
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
