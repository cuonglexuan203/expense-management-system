// lib/feature/onboarding/widget/categories_step.dart
import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_management_system/feature/onboarding/provider/onboarding_provider.dart';

class CategoriesStep extends ConsumerWidget {
  const CategoriesStep({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingNotifierProvider);
    final categories = onboardingState.categories;
    final selectedIds = onboardingState.selectedCategoryIds;

    // Separate expense and income categories
    final expenseCategories =
        categories.where((c) => c.financialFlowType == 'Expense').toList();

    final incomeCategories =
        categories.where((c) => c.financialFlowType == 'Income').toList();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero icon
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.category,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            // Instructions card
            Card(
              elevation: 0,
              color: Colors.blue.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select the categories you want to track',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You can customize these later in settings',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Selection counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${selectedIds.length} categories selected',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Expense Categories Section
            _buildCategorySection(
              context,
              'Expense Categories',
              'Track your spending across different areas',
              expenseCategories,
              selectedIds,
              ref,
              Colors.red.shade50,
              Colors.red.shade700,
            ),

            const SizedBox(height: 24),

            // Income Categories Section
            _buildCategorySection(
              context,
              'Income Categories',
              'Monitor different sources of income',
              incomeCategories,
              selectedIds,
              ref,
              Colors.green.shade50,
              Colors.green.shade700,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    String subtitle,
    List<Category> categories,
    List<int> selectedIds,
    WidgetRef ref,
    Color baseColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              title.contains('Expense')
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 18,
              color: textColor,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        _buildCategoryGrid(
            context, categories, selectedIds, ref, baseColor, textColor),
      ],
    );
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    List<Category> categories,
    List<int> selectedIds,
    WidgetRef ref,
    Color baseColor,
    Color textColor,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedIds.contains(category.id);

        return GestureDetector(
          onTap: () {
            final updatedIds = List<int>.from(selectedIds);
            if (isSelected) {
              updatedIds.remove(category.id);
            } else {
              updatedIds.add(category.id);
            }
            ref
                .read(onboardingNotifierProvider.notifier)
                .updateSelectedCategories(updatedIds);
            ref.read(onboardingNotifierProvider.notifier).setStepValidity(
                  updatedIds.isNotEmpty,
                );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? baseColor.withOpacity(0.9) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? textColor : Colors.grey.shade300,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: textColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? baseColor.withOpacity(0.5)
                              : baseColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: category.iconUrl != null
                              ? Image.network(
                                  category.iconUrl!,
                                  width: 24,
                                  height: 24,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.category, size: 24),
                                )
                              : const Icon(Icons.category, size: 24),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: textColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
