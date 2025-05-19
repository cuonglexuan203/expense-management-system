import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:expense_management_system/feature/category/provider/category_provider.dart';
import 'package:expense_management_system/feature/schedule/model/finance_payload.dart';
import 'package:expense_management_system/feature/schedule/widget/error_field.dart';
import 'package:expense_management_system/feature/schedule/widget/loading_field.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CategorySelector extends ConsumerStatefulWidget {
  final Category? selectedCategory;
  final FinanceEventType financeType;
  final ValueChanged<Category?> onChanged;

  const CategorySelector({
    Key? key,
    this.selectedCategory,
    required this.financeType,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Load more categories when reaching bottom
      final flowType =
          widget.financeType == FinanceEventType.income ? 'Income' : 'Expense';
      ref
          .read(categoryNotifierProvider(flowType).notifier)
          .loadMoreCategories(flowType);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the right category provider based on the finance type
    final flowType =
        widget.financeType == FinanceEventType.income ? 'Income' : 'Expense';
    final categoryState = ref.watch(categoryNotifierProvider(flowType));

    return categoryState.when(
      data: (state) {
        if (state.isLoading && state.categories.isEmpty) {
          return const LoadingField(label: 'Category');
        }

        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Category',
            border: const OutlineInputBorder(),
            prefixIcon: Icon(
              Iconsax.category,
              color: widget.financeType == FinanceEventType.expense
                  ? Colors.redAccent
                  : Colors.green,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              isExpanded: true,
              hint: const Text('Select Category'),
              value: widget.selectedCategory,
              onChanged: widget.onChanged,
              items: [
                ...state.categories
                    .map((category) => DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name),
                        )),
                if (state.isLoading)
                  const DropdownMenuItem<Category>(
                    enabled: false,
                    value: null,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Loading more...'),
                      ],
                    ),
                  ),
              ],
              menuMaxHeight: 300,
            ),
          ),
        );
      },
      loading: () => const LoadingField(label: 'Category'),
      error: (error, stackTrace) =>
          ErrorField(label: 'Category', error: error.toString()),
    );
  }
}
