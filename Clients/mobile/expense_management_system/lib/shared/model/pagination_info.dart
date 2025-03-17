class PaginationInfo {
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationInfo({
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  // Add copyWith method to support immutable updates
  PaginationInfo copyWith({
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    int? totalCount,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginationInfo(
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    try {
      return PaginationInfo(
        pageNumber: _parseInt(json['pageNumber'], defaultValue: 1),
        pageSize: _parseInt(json['pageSize'], defaultValue: 10),
        totalPages: _parseInt(json['totalPages'], defaultValue: 1),
        totalCount: _parseInt(json['totalCount'], defaultValue: 0),
        hasNextPage: _parseBool(json['hasNextPage'], defaultValue: false),
        hasPreviousPage:
            _parseBool(json['hasPreviousPage'], defaultValue: false),
      );
    } catch (e) {
      return PaginationInfo(
        pageNumber: 1,
        pageSize: 10,
        totalPages: 1,
        totalCount: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      );
    }
  }

  static int _parseInt(dynamic value, {required int defaultValue}) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static bool _parseBool(dynamic value, {required bool defaultValue}) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == "true";
    return defaultValue;
  }
}
