import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingField extends StatelessWidget {
  final String label;

  const LoadingField({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 10),
          Text('Loading...'),
        ],
      ),
    );
  }
}
