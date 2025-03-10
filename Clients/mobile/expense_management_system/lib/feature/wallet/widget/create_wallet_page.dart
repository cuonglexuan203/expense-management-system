import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerplate/gen/colors.gen.dart';
import 'package:iconsax/iconsax.dart';
import '../provider/wallet_provider.dart';

class CreateWalletPage extends ConsumerWidget {
  CreateWalletPage({super.key});

  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(walletNotifierProvider, (previous, next) {
      next.whenOrNull(
        success: (wallet) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wallet created successfully!')),
          );
          Navigator.pop(context);
        },
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create wallet')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wallet Name',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter wallet name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Initial Balance',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter initial balance',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(walletNotifierProvider);

                  return ElevatedButton(
                    onPressed: state.maybeWhen(
                      loading: () => null,
                      orElse: () => () {
                        final balance =
                            double.tryParse(_balanceController.text) ?? 0;
                        ref
                            .read(walletNotifierProvider.notifier)
                            .createWallet(_nameController.text, balance);
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorName.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: state.maybeWhen(
                      loading: () =>
                          const CircularProgressIndicator(color: Colors.white),
                      orElse: () => const Text(
                        'CREATE WALLET',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
