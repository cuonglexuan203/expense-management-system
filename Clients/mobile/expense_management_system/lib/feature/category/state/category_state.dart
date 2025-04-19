import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:expense_management_system/shared/pagination/pagination_info.dart';

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
