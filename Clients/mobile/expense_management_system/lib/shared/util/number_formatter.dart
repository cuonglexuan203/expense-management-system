// lib/shared/formatter/number_formatter.dart
import 'package:flutter/services.dart';

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String value = newValue.text.replaceAll(',', '');

    if (!RegExp(r'^(\d+\.?\d*|\.\d+)$').hasMatch(value)) {
      return oldValue;
    }

    List<String> parts = value.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    String formattedIntegerPart = '';
    int count = 0;

    for (int i = integerPart.length - 1; i >= 0; i--) {
      count++;
      formattedIntegerPart = integerPart[i] + formattedIntegerPart;
      if (count % 3 == 0 && i > 0) {
        formattedIntegerPart = ',' + formattedIntegerPart;
      }
    }

    final String formattedText = formattedIntegerPart + decimalPart;

    int selectionIndex = formattedText.length;
    if (newValue.selection.baseOffset > 0) {
      int commasBeforeCursor =
          ','.allMatches(formattedText.substring(0, selectionIndex)).length;

      int oldCommasBeforeCursor = ','
          .allMatches(oldValue.text.substring(0, oldValue.selection.baseOffset))
          .length;

      selectionIndex = newValue.selection.baseOffset +
          commasBeforeCursor -
          oldCommasBeforeCursor;

      if (selectionIndex > formattedText.length) {
        selectionIndex = formattedText.length;
      }
      if (selectionIndex < 0) {
        selectionIndex = 0;
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
