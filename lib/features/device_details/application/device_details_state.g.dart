// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_details_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deviceDetailsStateHash() =>
    r'cacb3e827a41736ab9e10dd563f64b35d6a2c678';

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

abstract class _$DeviceDetailsState
    extends BuildlessAutoDisposeAsyncNotifier<MobileInfo> {
  late final int id;

  FutureOr<MobileInfo> build(int id);
}

/// See also [DeviceDetailsState].
@ProviderFor(DeviceDetailsState)
const deviceDetailsStateProvider = DeviceDetailsStateFamily();

/// See also [DeviceDetailsState].
class DeviceDetailsStateFamily extends Family<AsyncValue<MobileInfo>> {
  /// See also [DeviceDetailsState].
  const DeviceDetailsStateFamily();

  /// See also [DeviceDetailsState].
  DeviceDetailsStateProvider call(int id) {
    return DeviceDetailsStateProvider(id);
  }

  @override
  DeviceDetailsStateProvider getProviderOverride(
    covariant DeviceDetailsStateProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deviceDetailsStateProvider';
}

/// See also [DeviceDetailsState].
class DeviceDetailsStateProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<DeviceDetailsState, MobileInfo> {
  /// See also [DeviceDetailsState].
  DeviceDetailsStateProvider(int id)
    : this._internal(
        () => DeviceDetailsState()..id = id,
        from: deviceDetailsStateProvider,
        name: r'deviceDetailsStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deviceDetailsStateHash,
        dependencies: DeviceDetailsStateFamily._dependencies,
        allTransitiveDependencies:
            DeviceDetailsStateFamily._allTransitiveDependencies,
        id: id,
      );

  DeviceDetailsStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<MobileInfo> runNotifierBuild(covariant DeviceDetailsState notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(DeviceDetailsState Function() create) {
    return ProviderOverride(
      origin: this,
      override: DeviceDetailsStateProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DeviceDetailsState, MobileInfo>
  createElement() {
    return _DeviceDetailsStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeviceDetailsStateProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeviceDetailsStateRef on AutoDisposeAsyncNotifierProviderRef<MobileInfo> {
  /// The parameter `id` of this provider.
  int get id;
}

class _DeviceDetailsStateProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<DeviceDetailsState, MobileInfo>
    with DeviceDetailsStateRef {
  _DeviceDetailsStateProviderElement(super.provider);

  @override
  int get id => (origin as DeviceDetailsStateProvider).id;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
