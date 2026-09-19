import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/network/api_client.dart';
import 'package:rainbow_app/core/network/api_endpoints.dart';
import 'package:rainbow_app/core/network/api_response.dart';
import 'package:rainbow_app/features/guard/models/gate_entry.dart';
import 'package:rainbow_app/features/guard/models/gate_in_request.dart';
import 'package:rainbow_app/features/guard/models/hold_reason.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';
import 'package:rainbow_app/features/guard/models/vehicle_gate_pass_full.dart';
import 'package:rainbow_app/features/guard/models/vehicle_inspection.dart';
import 'package:rainbow_app/features/guard/models/vehicle_lookup.dart';

/// Every gate operation a security guard performs.
class GuardRepository {
  const GuardRepository(this._client);

  final ApiClient _client;

  /// Confirmed sales orders that still have pending quantities.
  /// Supports optional search query, location filter, and pagination.
  Future<List<ReadyOrder>> fetchReadyOrders({
    String? search,
    int? locationId,
    int page = 1,
    int perPage = 30,
  }) async {
    final ApiResponse<List<ReadyOrder>> response = await _client
        .get<List<ReadyOrder>>(
          ApiEndpoints.guardOrdersReady,
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
                  .map(ReadyOrder.fromJson)
                  .toList(growable: false);
            }
            final Map<String, Object?> map = asJsonMap(data);
            return map
                .optMapList('data')
                .map(ReadyOrder.fromJson)
                .toList(growable: false);
          },
        );
    return response.data;
  }

  /// Looks up vehicle history and driver details by license plate.
  Future<VehicleLookup?> lookupVehicle(String vehicleNo) async {
    final ApiResponse<VehicleLookup?> response = await _client
        .get<VehicleLookup?>(
          ApiEndpoints.guardVehicleLookup,
          query: <String, Object?>{
            ApiEndpoints.qVehicleNo: Formatters.vehicleNumber(vehicleNo),
          },
          decode: (Object? data) {
            if (data == null) return null;
            if (data is Map) {
              final Map<String, Object?> map = Map<String, Object?>.from(data);
              if (map.optBool('found') == false) return null;
              final Map<String, Object?>? inner = map.optMap('data');
              if (inner != null) return VehicleLookup.fromJson(inner);
              return VehicleLookup.fromJson(map);
            }
            return null;
          },
        );
    return response.data;
  }

  /// Lists standardized hold/rejection reasons for exit clearance.
  Future<List<HoldReason>> fetchHoldReasons() async {
    final ApiResponse<List<HoldReason>> response = await _client
        .get<List<HoldReason>>(
          ApiEndpoints.guardHoldReasons,
          decode: (Object? data) => asJsonList(
            data,
          ).map(HoldReason.fromJson).toList(growable: false),
        );
    return response.data;
  }

  /// Registers an arriving vehicle and issues a gate pass (orange mark).
  Future<GateEntry> registerGateIn(GateInRequest request) async {
    final ApiResponse<GateEntry> response = await _client.post<GateEntry>(
      ApiEndpoints.guardGateIn,
      query: request.toQuery(),
      body: request.toJson(),
      decode: (Object? data) => GateEntry.fromJson(asJsonMap(data)),
    );
    return response.data;
  }

  /// One page of gate entries, newest first.
  ///
  /// [status] and [query] are applied server-side so the guard's filter works
  /// across the whole history rather than only the loaded page.
  Future<PagedResult<GateEntry>> fetchVehicles({
    GateEntryStatus? status,
    String? query,
    int? locationId,
    int page = 1,
  }) async {
    final ApiResponse<PagedResult<GateEntry>> response = await _client
        .get<PagedResult<GateEntry>>(
          ApiEndpoints.guardVehicles,
          query: <String, Object?>{
            if (status != null) ApiEndpoints.qStatus: status.wireValue,
            if (query != null && query.trim().isNotEmpty)
              ApiEndpoints.qSearch: query.trim(),
            ApiEndpoints.qLocationId: ?locationId,
            ApiEndpoints.qPage: page,
          },
          decode: (Object? data) => PagedResult<GateEntry>.fromJson(
            asJsonMap(data),
            GateEntry.fromJson,
          ),
        );
    return response.data;
  }

  /// The most recent entries, for the dashboard summary.
  Future<List<GateEntry>> fetchRecentVehicles() async {
    final PagedResult<GateEntry> page = await fetchVehicles();
    return page.items
        .take(AppConstants.dashboardPreviewCount)
        .toList(growable: false);
  }

  /// Complete gate pass record with timeline and shipping documents.
  Future<VehicleGatePassFull> fetchVehicleGatePassFull(int vehicleId) async {
    final ApiResponse<VehicleGatePassFull> response = await _client
        .get<VehicleGatePassFull>(
          ApiEndpoints.guardVehicleDetail(vehicleId),
          decode: (Object? data) =>
              VehicleGatePassFull.fromJson(asJsonMap(data)),
        );
    return response.data;
  }

  /// What the store loaded, for verification before the exit is cleared.
  Future<VehicleInspection> fetchInspection(int vehicleId) async {
    final ApiResponse<VehicleInspection> response = await _client
        .get<VehicleInspection>(
          ApiEndpoints.guardInspection(vehicleId),
          decode: (Object? data) => VehicleInspection.fromJson(asJsonMap(data)),
        );
    return response.data;
  }

  /// Clears the vehicle to leave (green mark) or holds it with a reason.
  ///
  /// The server rejects this with a `ValidationFailure` when the vehicle is
  /// not in `loaded` status, which is the guard's signal that the store has
  /// not finished.
  Future<GateEntry> submitGateOut({
    required int vehicleId,
    required GateOutAction action,
    String? reason,
    String? remarks,
    String? challanNo,
    String? ewayBillNo,
    String? invoiceNo,
  }) async {
    final String decision =
        action == GateOutAction.approve ? 'cleared' : 'rejected';
    final Map<String, Object?> payload = <String, Object?>{
      ApiEndpoints.qAction: action.wireValue,
      ApiEndpoints.qDecision: decision,
      if (reason != null && reason.trim().isNotEmpty) ...<String, Object?>{
        ApiEndpoints.qReason: reason.trim(),
        ApiEndpoints.qRejectionReason: reason.trim(),
      },
      if (remarks != null && remarks.trim().isNotEmpty)
        ApiEndpoints.qRemarks: remarks.trim(),
      if (challanNo != null && challanNo.trim().isNotEmpty)
        ApiEndpoints.qChallanNo: challanNo.trim(),
      if (ewayBillNo != null && ewayBillNo.trim().isNotEmpty)
        ApiEndpoints.qEwayBillNo: ewayBillNo.trim(),
      if (invoiceNo != null && invoiceNo.trim().isNotEmpty)
        ApiEndpoints.qInvoiceNo: invoiceNo.trim(),
    };

    final ApiResponse<GateEntry> response = await _client.post<GateEntry>(
      ApiEndpoints.guardGateOut(vehicleId),
      query: payload,
      body: payload,
      decode: (Object? data) => GateEntry.fromJson(asJsonMap(data)),
    );
    return response.data;
  }
}
