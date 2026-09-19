import 'package:rainbow_app/core/network/api_response.dart';

/// A confirmed sales order with quantities still to dispatch.
///
/// Returned by `GET /guard/orders-ready`; this is what a guard picks from
/// when registering an arriving vehicle.
class ReadyOrder {
  const ReadyOrder({
    required this.id,
    required this.orderNo,
    required this.customerName,
    required this.customerCode,
    required this.locationId,
    required this.locationName,
    required this.status,
    required this.totalLines,
    required this.pendingPcs,
    this.orderDate,
    this.expectedDate,
  });

  factory ReadyOrder.fromJson(Map<String, Object?> json) {
    return ReadyOrder(
      id: json.optInt('id') ?? json.requireInt('order_id'),
      orderNo: json.optString('order_no') ??
          json.requireString('order_number'),
      customerName: json.requireString('customer_name'),
      customerCode: json.optString('customer_code') ?? '',
      locationId: json.requireInt('location_id'),
      locationName: json.optString('location_name') ?? '',
      status: json.optString('status') ?? '',
      totalLines: json.optInt('total_lines') ?? 0,
      pendingPcs: json.optInt('pending_pcs') ??
          json.optDouble('pending_pieces')?.round() ??
          json.optInt('pending_pieces') ??
          0,
      orderDate: json.optDateTime('order_date'),
      expectedDate: json.optDateTime('expected_date'),
    );
  }

  final int id;
  final String orderNo;
  final String customerName;
  final String customerCode;
  final int locationId;
  final String locationName;

  /// The ERP's own status string, for example `open`.
  final String status;

  final int totalLines;
  final int pendingPcs;
  final DateTime? orderDate;
  final DateTime? expectedDate;

  /// Whether [query] matches the order number, customer or customer code.
  bool matches(String query) {
    if (query.isEmpty) return true;
    final String q = query.toLowerCase();
    return orderNo.toLowerCase().contains(q) ||
        customerName.toLowerCase().contains(q) ||
        customerCode.toLowerCase().contains(q);
  }
}
