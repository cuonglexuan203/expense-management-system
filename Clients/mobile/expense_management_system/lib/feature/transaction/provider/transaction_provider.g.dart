// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletTransactionsHash() =>
    r'96e8a79101315825ad0bd8956697043e325ca2a9';

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
    int walletId,
  ) {
    return WalletTransactionsProvider(
      walletId,
    );
  }

  @override
  WalletTransactionsProvider getProviderOverride(
    covariant WalletTransactionsProvider provider,
  ) {
    return call(
      provider.walletId,
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
    int walletId,
  ) : this._internal(
          (ref) => walletTransactions(
            ref as WalletTransactionsRef,
            walletId,
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
          walletId: walletId,
        );

  WalletTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.walletId,
  }) : super.internal();

  final int walletId;

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
        walletId: walletId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Transaction>> createElement() {
    return _WalletTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WalletTransactionsProvider && other.walletId == walletId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, walletId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WalletTransactionsRef on AutoDisposeFutureProviderRef<List<Transaction>> {
  /// The parameter `walletId` of this provider.
  int get walletId;
}

class _WalletTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Transaction>>
    with WalletTransactionsRef {
  _WalletTransactionsProviderElement(super.provider);

  @override
  int get walletId => (origin as WalletTransactionsProvider).walletId;
}

String _$paginatedTransactionsHash() =>
    r'335969770d7f73060d0492a641d7f28578a5b4fc';

abstract class _$PaginatedTransactions
    extends BuildlessAutoDisposeNotifier<PaginatedState<Transaction>> {
  late final int walletId;

  PaginatedState<Transaction> build(
    int walletId,
  );
}

/// See also [PaginatedTransactions].
@ProviderFor(PaginatedTransactions)
const paginatedTransactionsProvider = PaginatedTransactionsFamily();

/// See also [PaginatedTransactions].
class PaginatedTransactionsFamily extends Family<PaginatedState<Transaction>> {
  /// See also [PaginatedTransactions].
  const PaginatedTransactionsFamily();

  /// See also [PaginatedTransactions].
  PaginatedTransactionsProvider call(
    int walletId,
  ) {
    return PaginatedTransactionsProvider(
      walletId,
    );
  }

  @override
  PaginatedTransactionsProvider getProviderOverride(
    covariant PaginatedTransactionsProvider provider,
  ) {
    return call(
      provider.walletId,
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
  String? get name => r'paginatedTransactionsProvider';
}

/// See also [PaginatedTransactions].
class PaginatedTransactionsProvider extends AutoDisposeNotifierProviderImpl<
    PaginatedTransactions, PaginatedState<Transaction>> {
  /// See also [PaginatedTransactions].
  PaginatedTransactionsProvider(
    int walletId,
  ) : this._internal(
          () => PaginatedTransactions()..walletId = walletId,
          from: paginatedTransactionsProvider,
          name: r'paginatedTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$paginatedTransactionsHash,
          dependencies: PaginatedTransactionsFamily._dependencies,
          allTransitiveDependencies:
              PaginatedTransactionsFamily._allTransitiveDependencies,
          walletId: walletId,
        );

  PaginatedTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.walletId,
  }) : super.internal();

  final int walletId;

  @override
  PaginatedState<Transaction> runNotifierBuild(
    covariant PaginatedTransactions notifier,
  ) {
    return notifier.build(
      walletId,
    );
  }

  @override
  Override overrideWith(PaginatedTransactions Function() create) {
    return ProviderOverride(
      origin: this,
      override: PaginatedTransactionsProvider._internal(
        () => create()..walletId = walletId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        walletId: walletId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PaginatedTransactions,
      PaginatedState<Transaction>> createElement() {
    return _PaginatedTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PaginatedTransactionsProvider && other.walletId == walletId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, walletId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PaginatedTransactionsRef
    on AutoDisposeNotifierProviderRef<PaginatedState<Transaction>> {
  /// The parameter `walletId` of this provider.
  int get walletId;
}

class _PaginatedTransactionsProviderElement
    extends AutoDisposeNotifierProviderElement<PaginatedTransactions,
        PaginatedState<Transaction>> with PaginatedTransactionsRef {
  _PaginatedTransactionsProviderElement(super.provider);

  @override
  int get walletId => (origin as PaginatedTransactionsProvider).walletId;
}

String _$transactionNotifierHash() =>
    r'b319dee48a4cfed1302335c03b567a3043b8fd58';

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
