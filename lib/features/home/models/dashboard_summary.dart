import 'package:rainbow_app/core/network/api_response.dart';

/// Real-time operational KPI counts from `GET /dashboard/summary`.
class DashboardSummary {
  const DashboardSummary({
    this.readyOrdersCount = 0,
    this.vehiclesInsideGateCount = 0,
    this.loadedVehiclesCount = 0,
    this.clearedTodayCount = 0,
    this.heldCount = 0,
  });

  factory DashboardSummary.fromJson(Map<String, Object?> json) {
    return DashboardSummary(
      readyOrdersCount: json.optInt('ready_orders_count') ?? 0,
      vehiclesInsideGateCount:
          json.optInt('vehicles_inside_gate_count') ??
          json.optInt('inside_gate_count') ??
          0,
      loadedVehiclesCount: json.optInt('loaded_vehicles_count') ?? 0,
      clearedTodayCount: json.optInt('cleared_today_count') ?? 0,
      heldCount:
          json.optInt('held_count') ?? json.optInt('held_vehicles_count') ?? 0,
    );
  }

  final int readyOrdersCount;
  final int vehiclesInsideGateCount;
  final int loadedVehiclesCount;
  final int clearedTodayCount;
  final int heldCount;
}
