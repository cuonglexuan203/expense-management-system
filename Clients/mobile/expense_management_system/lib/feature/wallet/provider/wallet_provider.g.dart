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
String _$walletDetailNotifierHash() =>
    r'5de3d7a853950b4af6e71a7b8de487ae509e8aed';

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

abstract class _$WalletDetailNotifier
    extends BuildlessAutoDisposeNotifier<WalletState> {
  late final int walletId;

  WalletState build(
    int walletId,
  );
}

/// See also [WalletDetailNotifier].
@ProviderFor(WalletDetailNotifier)
const walletDetailNotifierProvider = WalletDetailNotifierFamily();

/// See also [WalletDetailNotifier].
class WalletDetailNotifierFamily extends Family<WalletState> {
  /// See also [WalletDetailNotifier].
  const WalletDetailNotifierFamily();

  /// See also [WalletDetailNotifier].
  WalletDetailNotifierProvider call(
    int walletId,
  ) {
    return WalletDetailNotifierProvider(
      walletId,
    );
  }

  @override
  WalletDetailNotifierProvider getProviderOverride(
    covariant WalletDetailNotifierProvider provider,
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
  String? get name => r'walletDetailNotifierProvider';
}

/// See also [WalletDetailNotifier].
class WalletDetailNotifierProvider
    extends AutoDisposeNotifierProviderImpl<WalletDetailNotifier, WalletState> {
  /// See also [WalletDetailNotifier].
  WalletDetailNotifierProvider(
    int walletId,
  ) : this._internal(
          () => WalletDetailNotifier()..walletId = walletId,
          from: walletDetailNotifierProvider,
          name: r'walletDetailNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$walletDetailNotifierHash,
          dependencies: WalletDetailNotifierFamily._dependencies,
          allTransitiveDependencies:
              WalletDetailNotifierFamily._allTransitiveDependencies,
          walletId: walletId,
        );

  WalletDetailNotifierProvider._internal(
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
  WalletState runNotifierBuild(
    covariant WalletDetailNotifier notifier,
  ) {
    return notifier.build(
      walletId,
    );
  }

  @override
  Override overrideWith(WalletDetailNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: WalletDetailNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<WalletDetailNotifier, WalletState>
      createElement() {
    return _WalletDetailNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WalletDetailNotifierProvider && other.walletId == walletId;
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
mixin WalletDetailNotifierRef on AutoDisposeNotifierProviderRef<WalletState> {
  /// The parameter `walletId` of this provider.
  int get walletId;
}

class _WalletDetailNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<WalletDetailNotifier,
        WalletState> with WalletDetailNotifierRef {
  _WalletDetailNotifierProviderElement(super.provider);

  @override
  int get walletId => (origin as WalletDetailNotifierProvider).walletId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
