// lib/feature/profile/widget/currency_management_page.dart
import 'package:expense_management_system/feature/profile/provider/currency_provider.dart';
import 'package:expense_management_system/app/widget/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CurrencyManagementPage extends ConsumerStatefulWidget {
  const CurrencyManagementPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CurrencyManagementPage> createState() =>
      _CurrencyManagementPageState();
}

class _CurrencyManagementPageState
    extends ConsumerState<CurrencyManagementPage> {
  String? _selectedCurrency;
  bool _isChangingCurrency = false;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = ref.read(currencyProvider);
  }

  final availableCurrencies = [
    {
      'code': 'USD',
      'name': 'US Dollar',
      'symbol': '\$',
      'flag': '🇺🇸',
      'rate': 1.0
    },
    {
      'code': 'VND',
      'name': 'Vietnamese Dong',
      'symbol': '₫',
      'flag': '🇻🇳',
      'rate': 23000.0
    },
    {
      'code': 'EUR',
      'name': 'Euro',
      'symbol': '€',
      'flag': '🇪🇺',
      'rate': 0.85
    },
    {
      'code': 'GBP',
      'name': 'British Pound',
      'symbol': '£',
      'flag': '🇬🇧',
      'rate': 0.75
    },
    {
      'code': 'JPY',
      'name': 'Japanese Yen',
      'symbol': '¥',
      'flag': '🇯🇵',
      'rate': 110.0
    },
    {
      'code': 'CAD',
      'name': 'Canadian Dollar',
      'symbol': 'C\$',
      'flag': '🇨🇦',
      'rate': 1.25
    },
    {
      'code': 'AUD',
      'name': 'Australian Dollar',
      'symbol': 'A\$',
      'flag': '🇦🇺',
      'rate': 1.35
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentCurrency = ref.watch(currencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_selectedCurrency != currentCurrency && !_isChangingCurrency)
            TextButton(
              onPressed: _applyCurrencyChange,
              child: const Text(
                'Apply',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF386BF6),
                ),
              ),
            ),
        ],
      ),
      body: _isChangingCurrency
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Updating currency...',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Header with info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F9FF),
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0EAFF),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.info_circle,
                        color: Color(0xFF386BF6),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Changing the currency will update how all monetary values are displayed in the app. This will not convert your existing transactions.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontFamily: 'Nunito',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Currency search
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search currency...',
                      hintStyle: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Iconsax.search_normal),
                      fillColor: Colors.grey[100],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(fontFamily: 'Nunito'),
                    onChanged: (value) {
                      // Implement search functionality here
                      setState(() {
                        // Filter currencies based on search
                      });
                    },
                  ),
                ),

                // Currency list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: availableCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = availableCurrencies[index];
                      final isSelected = _selectedCurrency == currency['code'];

                      // Sample conversion
                      final sampleAmount = 1000.0;
                      final rate = currency['rate'] as double;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE0EAFF)
                              : Colors.white,
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
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              setState(() {
                                _selectedCurrency = currency['code'] as String;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Flag and symbol combined
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F9FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Text(
                                            currency['flag'] as String,
                                            style:
                                                const TextStyle(fontSize: 28),
                                          ),
                                        ),
                                        Positioned(
                                          right: 4,
                                          bottom: 4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF386BF6)
                                                  .withOpacity(0.9),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              currency['symbol'] as String,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Currency details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currency['name'] as String,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Text(
                                              currency['code'] as String,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '• ${currency['symbol']}${(sampleAmount / rate).toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Selection indicator
                                  if (isSelected)
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF386BF6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _applyCurrencyChange() async {
    if (_selectedCurrency != ref.read(currencyProvider)) {
      setState(() {
        _isChangingCurrency = true;
      });

      try {
        // Update currency in provider
        await ref
            .read(currencyProvider.notifier)
            .setCurrency(_selectedCurrency!);

        // Force rebuild of dependent widgets
        ref.invalidate(currencyProvider);

        if (mounted) {
          AppSnackBar.showSuccess(
            context: context,
            message: 'Currency changed successfully',
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          AppSnackBar.showError(
            context: context,
            message: 'Failed to change currency: $e',
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isChangingCurrency = false;
          });
        }
      }
    }
  }
}

// Add this new currency formatter provider to format money throughout the app
// final currencyFormatterProvider = Provider<CurrencyFormatter>((ref) {
//   final currencyCode = ref.watch(currencyProvider);

//   // Find symbol for current currency
//   final symbol = {
//         'USD': '\$',
//         'VND': '₫',
//         'EUR': '€',
//         'GBP': '£',
//         'JPY': '¥',
//         'CAD': 'C\$',
//         'AUD': 'A\$',
//       }[currencyCode] ??
//       '\$';

//   return CurrencyFormatter(currencyCode, symbol);
// });

class CurrencyFormatter {
  final String currencyCode;
  final String symbol;

  CurrencyFormatter(this.currencyCode, this.symbol);

  String format(double amount) {
    if (currencyCode == 'VND') {
      // No decimal places for VND
      return '$symbol${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
    }

    return '$symbol${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }
}
