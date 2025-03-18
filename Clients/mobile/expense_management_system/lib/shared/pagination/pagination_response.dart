// Class trả về kết quả phân trang
import 'package:expense_management_system/shared/model/pagination_info.dart';

class PaginatedResponse<T> {
  final List<T> items;
  final PaginationInfo paginationInfo;

  PaginatedResponse({
    required this.items,
    required this.paginationInfo,
  });
}
