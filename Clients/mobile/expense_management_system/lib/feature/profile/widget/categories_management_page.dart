import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:expense_management_system/feature/category/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CategoriesManagementPage extends ConsumerStatefulWidget {
  const CategoriesManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesManagementPage> createState() =>
      _CategoriesManagementPageState();
}

class _CategoriesManagementPageState
    extends ConsumerState<CategoriesManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _editCategoryController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Clear search when tab changes
      setState(() {
        _searchQuery = '';
        _searchController.clear();
      });
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 120 && !_showTitle) {
      setState(() {
        _showTitle = true;
      });
    } else if (_scrollController.offset <= 120 && _showTitle) {
      setState(() {
        _showTitle = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _newCategoryController.dispose();
    _editCategoryController.dispose();
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 220.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF4B7BF9),
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFB7C5E1),
                          Color(0xFF4B7BF9),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Categories',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          // Search Field
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(fontFamily: 'Nunito'),
                                decoration: InputDecoration(
                                  hintText: 'Search categories...',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: Colors.grey[500],
                                  ),
                                  suffixIcon: _searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          color: Colors.grey[400],
                                          onPressed: () {
                                            setState(() {
                                              _searchController.clear();
                                              _searchQuery = '';
                                            });
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          labelColor: const Color(0xFF386BF6),
                          unselectedLabelColor: Colors.grey[600],
                          labelStyle: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_downward_rounded,
                                    color: _tabController.index == 0
                                        ? Colors.green
                                        : Colors.grey[600],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('Income'),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_upward_rounded,
                                    color: _tabController.index == 1
                                        ? Colors.red
                                        : Colors.grey[600],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text('Expense'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ];
          },
          body: Container(
            color: Colors.white,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryList('Income'),
                _buildCategoryList('Expense'),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddCategoryDialog(
              context, _tabController.index == 0 ? 'Income' : 'Expense'),
          backgroundColor: const Color(0xFF386BF6),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Add Category',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(String flowType) {
    return Consumer(
      builder: (context, ref, child) {
        final categoryAsyncValue =
            ref.watch(categoryNotifierProvider(flowType));

        return categoryAsyncValue.when(
          data: (categoryState) {
            // Filter categories based on search query
            final categories = _searchQuery.isEmpty
                ? categoryState.categories
                : categoryState.categories
                    .where((c) => c.name.toLowerCase().contains(_searchQuery))
                    .toList();

            if (categories.isEmpty && _searchQuery.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.search_normal_1,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No categories match "$_searchQuery"',
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (categories.isEmpty && _searchQuery.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.category,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No categories yet',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ElevatedButton.icon(
                    //   onPressed: () =>
                    //       _showAddCategoryDialog(context, flowType),
                    //   icon: const Icon(Icons.add),
                    //   label: const Text(
                    //     'Add Category',
                    //     style: TextStyle(fontFamily: 'Nunito'),
                    //   ),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: const Color(0xFF386BF6),
                    //     foregroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length + (categoryState.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= categories.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final category = categories[index];
                return _buildCategoryItem(category, flowType, index);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading categories: $error',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.refresh(categoryNotifierProvider(flowType));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF386BF6),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(fontFamily: 'Nunito'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(Category category, String flowType, int index) {
    final bool isIncome = flowType == 'Income';

    return Hero(
      tag: 'category-${category.id}',
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => _showEditCategoryDialog(
              context,
              category,
              flowType,
            ),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Category icon with gradient (keep existing code)
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isIncome
                            ? [Colors.green[300]!, Colors.green[600]!]
                            : [Colors.red[300]!, Colors.red[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isIncome ? Colors.green[300]! : Colors.red[300]!)
                                  .withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Category name and badges
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        if (category.isDefault)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Action buttons - both edit and delete
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F9FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Iconsax.edit,
                            size: 18,
                            color: Color(0xFF386BF6),
                          ),
                          onPressed: () => _showEditCategoryDialog(
                            context,
                            category,
                            flowType,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Only show delete button for non-default categories
                      if (!category.isDefault)
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Iconsax.trash,
                              size: 18,
                              color: Colors.red.shade600,
                            ),
                            onPressed: () => _showDeleteConfirmationDialog(
                              context,
                              category,
                              flowType,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(
      BuildContext context, String flowType) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Add $flowType Category',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _newCategoryController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Category name',
            hintStyle: const TextStyle(fontFamily: 'Nunito'),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(fontFamily: 'Nunito'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _newCategoryController.clear();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF386BF6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final categoryName = _newCategoryController.text.trim();
              if (categoryName.isNotEmpty) {
                final category = await ref
                    .read(categoryNotifierProvider(flowType).notifier)
                    .createCategory(categoryName, flowType);

                if (!context.mounted) return;

                Navigator.of(context).pop();
                _newCategoryController.clear();

                if (category != null) {
                  AppSnackBar.showSuccess(
                    context: context,
                    message: 'Category created successfully',
                  );

                  // Manually refresh to ensure UI updates
                  ref.invalidate(categoryNotifierProvider(flowType));
                } else {
                  AppSnackBar.showError(
                    context: context,
                    message: 'Failed to create category',
                  );
                }
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(fontFamily: 'Nunito'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditCategoryDialog(
      BuildContext context, Category category, String flowType) async {
    _editCategoryController.text = category.name;

    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(
              Iconsax.edit,
              color: Color(0xFF386BF6),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Edit Category',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (category.isDefault)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a default category. You can rename it but not delete it.',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            TextField(
              controller: _editCategoryController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Category name',
                labelStyle: const TextStyle(fontFamily: 'Nunito'),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              style: const TextStyle(fontFamily: 'Nunito'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _editCategoryController.clear();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey,
              ),
            ),
          ),
          StatefulBuilder(
            builder: (stateContext, setState) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF386BF6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final newName = _editCategoryController.text.trim();

                  if (newName.isNotEmpty && newName != category.name) {
                    // Update button state to show loading
                    setState(() {
                      // This will trigger a rebuild of just this button
                    });

                    // Close the edit dialog
                    Navigator.of(dialogContext).pop();

                    // Show a loading overlay that we can easily dismiss
                    BuildContext? loadingContext;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) {
                        loadingContext = ctx;
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: const Center(
                            child: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text(
                                      "Updating category...",
                                      style: TextStyle(fontFamily: 'Nunito'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );

                    // Update the category
                    final success = await ref
                        .read(categoryNotifierProvider(flowType).notifier)
                        .updateCategory(category.id, newName);

                    // Clear text controller
                    _editCategoryController.clear();

                    // Ensure loading context is still valid
                    if (loadingContext != null && context.mounted) {
                      // Explicitly pop using the loading dialog's context
                      Navigator.of(loadingContext!).pop();

                      // Show status message
                      if (success) {
                        AppSnackBar.showSuccess(
                          context: context,
                          message: 'Category updated successfully',
                        );

                        // Refresh the category list
                        ref.invalidate(categoryNotifierProvider(flowType));
                      } else {
                        AppSnackBar.showError(
                          context: context,
                          message: 'Failed to update category',
                        );
                      }
                    }
                  } else {
                    Navigator.of(dialogContext).pop();
                    _editCategoryController.clear();
                  }
                },
                child: const Text(
                  'Update',
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Category category, String flowType) async {
    return showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Iconsax.trash,
              color: Colors.red.shade600,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Delete ${category.name}?',
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this category? This action cannot be undone.',
              style: const TextStyle(
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.amber.shade800,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If this category has any transactions, you will not be able to delete it.',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Nunito',
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.of(dialogContext).pop();

              // Show loading indicator
              BuildContext? loadingContext;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  loadingContext = ctx;
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: const Center(
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                "Deleting category...",
                                style: TextStyle(fontFamily: 'Nunito'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );

              // Try to delete the category
              final result = await ref
                  .read(categoryNotifierProvider(flowType).notifier)
                  .deleteCategory(category.id);

              // Ensure loading context is still valid
              if (loadingContext != null && context.mounted) {
                // Dismiss loading dialog
                Navigator.of(loadingContext!).pop();

                if (result) {
                  AppSnackBar.showSuccess(
                    context: context,
                    message: 'Category deleted successfully',
                  );
                  // Refresh the category list
                  ref.invalidate(categoryNotifierProvider(flowType));
                } else {
                  AppSnackBar.showError(
                    context: context,
                    message: 'Failed to delete category',
                  );
                }
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(fontFamily: 'Nunito'),
            ),
          ),
        ],
      ),
    );
  }
}
