// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletTransactionsHash() =>
    r'0fffb6f08d032241daebbd83c2f80b4af8322327';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [walletTransactions].
@ProviderFor(walletTransactions)
const walletTransactionsProvider = WalletTransactionsFamily();

/// See also [walletTransactions].
class WalletTransactionsFamily extends Family<AsyncValue<List<Transaction>>> {
  /// See also [walletTransactions].
  const WalletTransactionsFamily();

  /// See also [walletTransactions].
  WalletTransactionsProvider call(
    String walletName,
  ) {
    return WalletTransactionsProvider(
      walletName,
    );
  }

  @override
  WalletTransactionsProvider getProviderOverride(
    covariant WalletTransactionsProvider provider,
  ) {
    return call(
      provider.walletName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'walletTransactionsProvider';
}

/// See also [walletTransactions].
class WalletTransactionsProvider
    extends AutoDisposeFutureProvider<List<Transaction>> {
  /// See also [walletTransactions].
  WalletTransactionsProvider(
    String walletName,
  ) : this._internal(
          (ref) => walletTransactions(
            ref as WalletTransactionsRef,
            walletName,
          ),
          from: walletTransactionsProvider,
          name: r'walletTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$walletTransactionsHash,
          dependencies: WalletTransactionsFamily._dependencies,
          allTransitiveDependencies:
              WalletTransactionsFamily._allTransitiveDependencies,
          walletName: walletName,
        );

  WalletTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.walletName,
  }) : super.internal();

  final String walletName;

  @override
  Override overrideWith(
    FutureOr<List<Transaction>> Function(WalletTransactionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WalletTransactionsProvider._internal(
        (ref) => create(ref as WalletTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        walletName: walletName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Transaction>> createElement() {
    return _WalletTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WalletTransactionsProvider &&
        other.walletName == walletName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, walletName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WalletTransactionsRef on AutoDisposeFutureProviderRef<List<Transaction>> {
  /// The parameter `walletName` of this provider.
  String get walletName;
}

class _WalletTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Transaction>>
    with WalletTransactionsRef {
  _WalletTransactionsProviderElement(super.provider);

  @override
  String get walletName => (origin as WalletTransactionsProvider).walletName;
}

String _$transactionNotifierHash() =>
    r'c4d77660d4e1513216a381fd77768a651be11288';

/// See also [TransactionNotifier].
@ProviderFor(TransactionNotifier)
final transactionNotifierProvider = AutoDisposeAsyncNotifierProvider<
    TransactionNotifier, Transaction?>.internal(
  TransactionNotifier.new,
  name: r'transactionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionNotifier = AutoDisposeAsyncNotifier<Transaction?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
