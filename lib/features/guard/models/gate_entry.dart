import 'package:flutter/foundation.dart';

import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/network/api_response.dart';

/// A vehicle's journey through the gate, from registration to exit.
///
/// Returned by `GET /guard/vehicles` and by the gate-in and gate-out calls.
@immutable
class GateEntry {
  const GateEntry({
    required this.id,
    required this.gatePassNo,
    required this.vehicleNo,
    required this.status,
    this.driverName = '',
    this.driverPhone = '',
    this.transporterName = '',
    this.salesOrderId,
    this.orderNo = '',
    this.customerName = '',
    this.locationName = '',
    this.registeredAt,
    this.enteredAt,
    this.loadedAt,
    this.clearedAt,
    this.rejectionReason,
  });

  factory GateEntry.fromJson(Map<String, Object?> json) {
    return GateEntry(
      id: json.requireInt('id'),
      gatePassNo: json.requireString('gate_pass_no'),
      vehicleNo: json.requireString('vehicle_no'),
      // Prefer `status`; the mark is a presentation of the same state and is
      // used only when an older build omits the status field.
      status: GateEntryStatus.fromWire(
        json.optString('status') ?? json.optString('color_mark'),
      ),
      driverName: json.optString('driver_name') ?? '',
      driverPhone: json.optString('driver_phone') ?? '',
      transporterName: json.optString('transporter_name') ?? '',
      salesOrderId: json.optInt('sales_order_id'),
      orderNo: json.optString('order_no') ?? '',
      customerName: json.optString('customer_name') ?? '',
      locationName: json.optString('location_name') ?? '',
      registeredAt: json.optDateTime('registered_at'),
      enteredAt: json.optDateTime('entered_at'),
      loadedAt: json.optDateTime('loaded_at'),
      clearedAt: json.optDateTime('cleared_at'),
      rejectionReason: json.optString('rejection_reason'),
    );
  }

  final int id;
  final String gatePassNo;
  final String vehicleNo;
  final GateEntryStatus status;
  final String driverName;
  final String driverPhone;
  final String transporterName;
  final int? salesOrderId;
  final String orderNo;
  final String customerName;
  final String locationName;
  final DateTime? registeredAt;
  final DateTime? enteredAt;
  final DateTime? loadedAt;
  final DateTime? clearedAt;

  /// Why the vehicle was held, when [status] is `held`.
  final String? rejectionReason;

  /// The most recent timestamp in the workflow, used to order the list and to
  /// label the row with the one time that matters right now.
  DateTime? get latestActivityAt =>
      clearedAt ?? loadedAt ?? enteredAt ?? registeredAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GateEntry && other.id == id && other.status == status);

  @override
  int get hashCode => Object.hash(id, status);
}

/// One page of a Laravel paginator.
class PagedResult<T> {
  const PagedResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  /// Reads Laravel's paginator envelope: `{data: [...], current_page, ...}`
  /// or OpenAPI format with nested `{data: [...], pagination: {current_page, ...}}`.
  factory PagedResult.fromJson(
    Map<String, Object?> json,
    T Function(Map<String, Object?>) itemFromJson,
  ) {
    final Map<String, Object?>? pagination = json.optMap('pagination');
    return PagedResult<T>(
      items: json.optMapList('data').map(itemFromJson).toList(growable: false),
      currentPage: pagination?.optInt('current_page') ??
          json.optInt('current_page') ??
          1,
      lastPage: pagination?.optInt('last_page') ??
          json.optInt('last_page') ??
          1,
      total: pagination?.optInt('total') ??
          json.optInt('total') ??
          0,
    );
  }

  const PagedResult.empty()
    : items = const <Never>[],
      currentPage = 1,
      lastPage = 1,
      total = 0;

  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;

  bool get hasMore => currentPage < lastPage;

  /// Appends the next page's items, preserving order.
  PagedResult<T> merge(PagedResult<T> next) => PagedResult<T>(
    items: <T>[...items, ...next.items],
    currentPage: next.currentPage,
    lastPage: next.lastPage,
    total: next.total,
  );
}
