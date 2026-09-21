import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/providers/core_providers.dart';
import 'package:rainbow_app/features/guard/data/guard_repository.dart';
import 'package:rainbow_app/features/guard/models/gate_entry.dart';
import 'package:rainbow_app/features/guard/models/gate_in_request.dart';
import 'package:rainbow_app/features/guard/models/hold_reason.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';
import 'package:rainbow_app/features/guard/models/vehicle_gate_pass_full.dart';
import 'package:rainbow_app/features/guard/models/vehicle_inspection.dart';
import 'package:rainbow_app/features/guard/models/vehicle_lookup.dart';

final Provider<GuardRepository> guardRepositoryProvider =
    Provider<GuardRepository>(
      (Ref ref) => GuardRepository(ref.watch(apiClientProvider)),
      name: 'guardRepository',
    );

/// Sales orders a guard can register an arriving vehicle against.
final FutureProvider<List<ReadyOrder>> readyOrdersProvider =
    FutureProvider.autoDispose<List<ReadyOrder>>(
      (Ref ref) => ref.watch(guardRepositoryProvider).fetchReadyOrders(),
      name: 'readyOrders',
    );

/// The last few gate entries, for the dashboard.
final FutureProvider<List<GateEntry>> recentVehiclesProvider =
    FutureProvider.autoDispose<List<GateEntry>>(
      (Ref ref) => ref.watch(guardRepositoryProvider).fetchRecentVehicles(),
      name: 'recentVehicles',
    );

/// What the store loaded onto a given vehicle, keyed by gate-entry id.
// The family type lives in riverpod's `misc` library, which is not part of
// flutter_riverpod's public surface; inference gives the same static type.
final vehicleInspectionProvider = FutureProvider.autoDispose
    .family<VehicleInspection, int>(
      (Ref ref, int vehicleId) =>
          ref.watch(guardRepositoryProvider).fetchInspection(vehicleId),
      name: 'vehicleInspection',
    );

/// Standardized hold reasons from `GET /guard/hold-reasons`.
final holdReasonsProvider = FutureProvider.autoDispose<List<HoldReason>>(
  (Ref ref) => ref.watch(guardRepositoryProvider).fetchHoldReasons(),
  name: 'holdReasons',
);

/// Auto-fill lookup for vehicle plates from `GET /guard/vehicles/lookup`.
final vehicleLookupProvider = FutureProvider.autoDispose
    .family<VehicleLookup?, String>(
      (Ref ref, String plate) =>
          ref.watch(guardRepositoryProvider).lookupVehicle(plate),
      name: 'vehicleLookup',
    );

/// Complete gate pass record from `GET /guard/vehicles/{id}`.
final vehicleGatePassFullProvider = FutureProvider.autoDispose
    .family<VehicleGatePassFull, int>(
      (Ref ref, int vehicleId) => ref
          .watch(guardRepositoryProvider)
          .fetchVehicleGatePassFull(vehicleId),
      name: 'vehicleGatePassFull',
    );

/// The status filter and search text applied to the vehicle list.
@immutable
class VehicleFilter {
  const VehicleFilter({this.status, this.query = ''});

  /// `null` means "all statuses".
  final GateEntryStatus? status;

  final String query;

