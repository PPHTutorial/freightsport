// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trackingControllerHash() =>
    r'c15fc9a017995f3c6c209388e2ba0402fd81e798';

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

abstract class _$TrackingController
    extends BuildlessAutoDisposeAsyncNotifier<Shipment?> {
  late final String trackingNumber;

  FutureOr<Shipment?> build(String trackingNumber);
}

/// See also [TrackingController].
@ProviderFor(TrackingController)
const trackingControllerProvider = TrackingControllerFamily();

/// See also [TrackingController].
class TrackingControllerFamily extends Family<AsyncValue<Shipment?>> {
  /// See also [TrackingController].
  const TrackingControllerFamily();

  /// See also [TrackingController].
  TrackingControllerProvider call(String trackingNumber) {
    return TrackingControllerProvider(trackingNumber);
  }

  @override
  TrackingControllerProvider getProviderOverride(
    covariant TrackingControllerProvider provider,
  ) {
    return call(provider.trackingNumber);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'trackingControllerProvider';
}

/// See also [TrackingController].
class TrackingControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<TrackingController, Shipment?> {
  /// See also [TrackingController].
  TrackingControllerProvider(String trackingNumber)
    : this._internal(
        () => TrackingController()..trackingNumber = trackingNumber,
        from: trackingControllerProvider,
        name: r'trackingControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$trackingControllerHash,
        dependencies: TrackingControllerFamily._dependencies,
        allTransitiveDependencies:
            TrackingControllerFamily._allTransitiveDependencies,
        trackingNumber: trackingNumber,
      );

  TrackingControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.trackingNumber,
  }) : super.internal();

  final String trackingNumber;

  @override
  FutureOr<Shipment?> runNotifierBuild(covariant TrackingController notifier) {
    return notifier.build(trackingNumber);
  }

  @override
  Override overrideWith(TrackingController Function() create) {
    return ProviderOverride(
      origin: this,
      override: TrackingControllerProvider._internal(
        () => create()..trackingNumber = trackingNumber,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        trackingNumber: trackingNumber,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TrackingController, Shipment?>
  createElement() {
    return _TrackingControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TrackingControllerProvider &&
        other.trackingNumber == trackingNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, trackingNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TrackingControllerRef on AutoDisposeAsyncNotifierProviderRef<Shipment?> {
  /// The parameter `trackingNumber` of this provider.
  String get trackingNumber;
}

class _TrackingControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<TrackingController, Shipment?>
    with TrackingControllerRef {
  _TrackingControllerProviderElement(super.provider);

  @override
  String get trackingNumber =>
      (origin as TrackingControllerProvider).trackingNumber;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
