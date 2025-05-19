// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionTrendsHash() => r'897b11234067577bf38e8f84514ac5c6ccceac57';

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

/// See also [transactionTrends].
@ProviderFor(transactionTrends)
const transactionTrendsProvider = TransactionTrendsFamily();

/// See also [transactionTrends].
class TransactionTrendsFamily
    extends Family<AsyncValue<Map<String, List<FlSpot>>>> {
  /// See also [transactionTrends].
  const TransactionTrendsFamily();

  /// See also [transactionTrends].
  TransactionTrendsProvider call({
    required int walletId,
    required String period,
  }) {
    return TransactionTrendsProvider(
      walletId: walletId,
      period: period,
    );
  }

  @override
  TransactionTrendsProvider getProviderOverride(
    covariant TransactionTrendsProvider provider,
  ) {
    return call(
      walletId: provider.walletId,
      period: provider.period,
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
  String? get name => r'transactionTrendsProvider';
}

/// See also [transactionTrends].
class TransactionTrendsProvider
    extends AutoDisposeFutureProvider<Map<String, List<FlSpot>>> {
  /// See also [transactionTrends].
  TransactionTrendsProvider({
    required int walletId,
    required String period,
  }) : this._internal(
          (ref) => transactionTrends(
            ref as TransactionTrendsRef,
            walletId: walletId,
            period: period,
          ),
          from: transactionTrendsProvider,
          name: r'transactionTrendsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionTrendsHash,
          dependencies: TransactionTrendsFamily._dependencies,
          allTransitiveDependencies:
              TransactionTrendsFamily._allTransitiveDependencies,
          walletId: walletId,
          period: period,
        );

  TransactionTrendsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.walletId,
    required this.period,
  }) : super.internal();

  final int walletId;
  final String period;

  @override
  Override overrideWith(
    FutureOr<Map<String, List<FlSpot>>> Function(TransactionTrendsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionTrendsProvider._internal(
        (ref) => create(ref as TransactionTrendsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        walletId: walletId,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Map<String, List<FlSpot>>> createElement() {
    return _TransactionTrendsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionTrendsProvider &&
        other.walletId == walletId &&
        other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, walletId.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionTrendsRef
    on AutoDisposeFutureProviderRef<Map<String, List<FlSpot>>> {
  /// The parameter `walletId` of this provider.
  int get walletId;

  /// The parameter `period` of this provider.
  String get period;
}

class _TransactionTrendsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, List<FlSpot>>>
    with TransactionTrendsRef {
  _TransactionTrendsProviderElement(super.provider);

  @override
  int get walletId => (origin as TransactionTrendsProvider).walletId;
  @override
  String get period => (origin as TransactionTrendsProvider).period;
}

String _$topExpenseCategoriesHash() =>
    r'e43d7aad89f0d6f8d1c1ee8af3c305777635f909';

/// See also [topExpenseCategories].
@ProviderFor(topExpenseCategories)
const topExpenseCategoriesProvider = TopExpenseCategoriesFamily();

/// See also [topExpenseCategories].
class TopExpenseCategoriesFamily
    extends Family<AsyncValue<List<CategorySpendingSummary>>> {
  /// See also [topExpenseCategories].
  const TopExpenseCategoriesFamily();

  /// See also [topExpenseCategories].
  TopExpenseCategoriesProvider call({
    required int walletId,
    required String period,
  }) {
    return TopExpenseCategoriesProvider(
      walletId: walletId,
      period: period,
    );
  }

  @override
  TopExpenseCategoriesProvider getProviderOverride(
    covariant TopExpenseCategoriesProvider provider,
  ) {
    return call(
      walletId: provider.walletId,
      period: provider.period,
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
  String? get name => r'topExpenseCategoriesProvider';
}

/// See also [topExpenseCategories].
class TopExpenseCategoriesProvider
    extends AutoDisposeFutureProvider<List<CategorySpendingSummary>> {
  /// See also [topExpenseCategories].
  TopExpenseCategoriesProvider({
    required int walletId,
    required String period,
  }) : this._internal(
          (ref) => topExpenseCategories(
            ref as TopExpenseCategoriesRef,
            walletId: walletId,
            period: period,
          ),
          from: topExpenseCategoriesProvider,
          name: r'topExpenseCategoriesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$topExpenseCategoriesHash,
          dependencies: TopExpenseCategoriesFamily._dependencies,
          allTransitiveDependencies:
              TopExpenseCategoriesFamily._allTransitiveDependencies,
          walletId: walletId,
          period: period,
        );

  TopExpenseCategoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.walletId,
    required this.period,
  }) : super.internal();

  final int walletId;
  final String period;

  @override
  Override overrideWith(
    FutureOr<List<CategorySpendingSummary>> Function(
            TopExpenseCategoriesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TopExpenseCategoriesProvider._internal(
        (ref) => create(ref as TopExpenseCategoriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        walletId: walletId,
        period: period,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CategorySpendingSummary>>
      createElement() {
    return _TopExpenseCategoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TopExpenseCategoriesProvider &&
        other.walletId == walletId &&
        other.period == period;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, walletId.hashCode);
    hash = _SystemHash.combine(hash, period.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TopExpenseCategoriesRef
    on AutoDisposeFutureProviderRef<List<CategorySpendingSummary>> {
  /// The parameter `walletId` of this provider.
  int get walletId;

  /// The parameter `period` of this provider.
  String get period;
}

class _TopExpenseCategoriesProviderElement
    extends AutoDisposeFutureProviderElement<List<CategorySpendingSummary>>
    with TopExpenseCategoriesRef {
  _TopExpenseCategoriesProviderElement(super.provider);

  @override
  int get walletId => (origin as TopExpenseCategoriesProvider).walletId;
  @override
  String get period => (origin as TopExpenseCategoriesProvider).period;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
