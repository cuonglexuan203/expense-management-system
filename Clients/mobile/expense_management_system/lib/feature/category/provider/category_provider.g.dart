// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryNotifierHash() => r'59cef3936f90eaa1f33cac7d59eed1e1e3a429d9';

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

abstract class _$CategoryNotifier
    extends BuildlessAutoDisposeAsyncNotifier<CategoryState> {
  late final String flowType;

  FutureOr<CategoryState> build(
    String flowType,
  );
}

/// See also [CategoryNotifier].
@ProviderFor(CategoryNotifier)
const categoryNotifierProvider = CategoryNotifierFamily();

/// See also [CategoryNotifier].
class CategoryNotifierFamily extends Family<AsyncValue<CategoryState>> {
  /// See also [CategoryNotifier].
  const CategoryNotifierFamily();

  /// See also [CategoryNotifier].
  CategoryNotifierProvider call(
    String flowType,
  ) {
    return CategoryNotifierProvider(
      flowType,
    );
  }

  @override
  CategoryNotifierProvider getProviderOverride(
    covariant CategoryNotifierProvider provider,
  ) {
    return call(
      provider.flowType,
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
  String? get name => r'categoryNotifierProvider';
}

/// See also [CategoryNotifier].
class CategoryNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    CategoryNotifier, CategoryState> {
  /// See also [CategoryNotifier].
  CategoryNotifierProvider(
    String flowType,
  ) : this._internal(
          () => CategoryNotifier()..flowType = flowType,
          from: categoryNotifierProvider,
          name: r'categoryNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$categoryNotifierHash,
          dependencies: CategoryNotifierFamily._dependencies,
          allTransitiveDependencies:
              CategoryNotifierFamily._allTransitiveDependencies,
          flowType: flowType,
        );

  CategoryNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.flowType,
  }) : super.internal();

  final String flowType;

  @override
  FutureOr<CategoryState> runNotifierBuild(
    covariant CategoryNotifier notifier,
  ) {
    return notifier.build(
      flowType,
    );
  }

  @override
  Override overrideWith(CategoryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryNotifierProvider._internal(
        () => create()..flowType = flowType,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        flowType: flowType,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CategoryNotifier, CategoryState>
      createElement() {
    return _CategoryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryNotifierProvider && other.flowType == flowType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, flowType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<CategoryState> {
  /// The parameter `flowType` of this provider.
  String get flowType;
}

class _CategoryNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<CategoryNotifier,
        CategoryState> with CategoryNotifierRef {
  _CategoryNotifierProviderElement(super.provider);

  @override
  String get flowType => (origin as CategoryNotifierProvider).flowType;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
