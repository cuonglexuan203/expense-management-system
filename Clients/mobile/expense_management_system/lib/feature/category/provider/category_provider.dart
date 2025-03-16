// lib/feature/category/provider/category_provider.dart
import 'package:flutter_boilerplate/feature/category/model/category.dart';
import 'package:flutter_boilerplate/feature/category/repository/category_repository.dart';
import 'package:flutter_boilerplate/shared/model/pagination_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

class CategoryState {
  final List<Category> categories;
  final PaginationInfo pagination;
  final bool isLoading;

  CategoryState({
    required this.categories,
    required this.pagination,
    this.isLoading = false,
  });

  CategoryState copyWith({
    List<Category>? categories,
    PaginationInfo? pagination,
    bool? isLoading,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  late final CategoryRepository _repository =
      ref.read(categoryRepositoryProvider);

  @override
  Future<CategoryState> build(String flowType) async {
    // Initial empty state
    final initialState = CategoryState(
      categories: [],
      pagination: PaginationInfo(
        pageNumber: 0,
        pageSize: 10,
        totalPages: 1,
        totalCount: 0,
        hasNextPage: true,
      ),
      isLoading: true,
    );

    // Load first page
    return _loadCategories(flowType);
  }

  Future<CategoryState> _loadCategories(String flowType, {int? page}) async {
    final currentValue = state.valueOrNull;
    final currentState = currentValue ??
        CategoryState(
          categories: [],
          pagination: PaginationInfo(
            pageNumber: 0,
            pageSize: 10,
            totalPages: 1,
            totalCount: 0,
            hasNextPage: true,
          ),
        );

    final pageNumber = page ?? 1;

    if (pageNumber > 1) {
      // Mark as loading for subsequent pages
      state = AsyncData(currentState.copyWith(isLoading: true));
    }

    final response = await _repository.getCategories(
      flowType,
      pageNumber: pageNumber,
      pageSize: 10,
    );

    return response.when(
      success: (data) {
        final newCategories = (data['categories'] as List<dynamic>)
            .map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList();
        final pagination = data['pagination'] as PaginationInfo;

        if (pageNumber == 1) {
          // First page - replace existing data
          return CategoryState(
            categories: newCategories,
            pagination: pagination,
            isLoading: false,
          );
        } else {
          // Append to existing data
          return CategoryState(
            categories: [...currentState.categories, ...newCategories],
            pagination: pagination,
            isLoading: false,
          );
        }
      },
      error: (error) {
        return currentState.copyWith(isLoading: false);
      },
    );
  }

  Future<void> loadMoreCategories(String flowType) async {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.isLoading) return;

    if (currentState.pagination.hasNextPage) {
      final nextPage = currentState.pagination.pageNumber + 1;
      final result = await _loadCategories(flowType, page: nextPage);

      if (result.categories.isEmpty) {
        state = AsyncData(currentState.copyWith(
            pagination: result.pagination, isLoading: false));
      } else {
        state = AsyncData(result);
      }
    }
  }

  Future<Category?> createCategory(String name, String flowType) async {
    final response = await _repository.createCategory(name, flowType);

    return response.when(
      success: (category) {
        if (category != null) {
          final currentState = state.valueOrNull;
          if (currentState != null) {
            final updatedState = currentState.copyWith(
              categories: [category, ...currentState.categories],
            );
            state = AsyncData(updatedState);
          }
        }
        return category;
      },
      error: (error) {
        print("Error creating category: $error");
        return null;
      },
    );
  }
}
