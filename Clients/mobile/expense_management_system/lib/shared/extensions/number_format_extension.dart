import 'package:intl/intl.dart';

extension NumberFormatting on num {
  String toFormattedString({int decimalPlaces = 0}) {
    final formatter = NumberFormat(
        '#,##0${decimalPlaces > 0 ? '.' + '0' * decimalPlaces : ''}');
    return formatter.format(this);
  }

  String toCurrencyString({String symbol = '\$', int decimalPlaces = 2}) {
    final formatter = NumberFormat(
        '$symbol#,##0${decimalPlaces > 0 ? '.' + '0' * decimalPlaces : ''}');
    return formatter.format(this);
  }
}
