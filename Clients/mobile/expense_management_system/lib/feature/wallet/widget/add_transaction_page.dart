import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/gen/colors.gen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:extended_text_field/extended_text_field.dart';

class AddTransactionPage extends StatefulWidget {
  final bool isExpense;
  const AddTransactionPage({super.key, required this.isExpense});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;

  final List<String> _expenseCategories = [
    'Shopping',
    'Food',
    'Transport',
    'Entertainment',
    'Bills',
    'Others'
  ];

  final List<String> _incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Others'
  ];

  void _showAddCategoryDialog() {
    final _categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add ${widget.isExpense ? 'Expense' : 'Income'} Category',
          style: const TextStyle(
            fontFamily: 'Nunito',
            fontSize: 18,
          ),
        ),
        content: TextField(
          controller: _categoryController,
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
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Nunito',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_categoryController.text.isNotEmpty) {
                setState(() {
                  if (widget.isExpense) {
                    _expenseCategories.add(_categoryController.text);
                  } else {
                    _incomeCategories.add(_categoryController.text);
                  }
                });
                Navigator.pop(context);
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
              style: TextStyle(fontFamily: 'Nunito'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        widget.isExpense ? _expenseCategories : _incomeCategories;

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
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Category',
                      hintText: 'Select category',
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Nunito',
                    ),
                    items: categories.map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Nunito',
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    },
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
                    'Add Category',
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
                onPressed: () {
                  // Handle save transaction
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorName.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
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
