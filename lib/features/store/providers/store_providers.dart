import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/providers/core_providers.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';
import 'package:rainbow_app/features/store/data/store_repository.dart';
import 'package:rainbow_app/features/store/models/entered_vehicle.dart';
import 'package:rainbow_app/features/store/models/load_request.dart';
import 'package:rainbow_app/features/store/models/order_item.dart';

final Provider<StoreRepository> storeRepositoryProvider =
    Provider<StoreRepository>(
      (Ref ref) => StoreRepository(ref.watch(apiClientProvider)),
      name: 'storeRepository',
    );

/// Vehicles inside the gate, waiting to be loaded.
final FutureProvider<List<EnteredVehicle>> enteredVehiclesProvider =
    FutureProvider.autoDispose<List<EnteredVehicle>>(
      (Ref ref) => ref.watch(storeRepositoryProvider).fetchEnteredVehicles(),
      name: 'enteredVehicles',
    );

/// Free-text filter over the waiting list.
///
/// Filtering happens on the client because the endpoint returns the full
/// queue — typically a handful of vehicles — in one call.
class EnteredVehicleQueryController extends Notifier<String> {
  @override
  String build() => '';

  /// Leading whitespace is never meaningful in a search box and would
  /// otherwise hide every result after an accidental space.
  void setQuery(String value) {
    state = value.trimLeft();
  }
}

final NotifierProvider<EnteredVehicleQueryController, String>
enteredVehicleQueryProvider =
    NotifierProvider<EnteredVehicleQueryController, String>(
      EnteredVehicleQueryController.new,
      name: 'enteredVehicleQuery',
    );

/// The waiting list with the current query applied.
final Provider<AsyncValue<List<EnteredVehicle>>>
filteredEnteredVehiclesProvider = Provider<AsyncValue<List<EnteredVehicle>>>((
  Ref ref,
) {
  final String query = ref.watch(enteredVehicleQueryProvider).trim();
  return ref
      .watch(enteredVehiclesProvider)
      .whenData(
        (List<EnteredVehicle> vehicles) => query.isEmpty
            ? vehicles
            : vehicles
                  .where((EnteredVehicle v) => v.matches(query))
                  .toList(growable: false),
      );
}, name: 'filteredEnteredVehicles');

/// Order lines and pending quantities for one vehicle, keyed by gate-entry id.
final vehicleOrderItemsProvider = FutureProvider.autoDispose
    .family<VehicleOrderItems, int>(
      (Ref ref, int vehicleId) =>
          ref.watch(storeRepositoryProvider).fetchOrderItems(vehicleId),
      name: 'vehicleOrderItems',
    );

/// Submits the loading record for a vehicle.
class LoadController extends AsyncNotifier<LoadResult?> {
  @override
  Future<LoadResult?> build() async => null;

  Future<LoadResult> submit({
    required int vehicleId,
    required LoadRequest request,
  }) async {
    state = const AsyncValue<LoadResult?>.loading();
    try {
      final LoadResult result = await ref
          .read(storeRepositoryProvider)
          .submitLoad(vehicleId: vehicleId, request: request);
      state = AsyncValue<LoadResult?>.data(result);
      // The vehicle leaves the store queue and enters the guard's exit
      // queue, so both sides' lists are now stale.
      ref
        ..invalidate(enteredVehiclesProvider)
        ..invalidate(vehicleOrderItemsProvider(vehicleId))
        ..invalidate(vehicleInspectionProvider(vehicleId))
        ..invalidate(recentVehiclesProvider)
        ..invalidate(vehiclesProvider);
      return result;
    } on Object catch (error, stackTrace) {
      state = AsyncValue<LoadResult?>.error(error, stackTrace);
      rethrow;
    }
  }
}

final AsyncNotifierProvider<LoadController, LoadResult?>
loadControllerProvider = AsyncNotifierProvider<LoadController, LoadResult?>(
  LoadController.new,
  name: 'loadController',
);
