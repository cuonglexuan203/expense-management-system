import 'dart:convert';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature/category/model/category.dart';
import 'package:flutter_boilerplate/feature/category/provider/category_provider.dart';
import 'package:flutter_boilerplate/gen/colors.gen.dart';
import 'package:flutter_boilerplate/shared/constants/api_endpoints.dart';
import 'package:flutter_boilerplate/shared/http/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({
    required this.isExpense,
    required this.walletId,
    super.key,
  });
  final bool isExpense;
  final int walletId;

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Store both category ID and name
  int? _selectedCategoryId;
  String? _selectedCategoryName;
  bool _isLoading = false;

  String get _flowType => widget.isExpense ? 'Expense' : 'Income';

  @override
  void initState() {
    super.initState();
    // Categories will be automatically loaded by the provider
  }

  Future<void> _saveTransaction() async {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final body = {
        'name': _titleController.text,
        'walletId': widget.walletId,
        'categoryId': _selectedCategoryId,
        'amount': amount,
        'type': widget.isExpense ? 'Expense' : 'Income',
        'occurredAt': _selectedDate.toIso8601String(),
      };

      final response = await ref.read(apiProvider).post(
            ApiEndpoints.transaction.create,
            jsonEncode(body),
          );

      setState(() {
        _isLoading = false;
      });

      response.when(
        success: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction added successfully')),
          );
          Navigator.pop(context, true); // Return true to indicate success
        },
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showAddCategoryDialog() {
    FocusScope.of(context).unfocus(); // Bỏ focus trước khi mở Dialog

    final categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add ${widget.isExpense ? 'Expense' : 'Income'} Category',
          style: const TextStyle(fontFamily: 'Nunito', fontSize: 18),
        ),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(
            labelText: 'Category Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontFamily: 'Nunito'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              print(categoryController.text);
              if (categoryController.text.isNotEmpty) {
                Navigator.pop(
                    context); // Đảm bảo đóng Dialog trước khi mở Loading

                // Show loading indicator
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                print("Before try block");

                try {
                  final category = await ref
                      .read(categoryNotifierProvider(_flowType).notifier)
                      .createCategory(categoryController.text, _flowType);

                  print("Category created: $category");

                  if (context.mounted)
                    Navigator.pop(context); // Đóng loading dialog

                  if (category != null) {
                    setState(() {
                      _selectedCategoryId = category.id;
                      _selectedCategoryName = category.name;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Category added successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to add category')),
                    );
                  }
                } catch (e) {
                  print("Error caught: $e");
                  if (context.mounted) Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorName.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add',
              style: TextStyle(fontFamily: 'Nunito', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showCategorySelectorDialog() {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (context) => _CategorySelectorDialog(
        flowType: _flowType,
        onCategorySelected: (category) {
          setState(() {
            _selectedCategoryId = category.id;
            _selectedCategoryName = category.name;
          });
          Navigator.pop(context);
        },
        selectedCategoryId: _selectedCategoryId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorName.blue),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontFamily: 'Nunito',
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade400,
        fontSize: 14,
        fontFamily: 'Nunito',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorName.blue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isExpense ? 'Add Expense' : 'Add Income',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExtendedTextField(
              controller: _titleController,
              decoration: inputDecoration.copyWith(
                labelText: 'Title',
                hintText: 'Enter title',
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 16),
            ExtendedTextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: inputDecoration.copyWith(
                labelText: 'Amount',
                hintText: 'Enter amount',
                prefixText: '\$ ',
              ),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Date',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.calendar, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Label and Field
            Text(
              'Category',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  // Custom Category Selector
                  child: InkWell(
                    onTap: _showCategorySelectorDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _selectedCategoryId != null
                                ? ColorName.blue
                                : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedCategoryName ?? 'Select category',
                              style: TextStyle(
                                color: _selectedCategoryName != null
                                    ? Colors.black87
                                    : Colors.grey.shade400,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _showAddCategoryDialog,
                  icon: const Icon(
                    Iconsax.add_circle,
                    color: ColorName.blue,
                  ),
                  label: const Text(
                    'Add',
                    style: TextStyle(
                      color: ColorName.blue,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.isExpense ? 'Save Expense' : 'Save Income',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New Category Selector Dialog with infinite scrolling
class _CategorySelectorDialog extends ConsumerStatefulWidget {
  final String flowType;
  final Function(Category) onCategorySelected;
  final int? selectedCategoryId;

  const _CategorySelectorDialog({
    required this.flowType,
    required this.onCategorySelected,
    this.selectedCategoryId,
  });

  @override
  ConsumerState<_CategorySelectorDialog> createState() =>
      _CategorySelectorDialogState();
}

class _CategorySelectorDialogState
    extends ConsumerState<_CategorySelectorDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreCategories();
    }
  }

  Future<void> _loadMoreCategories() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    await ref
        .read(categoryNotifierProvider(widget.flowType).notifier)
        .loadMoreCategories(widget.flowType);

    setState(() {
      _isLoadingMore = false;
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync =
        ref.watch(categoryNotifierProvider(widget.flowType));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
              onChanged: _performSearch,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 400,
            child: categoriesAsync.when(
              data: (categoryState) {
                final categories = categoryState.categories;

                // Filter categories based on search query
                final filteredCategories = _searchQuery.isEmpty
                    ? categories
                    : categories
                        .where((cat) =>
                            cat.name.toLowerCase().contains(_searchQuery))
                        .toList();

                if (filteredCategories.isEmpty) {
                  return const Center(
                    child: Text(
                      'No categories found',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      filteredCategories.length + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Loading indicator at the end
                    if (index == filteredCategories.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final category = filteredCategories[index];
                    final bool isSelected =
                        widget.selectedCategoryId == category.id;

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorName.blue.withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // child: Icon(
                        //   category.iconId != null ? Icons.category : Iconsax.category,
                        //   color: isSelected ? ColorName.blue : Colors.grey,
                        // ),
                      ),
                      title: Text(
                        category.name,
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? ColorName.blue : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: ColorName.blue,
                            )
                          : null,
                      onTap: () => widget.onCategorySelected(category),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${error.toString()}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontFamily: 'Nunito',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref
                          .refresh(categoryNotifierProvider(widget.flowType)),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
