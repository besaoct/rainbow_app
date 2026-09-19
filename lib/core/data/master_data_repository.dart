import 'package:rainbow_app/core/network/api_client.dart';
import 'package:rainbow_app/core/network/api_endpoints.dart';
import 'package:rainbow_app/core/network/api_response.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';
import 'package:rainbow_app/features/guard/models/transporter.dart';
import 'package:rainbow_app/features/home/models/dashboard_summary.dart';

/// Repository for ERP master data (locations, transporters, and dashboard KPIs).
class MasterDataRepository {
  const MasterDataRepository(this._client);

  final ApiClient _client;

  /// Fetches active site and godown locations from `GET /locations`.
  Future<List<AssignedLocation>> fetchLocations({
    String? search,
    String? type,
    bool? activeOnly,
  }) async {
    final ApiResponse<List<AssignedLocation>> response = await _client
        .get<List<AssignedLocation>>(
          ApiEndpoints.locations,
          query: <String, Object?>{
            if (search != null && search.trim().isNotEmpty)
              ApiEndpoints.qSearch: search.trim(),
            if (type != null && type.trim().isNotEmpty)
              ApiEndpoints.qType: type.trim(),
            if (activeOnly != null)
              ApiEndpoints.qActiveOnly: activeOnly ? 1 : 0,
          },
          decode: (Object? data) => asJsonList(
            data,
          ).map(AssignedLocation.fromJson).toList(growable: false),
        );
    return response.data;
  }

  /// Fetches registered transporters from `GET /transporters`.
  Future<List<Transporter>> fetchTransporters({String? search}) async {
    final ApiResponse<List<Transporter>> response = await _client
        .get<List<Transporter>>(
          ApiEndpoints.transporters,
          query: <String, Object?>{
            if (search != null && search.trim().isNotEmpty)
              ApiEndpoints.qSearch: search.trim(),
          },
          decode: (Object? data) => asJsonList(
            data,
          ).map(Transporter.fromJson).toList(growable: false),
        );
    return response.data;
  }

  /// Fetches real-time operational dashboard KPIs from `GET /dashboard/summary`.
  Future<DashboardSummary> fetchDashboardSummary({int? locationId}) async {
    final ApiResponse<DashboardSummary> response = await _client
        .get<DashboardSummary>(
          ApiEndpoints.dashboardSummary,
          query: <String, Object?>{
            ApiEndpoints.qLocationId: ?locationId,
          },
          decode: (Object? data) => DashboardSummary.fromJson(asJsonMap(data)),
        );
    return response.data;
  }
}
