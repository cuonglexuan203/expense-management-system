// lib/shared/models/paginated_state.dart
import 'package:expense_management_system/shared/pagination/pagination_info.dart';

class PaginatedState<T> {
  final List<T> items;
  final bool isLoading;
  final bool hasReachedEnd;
  final PaginationInfo paginationInfo;
  final String? errorMessage;

  PaginatedState({
    required this.items,
    required this.isLoading,
    required this.hasReachedEnd,
    required this.paginationInfo,
    this.errorMessage,
  });

  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasReachedEnd,
    PaginationInfo? paginationInfo,
    String? errorMessage,
  }) {
    return PaginatedState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      paginationInfo: paginationInfo ?? this.paginationInfo,
      errorMessage: errorMessage,
    );
  }

  static PaginatedState<T> initial<T>() {
    return PaginatedState(
      items: [],
      isLoading: false,
      hasReachedEnd: false,
      paginationInfo: PaginationInfo(
        pageNumber: 1,
        pageSize: 10,
        totalPages: 1,
        totalCount: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );
  }
}
