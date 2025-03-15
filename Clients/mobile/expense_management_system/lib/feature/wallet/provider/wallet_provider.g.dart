// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletChangesHash() => r'db9634d208f64e1a836592832d2d209f24bf28a4';

/// See also [WalletChanges].
@ProviderFor(WalletChanges)
final walletChangesProvider =
    AutoDisposeNotifierProvider<WalletChanges, int>.internal(
  WalletChanges.new,
  name: r'walletChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WalletChanges = AutoDisposeNotifier<int>;
String _$walletNotifierHash() => r'545338571b0a7553d6b0bbbfb35be3e9883ee547';

/// See also [WalletNotifier].
@ProviderFor(WalletNotifier)
final walletNotifierProvider =
    AutoDisposeNotifierProvider<WalletNotifier, WalletState>.internal(
  WalletNotifier.new,
  name: r'walletNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WalletNotifier = AutoDisposeNotifier<WalletState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
