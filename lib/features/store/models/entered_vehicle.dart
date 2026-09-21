import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/network/api_response.dart';

/// A vehicle inside the gate, waiting to be loaded.
///
/// Returned by `GET /store/entered-vehicles`. It overlaps with `GateEntry`
/// but is a distinct API resource: it carries who registered the vehicle and
/// how many order lines are still pending, which is what the store team
/// prioritises by.
class EnteredVehicle {
  const EnteredVehicle({
    required this.id,
    required this.gatePassNo,
    required this.vehicleNo,
    required this.orderNo,
    required this.customerName,
    required this.status,
    required this.pendingLinesCount,
    this.driverName = '',
    this.driverPhone = '',
    this.transporterName = '',
    this.salesOrderId,
    this.locationId,
    this.locationName = '',
    this.enteredAt,
    this.enteredByName = '',
  });

  factory EnteredVehicle.fromJson(Map<String, Object?> json) {
    return EnteredVehicle(
      id: json.optInt('id') ?? json.requireInt('vehicle_id'),
      gatePassNo:
          json.optString('gate_pass_no') ??
          json.optString('gate_pass_number') ??
          '',
      vehicleNo:
          json.optString('vehicle_no') ?? json.optString('vehicle_plate') ?? '',
      orderNo:
          json.optString('order_no') ?? json.optString('order_number') ?? '',
      customerName: json.optString('customer_name') ?? '',
      status: GateEntryStatus.fromWire(
        json.optString('status') ?? json.optString('color_mark'),
      ),
      pendingLinesCount: json.optInt('pending_lines_count') ?? 0,
      driverName: json.optString('driver_name') ?? '',
      driverPhone: json.optString('driver_phone') ?? '',
      transporterName:
          json.optString('transporter_name') ??
          json.optString('transporter') ??
          '',
      salesOrderId: json.optInt('sales_order_id'),
      locationId: json.optInt('location_id'),
      locationName: json.optString('location_name') ?? '',
      enteredAt:
          json.optDateTime('entry_timestamp') ?? json.optDateTime('entered_at'),
      enteredByName: json.optString('entered_by_name') ?? '',
    );
  }

  final int id;
  final String gatePassNo;
  final String vehicleNo;
  final String orderNo;
  final String customerName;
  final GateEntryStatus status;
  final int pendingLinesCount;
  final String driverName;
  final String driverPhone;
  final String transporterName;
  final int? salesOrderId;
  final int? locationId;
  final String locationName;
  final DateTime? enteredAt;

  /// The guard who registered the gate-in.
  final String enteredByName;

  /// Whether [query] matches the vehicle, gate pass, order or customer.
  bool matches(String query) {
    if (query.isEmpty) return true;
    final String q = query.toLowerCase();
    return vehicleNo.toLowerCase().contains(q) ||
        gatePassNo.toLowerCase().contains(q) ||
        orderNo.toLowerCase().contains(q) ||
        customerName.toLowerCase().contains(q);
  }
}
