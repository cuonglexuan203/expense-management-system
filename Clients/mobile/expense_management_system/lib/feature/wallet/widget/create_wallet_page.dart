import 'package:expense_management_system/feature/wallet/provider/wallet_provider.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/util/number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CreateWalletPage extends ConsumerWidget {
  CreateWalletPage({super.key});

  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _numberFormatter = NumberFormatter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(walletNotifierProvider, (previous, next) {
      next.whenOrNull(
        success: (wallet) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Iconsax.tick_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Wallet created successfully!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          Navigator.pop(context);
        },
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Iconsax.warning_2, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Failed to create wallet'),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Wallet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorName.chatGradientStart,
                ColorName.chatGradientEnd,
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet icon section
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Iconsax.wallet,
                      size: 50,
                      color: ColorName.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Wallet Name field
                const Text(
                  'Wallet Name',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter wallet name',
                    prefixIcon:
                        const Icon(Iconsax.wallet_3, color: ColorName.blue),
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
                      borderSide:
                          const BorderSide(color: ColorName.blue, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter wallet name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Initial Balance field
                const Text(
                  'Initial Balance',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _balanceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    prefixIcon:
                        const Icon(Iconsax.money, color: ColorName.blue),
                    prefixStyle: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
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
                      borderSide:
                          const BorderSide(color: ColorName.blue, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  inputFormatters: [
                    _numberFormatter,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter initial balance';
                    }

                    final numericValue =
                        double.tryParse(value.replaceAll(',', ''));
                    if (numericValue == null) {
                      return 'Please enter a valid number';
                    }

                    if (numericValue <= 0) {
                      return 'Balance must be greater than 0';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Create Button
                SizedBox(
                  width: double.infinity,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final state = ref.watch(walletNotifierProvider);

                      return ElevatedButton(
                        onPressed: state.maybeWhen(
                          loading: () => null,
                          orElse: () => () {
                            if (_formKey.currentState!.validate()) {
                              final String inputText = _balanceController.text;
                              final double balance =
                                  double.parse(inputText.replaceAll(',', ''));

                              ref
                                  .read(walletNotifierProvider.notifier)
                                  .createWallet(
                                    _nameController.text,
                                    balance,
                                  );
                            }
                          },
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorName.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: state.maybeWhen(
                          loading: () => const CircularProgressIndicator(
                              color: Colors.white),
                          orElse: () => const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Iconsax.add_circle, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'CREATE WALLET',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
