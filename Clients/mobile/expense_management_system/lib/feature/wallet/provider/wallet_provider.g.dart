// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredWalletHash() => r'811b0a274b3c04caaa0240980a11f4296e0e69b6';

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

/// See also [filteredWallet].
@ProviderFor(filteredWallet)
const filteredWalletProvider = FilteredWalletFamily();

/// See also [filteredWallet].
class FilteredWalletFamily extends Family<AsyncValue<Wallet>> {
  /// See also [filteredWallet].
  const FilteredWalletFamily();

  /// See also [filteredWallet].
  FilteredWalletProvider call(
    FilterParams params,
  ) {
    return FilteredWalletProvider(
      params,
    );
  }

  @override
  FilteredWalletProvider getProviderOverride(
    covariant FilteredWalletProvider provider,
  ) {
    return call(
      provider.params,
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
  String? get name => r'filteredWalletProvider';
}

/// See also [filteredWallet].
class FilteredWalletProvider extends AutoDisposeFutureProvider<Wallet> {
  /// See also [filteredWallet].
  FilteredWalletProvider(
    FilterParams params,
  ) : this._internal(
          (ref) => filteredWallet(
            ref as FilteredWalletRef,
            params,
          ),
          from: filteredWalletProvider,
          name: r'filteredWalletProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredWalletHash,
          dependencies: FilteredWalletFamily._dependencies,
          allTransitiveDependencies:
              FilteredWalletFamily._allTransitiveDependencies,
          params: params,
        );

  FilteredWalletProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final FilterParams params;

  @override
  Override overrideWith(
    FutureOr<Wallet> Function(FilteredWalletRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredWalletProvider._internal(
        (ref) => create(ref as FilteredWalletRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Wallet> createElement() {
    return _FilteredWalletProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredWalletProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredWalletRef on AutoDisposeFutureProviderRef<Wallet> {
  /// The parameter `params` of this provider.
  FilterParams get params;
}

class _FilteredWalletProviderElement
    extends AutoDisposeFutureProviderElement<Wallet> with FilteredWalletRef {
  _FilteredWalletProviderElement(super.provider);

  @override
  FilterParams get params => (origin as FilteredWalletProvider).params;
}

String _$walletNotifierHash() => r'660651d05deeff3ac26bbc1f518b2e52982682b3';

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
