// lib/shared/model/pagination_info.dart
class PaginationInfo {
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasNextPage;

  PaginationInfo({
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 0,
      totalPages: json['totalPages'] as int? ?? 1,
      totalCount: json['totalCount'] as int? ?? 0,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
    );
  }
}
