import 'package:rainbow_app/core/network/api_client.dart';
import 'package:rainbow_app/core/network/api_endpoints.dart';
import 'package:rainbow_app/core/network/api_response.dart';
import 'package:rainbow_app/features/store/models/entered_vehicle.dart';
import 'package:rainbow_app/features/store/models/load_request.dart';
import 'package:rainbow_app/features/store/models/order_item.dart';

/// Every loading operation a store manager performs.
class StoreRepository {
  const StoreRepository(this._client);

  final ApiClient _client;

  /// Vehicles inside the gate, waiting to be loaded.
  Future<List<EnteredVehicle>> fetchEnteredVehicles({
    String? search,
    int? locationId,
    int page = 1,
    int perPage = 30,
  }) async {
    final ApiResponse<List<EnteredVehicle>> response = await _client
        .get<List<EnteredVehicle>>(
          ApiEndpoints.storeEnteredVehicles,
          query: <String, Object?>{
            if (search != null && search.trim().isNotEmpty)
              ApiEndpoints.qSearch: search.trim(),
            ApiEndpoints.qLocationId: ?locationId,
            ApiEndpoints.qPage: page,
            ApiEndpoints.qPerPage: perPage,
          },
          decode: (Object? data) {
            if (data is List) {
              return data
                  .whereType<Map<Object?, Object?>>()
                  .map(Map<String, Object?>.from)
                  .map(EnteredVehicle.fromJson)
                  .toList(growable: false);
            }
            final Map<String, Object?> map = asJsonMap(data);
            return map
                .optMapList('data')
                .map(EnteredVehicle.fromJson)
                .toList(growable: false);
          },
        );
    return response.data;
  }

  /// Order lines with pending quantities and current stock for a vehicle.
  Future<VehicleOrderItems> fetchOrderItems(int vehicleId) async {
    final ApiResponse<VehicleOrderItems> response = await _client
        .get<VehicleOrderItems>(
          ApiEndpoints.storeOrderItems(vehicleId),
          decode: (Object? data) => VehicleOrderItems.fromJson(asJsonMap(data)),
        );
    return response.data;
  }

  /// Records what was loaded, which moves the vehicle to the red mark and
  /// puts it in the guard's exit-clearance queue.
  Future<LoadResult> submitLoad({
    required int vehicleId,
    required LoadRequest request,
  }) async {
    final ApiResponse<LoadResult> response = await _client.post<LoadResult>(
      ApiEndpoints.storeLoad(vehicleId),
      body: request.toJson(),
      decode: (Object? data) => LoadResult.fromJson(asJsonMap(data)),
    );
    return response.data;
  }
}
