// lib/feature/onboarding/widget/wallet_step.dart
import 'package:expense_management_system/feature/onboarding/provider/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletStep extends ConsumerStatefulWidget {
  const WalletStep({Key? key}) : super(key: key);

  @override
  ConsumerState<WalletStep> createState() => _WalletStepState();
}

class _WalletStepState extends ConsumerState<WalletStep> {
  final _formKey = GlobalKey<FormState>();
  final _walletNameController = TextEditingController();
  final _initialBalanceController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingNotifierProvider);
    _walletNameController.text = state.walletName;
    if (state.initialBalance > 0) {
      _initialBalanceController.text = state.initialBalance.toString();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFormValidity();
    });
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    _initialBalanceController.dispose();
    super.dispose();
  }

  void _saveWalletData() {
    if (_formKey.currentState!.validate()) {
      final name = _walletNameController.text.trim();
      final balance = double.tryParse(_initialBalanceController.text) ?? 0.0;

      ref.read(onboardingNotifierProvider.notifier).updateWallet(name, balance);
      _checkFormValidity();
    }
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _walletNameController.text.isNotEmpty;
    });

    // Update button state in parent
    if (_isFormValid) {
      ref.read(onboardingNotifierProvider.notifier).setStepValidity(true);
    } else {
      ref.read(onboardingNotifierProvider.notifier).setStepValidity(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyCode = ref.watch(onboardingNotifierProvider).currency;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          onChanged: () {
            _saveWalletData();
            _checkFormValidity();
          },
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
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 40,
                    color: Colors.amber,
                  ),
                ),
              ),

              // Explanation card
              Card(
                elevation: 0,
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade800),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Create your first wallet to start tracking your finances',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A wallet represents a real account or cash where your money is stored',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Wallet Name
              Text(
                'Wallet Name',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _walletNameController,
                decoration: InputDecoration(
                  hintText: 'e.g. Main Account, Cash Wallet',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                  errorStyle: const TextStyle(height: 0.8),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a wallet name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Initial Balance
              Row(
                children: [
                  Text(
                    'Initial Balance',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: 'Enter your current balance in this account',
                    child: Icon(
                      Icons.help_outline,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _initialBalanceController,
                decoration: InputDecoration(
                  hintText: '0.00',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getCurrencySymbol(currencyCode),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),

              const SizedBox(height: 32),

              // Wallet type suggestions title
              Text(
                'Suggested Wallet Types',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Wallet type suggestions
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildWalletSuggestionChip('Cash', Icons.money),
                  _buildWalletSuggestionChip(
                      'Bank Account', Icons.account_balance),
                  _buildWalletSuggestionChip('Credit Card', Icons.credit_card),
                  _buildWalletSuggestionChip('Savings', Icons.savings),
                  _buildWalletSuggestionChip('E-Wallet', Icons.smartphone),
                  _buildWalletSuggestionChip('Investment', Icons.trending_up),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletSuggestionChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _walletNameController.text = label;
        });
        _saveWalletData();
      },
      child: Chip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        backgroundColor: Colors.grey.shade100,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'VND':
        return '₫';
      case 'INR':
        return '₹';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      default:
        return currencyCode;
    }
  }
}
