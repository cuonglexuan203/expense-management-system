import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:expense_management_system/feature/category/repository/category_repository.dart';
import 'package:expense_management_system/feature/category/state/category_state.dart';
import 'package:expense_management_system/shared/pagination/pagination_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

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
        final categories = data['categories'] as List<Category>;
        final pagination = data['pagination'] as PaginationInfo;

        if (pageNumber == 1) {
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
        return null;
      },
    );
  }

  Future<bool> updateCategory(int id, String name) async {
    try {
      // Send update request to API
      final response = await _repository.updateCategory(id, name);
      // Get current state
      final currentState = state.valueOrNull;
      if (currentState == null) return false;

      // Create a new list with the updated category name
      final updatedCategories = currentState.categories.map((category) {
        if (category.id == id) {
          return category.copyWith(name: name);
        }
        return category;
      }).toList();

      // Update state
      state = AsyncData(currentState.copyWith(
        categories: updatedCategories,
      ));

      return true;
    } catch (e) {
      // Log error
      print("Error updating category: $e");
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      final response = await _repository.deleteCategory(id);

      return response.when(
        success: (_) {
          final currentState = state.valueOrNull;
          if (currentState != null) {
            // Update state by removing the deleted category
            final updatedCategories = currentState.categories
                .where((category) => category.id != id)
                .toList();

            state = AsyncData(currentState.copyWith(
              categories: updatedCategories,
              pagination: currentState.pagination.copyWith(
                totalCount: currentState.pagination.totalCount - 1,
              ),
            ));
          }
          return true;
        },
        error: (error) {
          // Return the specific error message
          return false;
        },
      );
    } catch (e) {
      return false;
    }
  }
}