  VehicleFilter copyWith({
    GateEntryStatus? status,
    String? query,
    bool clearStatus = false,
  }) {
    return VehicleFilter(
      status: clearStatus ? null : (status ?? this.status),
      query: query ?? this.query,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is VehicleFilter && other.status == status && other.query == query;

  @override
  int get hashCode => Object.hash(status, query);
}

class VehicleFilterController extends Notifier<VehicleFilter> {
  @override
  VehicleFilter build() => const VehicleFilter();

  void setStatus(GateEntryStatus? status) {
    state = status == null
        ? state.copyWith(clearStatus: true)
        : state.copyWith(status: status);
  }

  void setQuery(String query) => state = state.copyWith(query: query);
}

final NotifierProvider<VehicleFilterController, VehicleFilter>
vehicleFilterProvider =
    NotifierProvider<VehicleFilterController, VehicleFilter>(
      VehicleFilterController.new,
      name: 'vehicleFilter',
    );

/// The paginated vehicle list.
///
/// Rebuilds whenever the filter changes — which resets to page one — and
/// appends pages through [loadMore] as the guard scrolls.
class VehiclesController extends AsyncNotifier<PagedResult<GateEntry>> {
  bool _isLoadingMore = false;

  @override
  Future<PagedResult<GateEntry>> build() {
    final VehicleFilter filter = ref.watch(vehicleFilterProvider);
    return ref
        .watch(guardRepositoryProvider)
        .fetchVehicles(status: filter.status, query: filter.query);
  }

  /// Appends the next page. Safe to call repeatedly from a scroll listener:
  /// concurrent and past-the-end calls are ignored.
  Future<void> loadMore() async {
    final PagedResult<GateEntry>? current = state.value;
    if (current == null || !current.hasMore || _isLoadingMore) return;
    _isLoadingMore = true;
    try {
      final VehicleFilter filter = ref.read(vehicleFilterProvider);
      final PagedResult<GateEntry> next = await ref
          .read(guardRepositoryProvider)
          .fetchVehicles(
            status: filter.status,
            query: filter.query,
            page: current.currentPage + 1,
          );
      state = AsyncValue<PagedResult<GateEntry>>.data(current.merge(next));
    } on Exception {
      // A failed page-two keeps page one on screen; the guard can pull to
      // refresh. Surfacing an error state here would discard loaded rows.
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Re-fetches from page one.
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

final AsyncNotifierProvider<VehiclesController, PagedResult<GateEntry>>
vehiclesProvider =
    AsyncNotifierProvider<VehiclesController, PagedResult<GateEntry>>(
      VehiclesController.new,
      name: 'vehicles',
    );

/// Submits a gate-in. Holds the issued [GateEntry] so the screen can confirm
/// which gate pass was printed.
///
/// Deliberately not auto-disposed: screens `read` this controller to perform
/// the action rather than watching it, and an auto-disposed provider with no
/// watchers is torn down as soon as `read` returns — taking the in-flight
/// request with it.
class GateInController extends AsyncNotifier<GateEntry?> {
  @override
  Future<GateEntry?> build() async => null;

  Future<GateEntry> submit(GateInRequest request) async {
    state = const AsyncValue<GateEntry?>.loading();
    try {
      final GateEntry entry = await ref
          .read(guardRepositoryProvider)
          .registerGateIn(request);
      state = AsyncValue<GateEntry?>.data(entry);
      _invalidateQueues();
      return entry;
    } on Object catch (error, stackTrace) {
      state = AsyncValue<GateEntry?>.error(error, stackTrace);
      rethrow;
    }
  }

  /// A new gate entry changes every queue that lists vehicles or orders.
  void _invalidateQueues() {
    ref
      ..invalidate(readyOrdersProvider)
      ..invalidate(recentVehiclesProvider)
      ..invalidate(vehiclesProvider);
  }
}

final AsyncNotifierProvider<GateInController, GateEntry?>
gateInControllerProvider = AsyncNotifierProvider<GateInController, GateEntry?>(
  GateInController.new,
  name: 'gateInController',
);

/// Approves or holds a vehicle at the exit.
class GateOutController extends AsyncNotifier<GateEntry?> {
  @override
  Future<GateEntry?> build() async => null;

  Future<GateEntry> submit({
    required int vehicleId,
    required GateOutAction action,
    String? reason,
    String? remarks,
  }) async {
    state = const AsyncValue<GateEntry?>.loading();
    try {
      final GateEntry entry = await ref
          .read(guardRepositoryProvider)
          .submitGateOut(
            vehicleId: vehicleId,
            action: action,
            reason: reason,
            remarks: remarks,
          );
      state = AsyncValue<GateEntry?>.data(entry);
      ref
        ..invalidate(vehicleInspectionProvider(vehicleId))
        ..invalidate(recentVehiclesProvider)
        ..invalidate(vehiclesProvider);
      return entry;
    } on Object catch (error, stackTrace) {
      state = AsyncValue<GateEntry?>.error(error, stackTrace);
      rethrow;
    }
  }
}

final AsyncNotifierProvider<GateOutController, GateEntry?>
gateOutControllerProvider =
    AsyncNotifierProvider<GateOutController, GateEntry?>(
      GateOutController.new,
      name: 'gateOutController',
    );
