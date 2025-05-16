import 'dart:convert';

import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:expense_management_system/feature/category/model/category.dart';
import 'package:expense_management_system/feature/category/provider/category_provider.dart';
import 'package:expense_management_system/feature/home/provider/home_provider.dart';
import 'package:expense_management_system/feature/schedule/model/event.dart';
import 'package:expense_management_system/feature/schedule/model/event_rule.dart';
import 'package:expense_management_system/feature/schedule/model/finance_payload.dart';
import 'package:expense_management_system/feature/schedule/provider/event_provider.dart';
import 'package:expense_management_system/feature/schedule/widget/category_selector.dart';
import 'package:expense_management_system/feature/schedule/widget/recurrence_rule_selector.dart';
import 'package:expense_management_system/feature/schedule/widget/wallet_selector.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EditFinanceEventDialog extends ConsumerStatefulWidget {
  final Event event;

  const EditFinanceEventDialog({
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<EditFinanceEventDialog> createState() =>
      _EditFinanceEventDialogState();
}

class _EditFinanceEventDialogState
    extends ConsumerState<EditFinanceEventDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late FinanceEventType _financeType;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late EventRule _eventRule;

  // IDs for initialization
  dynamic _walletId;
  dynamic _categoryId;
  Wallet? _selectedWallet;
  Category? _selectedCategory;

  bool _isLoading = false;
  bool _initialized = false;
  int _retryCount = 0;
  final int _maxRetries = 10;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController =
        TextEditingController(text: widget.event.description ?? '');

    // Initialize date and time
    final localDateTime = widget.event.initialTriggerDateTime.toLocal();
    _selectedDate =
        DateTime(localDateTime.year, localDateTime.month, localDateTime.day);
    _selectedTime =
        TimeOfDay(hour: localDateTime.hour, minute: localDateTime.minute);

    // Initialize Finance specific details
    final financePayload = widget.event.financePayload;
    if (financePayload != null) {
      print(
          "DEBUG: Finance payload found: ${jsonEncode(financePayload.toJson())}");
      _financeType = financePayload.type;
      _amountController =
          TextEditingController(text: financePayload.amount.toString());
      _walletId = financePayload.walletId;
      _categoryId = financePayload.categoryId;
      print(
          "DEBUG: Extracted wallet ID: $_walletId, category ID: $_categoryId");
    } else {
      print("DEBUG: No finance payload found");
      _financeType = FinanceEventType.expense;
      _amountController = TextEditingController();
    }

    // Initialize recurrence rule
    _eventRule =
        widget.event.rule ?? const EventRule(frequency: EventFrequency.once);

    // Delayed initialization to ensure providers are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSelectionsWithRetry();
    });
  }

  void _initializeSelectionsWithRetry() {
    if (_initialized || _retryCount >= _maxRetries) return;

    _retryCount++;
    print("DEBUG: Attempt $_retryCount to initialize selections");

    // Load wallet and category data
    _initializeWalletAndCategory();

    // Schedule next retry if not found
    if (_selectedWallet == null || _selectedCategory == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        _initializeSelectionsWithRetry();
      });
    }
  }

  void _initializeWalletAndCategory() {
    // 1. Try to find matching wallet
    final homeState = ref.read(homeNotifierProvider);
    homeState.maybeWhen(
      loaded: (wallets, _) {
        print("DEBUG: Found ${wallets.length} wallets");
        // DIRECT MANUAL LOOKUP - Guaranteed to find the wallet if it exists
        for (final wallet in wallets) {
          print(
              "DEBUG: Checking wallet: ${wallet.id} (${wallet.id.runtimeType}) - ${wallet.name}");

          // Try both direct equals and string comparison
          final idMatch = wallet.id.toString() == _walletId.toString();

          if (idMatch || wallet.id == _walletId) {
            setState(() {
              _selectedWallet = wallet;
              print("DEBUG: ✅ MATCHED wallet: ${wallet.name}");
            });
            break;
          }
        }

        // If we have exact IDs to match, force a match
        // if (_walletId == 2 && _selectedWallet == null) {
        //   final exactWallet = wallets.firstWhere(
        //     (w) => w.id == 2 || w.id.toString() == "2",
        //     orElse: () => wallets.isNotEmpty ? wallets.first : null,
        //   );

        //   if (exactWallet != null) {
        //     setState(() {
        //       _selectedWallet = exactWallet;
        //       print("DEBUG: 🔄 Force matched wallet with ID 2: ${exactWallet.name}");
        //     });
        //   }
        // }
      },
      orElse: () {},
    );

    // 2. Try to find matching category
    final flowType =
        _financeType == FinanceEventType.income ? 'Income' : 'Expense';
    final categoryState = ref.read(categoryNotifierProvider(flowType));

    categoryState.whenOrNull(
      data: (state) {
        final categories = state.categories;
        print("DEBUG: Found ${categories.length} categories");

        // DIRECT MANUAL LOOKUP - Guaranteed to find the category if it exists
        for (final category in categories) {
          print(
              "DEBUG: Checking category: ${category.id} (${category.id.runtimeType}) - ${category.name}");

          // Try both direct equals and string comparison
          final idMatch = category.id.toString() == _categoryId.toString();

          if (idMatch || category.id == _categoryId) {
            setState(() {
              _selectedCategory = category;
              print("DEBUG: ✅ MATCHED category: ${category.name}");
            });
            break;
          }
        }

        // // If we have exact IDs to match, force a match
        // if (_categoryId == 47 && _selectedCategory == null) {
        //   final exactCategory = categories.firstWhere(
        //     (c) => c.id == 47 || c.id.toString() == "47",
        //     orElse: () => categories.isNotEmpty ? categories.first : null,
        //   );

        //   if (exactCategory != null) {
        //     setState(() {
        //       _selectedCategory = exactCategory;
        //       print("DEBUG: 🔄 Force matched category with ID 47: ${exactCategory.name}");
        //     });
        //   }
        // }

        // Mark as initialized if we found both or max retries reached
        if ((_selectedWallet != null && _selectedCategory != null) ||
            _retryCount >= _maxRetries) {
          setState(() {
            _initialized = true;
            print(
                "DEBUG: ✓ Initialization complete after $_retryCount attempts");
            print("DEBUG: Selected wallet: ${_selectedWallet?.name}");
            print("DEBUG: Selected category: ${_selectedCategory?.name}");
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Force reload categories when finance type changes
    final flowType =
        _financeType == FinanceEventType.income ? 'Income' : 'Expense';
    ref
        .read(categoryNotifierProvider(flowType).notifier)
        .loadMoreCategories(flowType);

    // Try to initialize selections again if needed
    if (!_initialized) {
      _initializeWalletAndCategory();
    }
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      // Validate required fields individually for better error messages
      if (_nameController.text.trim().isEmpty) {
        AppSnackBar.showError(
            context: context, message: 'Event name is required');
        return;
      }

      final amount = double.tryParse(_amountController.text);
      if (amount == null) {
        AppSnackBar.showError(
            context: context, message: 'Please enter a valid amount');
        return;
      }

      if (_selectedWallet == null) {
        AppSnackBar.showError(
            context: context, message: 'Please select a wallet');
        return;
      }

      if (_selectedCategory == null) {
        AppSnackBar.showError(
            context: context, message: 'Please select a category');
        return;
      }

      setState(() => _isLoading = true);

      final name = _nameController.text;
      final description = _descriptionController.text;

      // Prepare date time
      final localDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      final initialTriggerDateTime = localDateTime.toUtc();

      // Create finance payload
      final financePayload = FinancePayload(
        type: _financeType,
        amount: amount,
        walletId: _selectedWallet!.id!,
        categoryId: _selectedCategory!.id!,
      );

      // Create updated event
      final updatedEvent = Event(
        id: widget.event.id,
        scheduledEventId: widget.event.scheduledEventId,
        name: name,
        description: description.isNotEmpty ? description : null,
        type: EventType.finance,
        payload: jsonEncode(financePayload.toJson()),
        initialTriggerDateTime: initialTriggerDateTime,
        rule: _eventRule,
        createdAt: widget.event.createdAt,
      );

      // Save to API
      final success =
          await ref.read(eventProvider.notifier).updateEvent(updatedEvent);

      setState(() => _isLoading = false);

      if (success && mounted) {
        Navigator.of(context).pop();
        AppSnackBar.showSuccess(
          context: context,
          message: 'Finance event updated successfully!',
        );
      } else if (!success && mounted) {
        AppSnackBar.showError(
          context: context,
          message:
              'Failed to update event: ${ref.read(eventProvider).error ?? "Unknown error"}',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Edit Finance Event',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check),
                onPressed: _isLoading ? null : _saveEvent,
              ),
            ],
          ),
        ),
        const Divider(),

        // Form Body
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Event Name',
                      prefixIcon: Icon(Iconsax.edit),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name is required'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      prefixIcon: Icon(Iconsax.note_text),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  // Finance type selector
                  SegmentedButton<FinanceEventType>(
                    segments: const [
                      ButtonSegment(
                          value: FinanceEventType.expense,
                          label: Text('Expense'),
                          icon: Icon(Icons.arrow_downward_rounded,
                              color: Colors.redAccent)),
                      ButtonSegment(
                          value: FinanceEventType.income,
                          label: Text('Income'),
                          icon: Icon(Icons.arrow_upward_rounded,
                              color: Colors.green)),
                    ],
                    selected: {_financeType},
                    onSelectionChanged: (newSelection) {
                      setState(() {
                        _financeType = newSelection.first;
                        _selectedCategory =
                            null; // Reset category on type change
                      });
                    },
                    style: SegmentedButton.styleFrom(
                      selectedForegroundColor:
                          _financeType == FinanceEventType.expense
                              ? Colors.redAccent
                              : Colors.green,
                      selectedBackgroundColor:
                          _financeType == FinanceEventType.expense
                              ? Colors.redAccent.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Amount field
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.monetization_on_outlined,
                          color: _financeType == FinanceEventType.expense
                              ? Colors.redAccent
                              : Colors.green),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid amount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Wallet selector
                  WalletSelector(
                    selectedWallet: _selectedWallet,
                    onChanged: (wallet) =>
                        setState(() => _selectedWallet = wallet),
                  ),
                  const SizedBox(height: 12),

                  // Category selector
                  CategorySelector(
                    selectedCategory: _selectedCategory,
                    financeType: _financeType,
                    onChanged: (category) =>
                        setState(() => _selectedCategory = category),
                  ),
                  const SizedBox(height: 12),

                  // Date time picker
                  _buildDateTimePicker(context),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Recurrence rule selector
                  RecurrenceRuleSelector(
                    value: _eventRule,
                    onChanged: (rule) {
                      setState(() => _eventRule = rule);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: theme.colorScheme.primary,
                        onPrimary: theme.colorScheme.onPrimary,
                        surface: theme.colorScheme.surface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                setState(() => _selectedDate = pickedDate);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('MMM d, yyyy').format(_selectedDate),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: theme.colorScheme.primary,
                        onPrimary: theme.colorScheme.onPrimary,
                        surface: theme.colorScheme.surface,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedTime != null) {
                setState(() => _selectedTime = pickedTime);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _selectedTime.format(context),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
