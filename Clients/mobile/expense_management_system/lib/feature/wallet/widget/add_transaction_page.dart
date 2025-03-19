import 'dart:convert';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:expense_management_system/feature/category/provider/category_provider.dart';
import 'package:expense_management_system/feature/transaction/provider/transaction_provider.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/constants/api_endpoints.dart';
import 'package:expense_management_system/shared/http/api_provider.dart';
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

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _selectedCategoryName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);

      // Use the transaction provider instead of direct API calls
      final transaction = await ref
          .read(transactionNotifierProvider.notifier)
          .createTransaction(
            name: _titleController.text,
            walletId: widget.walletId,
            categoryId: _selectedCategoryId!,
            amount: amount,
            isExpense: widget.isExpense,
            occurredAt: _selectedDate,
          );

      setState(() {
        _isLoading = false;
      });

      if (transaction != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add transaction')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showAddCategoryDialog() {
    FocusScope.of(context).unfocus();

    final categoryController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontFamily: 'Nunito'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (categoryController.text.isEmpty) return;

              // Get the category name before closing dialog
              final categoryName = categoryController.text;

              // Close the category name dialog
              Navigator.pop(dialogContext);

              // Now show a separate loading dialog
              BuildContext? loadingDialogContext;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  loadingDialogContext = ctx;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );

              // Create the category
              ref
                  .read(categoryNotifierProvider(_flowType).notifier)
                  .createCategory(categoryName, _flowType)
                  .then((category) {
                // Always close the loading dialog first
                if (loadingDialogContext != null &&
                    Navigator.canPop(loadingDialogContext!)) {
                  Navigator.pop(loadingDialogContext!);
                }

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
              }).catchError((e) {
                // Always close the loading dialog on error
                if (loadingDialogContext != null &&
                    Navigator.canPop(loadingDialogContext!)) {
                  Navigator.pop(loadingDialogContext!);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              });
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
    // Rest of the widget build method remains the same
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

// FIXED: Category Selector Dialog that properly handles the Category object
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

    try {
      await ref
          .read(categoryNotifierProvider(widget.flowType).notifier)
          .loadMoreCategories(widget.flowType);
    } catch (e) {
      print("Error loading more categories: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
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
                        child: Icon(
                          Iconsax.category,
                          color: isSelected ? ColorName.blue : Colors.grey,
                        ),
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
