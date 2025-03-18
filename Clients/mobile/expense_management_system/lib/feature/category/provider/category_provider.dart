// lib/feature/category/provider/category_provider.dart
import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:expense_management_system/feature/category/repository/category_repository.dart';
import 'package:expense_management_system/shared/model/pagination_info.dart';
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
    // Initial empty state with properly initialized PaginationInfo
    final initialState = CategoryState(
      categories: [],
      pagination: PaginationInfo(
        pageNumber: 0,
        pageSize: 10,
        totalPages: 1,
        totalCount: 0,
        hasNextPage: true,
        hasPreviousPage: false,
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
            hasPreviousPage: false,
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
        // FIX: Don't try to convert Category objects again
        final categories = data['categories'] as List<Category>;
        final pagination = data['pagination'] as PaginationInfo;

        if (pageNumber == 1) {
          // First page - replace existing data
          return CategoryState(
            categories: categories,
            pagination: pagination,
            isLoading: false,
          );
        } else {
          // Append to existing data
          return CategoryState(
            categories: [...currentState.categories, ...categories],
            pagination: pagination,
            isLoading: false,
          );
        }
      },
      error: (error) {
        print("Error loading categories: ${error}");
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

      // Update state with new results
      state = AsyncData(result);
    }
  }

  Future<Category?> createCategory(String name, String flowType) async {
    final response = await _repository.createCategory(name, flowType);

    return response.when(
      success: (category) {
        if (category != null) {
          final currentState = state.valueOrNull;
          if (currentState != null) {
            // Calculate new totalCount for pagination
            final newTotalCount = currentState.pagination.totalCount + 1;

            // Update pagination with increased count
            final updatedPagination = currentState.pagination.copyWith(
              totalCount: newTotalCount,
              // Recalculate total pages if needed
              totalPages:
                  (newTotalCount / currentState.pagination.pageSize).ceil(),
            );

            // Add new category to the beginning of the list
            final updatedState = currentState.copyWith(
              categories: [category, ...currentState.categories],
              pagination: updatedPagination,
            );

            state = AsyncData(updatedState);
          }
        }
        return category;
      },
      error: (error) {
        // Consider using a proper logging mechanism
        print("Error creating category: $error");
        return null;
      },
    );
  }
}
