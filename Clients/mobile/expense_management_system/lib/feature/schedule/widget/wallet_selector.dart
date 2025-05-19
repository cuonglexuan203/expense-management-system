import 'package:expense_management_system/feature/home/provider/home_provider.dart';
import 'package:expense_management_system/feature/schedule/widget/error_field.dart';
import 'package:expense_management_system/feature/schedule/widget/loading_field.dart';
import 'package:expense_management_system/feature/wallet/model/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class WalletSelector extends ConsumerStatefulWidget {
  final Wallet? selectedWallet;
  final ValueChanged<Wallet?> onChanged;

  const WalletSelector({
    Key? key,
    this.selectedWallet,
    required this.onChanged,
  }) : super(key: key);

  @override
  WalletSelectorState createState() => WalletSelectorState();
}

class WalletSelectorState extends ConsumerState<WalletSelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add scroll listener for infinite scroll if needed
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Implementation would depend on if home provider has pagination
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // This would be the place to load more wallets if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeNotifierProvider);

    return homeState.maybeWhen(
      loaded: (wallets, selectedIndex) {
        return _buildDropdown(wallets);
      },
      loading: () => const LoadingField(label: 'Wallet'),
      error: (error) => ErrorField(label: 'Wallet', error: error),
      orElse: () => const LoadingField(label: 'Wallet'),
    );
  }

  Widget _buildDropdown(List<Wallet> wallets) {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Wallet*',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Iconsax.wallet),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Wallet>(
          isExpanded: true,
          hint: const Text('Select Wallet'),
          value: widget.selectedWallet,
          onChanged: widget.onChanged,
          items: wallets
              .map((wallet) => DropdownMenuItem<Wallet>(
                    value: wallet,
                    child: Text(wallet.name),
                  ))
              .toList(),
          menuMaxHeight: 300,
        ),
      ),
    );
  }
}
