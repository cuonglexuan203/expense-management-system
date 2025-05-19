import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorField extends StatelessWidget {
  final String label;
  final String error;

  const ErrorField({required this.label, required this.error, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText: 'Error loading data',
      ),
      child: Text(
        error,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
