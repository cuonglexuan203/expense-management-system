import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:expense_management_system/gen/colors.gen.dart';
import 'package:expense_management_system/shared/extensions/number_format_extension.dart';
import 'package:expense_management_system/shared/route/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class WalletList extends StatelessWidget {
  final List<Wallet> wallets;
  final int selectedIndex;
  final Function(int) onWalletSelected;

  const WalletList({
    Key? key,
    required this.wallets,
    required this.selectedIndex,
    required this.onWalletSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (wallets.isEmpty) {
      return Container(
        height: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: GestureDetector(
          onTap: () => context.push('/wallet/create'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.add, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                'Create your first wallet',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Nunito',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 124,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // New Wallet Button First
          Container(
            width: 100,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: GestureDetector(
              onTap: () => context.push('/wallet/create'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.add, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    'New wallet',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Existing Wallets
          ...List.generate(
            wallets.length,
            (index) {
              final wallet = wallets[index];
              final isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () => onWalletSelected(index),
                child: Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorName.blue.withOpacity(0.9)
                        : ColorName.blue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    border: isSelected
                        ? Border.all(
                            color: Colors.white,
                            width: 2,
                            strokeAlign: BorderSide.strokeAlignInside,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: ColorName.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Iconsax.wallet,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              wallet.name,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              wallet.balance.toFormattedString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Iconsax.edit,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () {
                          WalletDetailRoute(id: wallet.id).go(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
