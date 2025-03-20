import 'package:flutter/material.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:iconsax/iconsax.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Salary'; // Default category

  final List<String> _categories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Add Income',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.calendar, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _categories.map((String category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle save income
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorName.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Income',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
