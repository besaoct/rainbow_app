import 'package:rainbow_app/core/network/api_response.dart';

/// A sales order line with what is still to be dispatched and what is in
/// stock, as shown on the loading screen.
class OrderItem {
  const OrderItem({
    required this.salesOrderLineId,
    required this.productId,
    required this.productName,
    required this.sku,
    required this.piecesPerBox,
    required this.qtyOrderedPcs,
    required this.qtyDispatchedPcs,
    required this.qtyPendingPcs,
    required this.qtyPendingBoxes,
    required this.currentStockPcs,
    required this.rate,
    required this.status,
  });

  factory OrderItem.fromJson(Map<String, Object?> json) {
    return OrderItem(
      salesOrderLineId: json.requireInt('sales_order_line_id'),
      productId: json.requireInt('product_id'),
      productName: json.requireString('product_name'),
      sku: json.optString('sku') ?? '',
      // Guard against a zero so the pieces-to-boxes conversion can never
      // divide by zero on a badly configured product.
      piecesPerBox: (json.optInt('pcs_per_box') ?? 1).clamp(1, 1 << 30),
      qtyOrderedPcs: json.requireInt('qty_ordered_pcs'),
      qtyDispatchedPcs: json.requireInt('qty_dispatched_pcs'),
      qtyPendingPcs: json.requireInt('qty_pending_pcs'),
      qtyPendingBoxes: json.requireDouble('qty_pending_boxes'),
      currentStockPcs: json.requireInt('current_stock_pcs'),
      rate: json.requireDouble('rate'),
      status: json.optString('status') ?? '',
    );
  }

  final int salesOrderLineId;
  final int productId;
  final String productName;
  final String sku;
  final int piecesPerBox;
  final int qtyOrderedPcs;
  final int qtyDispatchedPcs;
  final int qtyPendingPcs;
  final double qtyPendingBoxes;
  final int currentStockPcs;
  final double rate;
  final String status;

  /// The most that may be loaded onto this vehicle for this line: never more
  /// than is pending, and never more than is physically in stock.
  int get maxLoadablePcs =>
      qtyPendingPcs < currentStockPcs ? qtyPendingPcs : currentStockPcs;

  /// Whether the line can be loaded at all.
  bool get isLoadable => maxLoadablePcs > 0;

  /// Converts a piece count to boxes, which is what the API expects
  /// alongside it.
  double boxesFor(int pieces) => pieces / piecesPerBox;
}

/// The order behind a vehicle, with its loadable lines.
///
/// Returned by `GET /store/vehicles/{id}/order-items`.
class VehicleOrderItems {
  const VehicleOrderItems({
    required this.gateEntryId,
    required this.gatePassNo,
    required this.vehicleNo,
    required this.orderId,
    required this.orderNo,
    required this.customerName,
    required this.items,
    this.driverName = '',
    this.locationId,
  });

  factory VehicleOrderItems.fromJson(Map<String, Object?> json) {
    return VehicleOrderItems(
      gateEntryId: json.requireInt('gate_entry_id'),
      gatePassNo: json.requireString('gate_pass_no'),
      vehicleNo: json.requireString('vehicle_no'),
      orderId: json.requireInt('order_id'),
      orderNo: json.requireString('order_no'),
      customerName: json.requireString('customer_name'),
      items: json
          .optMapList('items')
          .map(OrderItem.fromJson)
          .toList(growable: false),
      driverName: json.optString('driver_name') ?? '',
      locationId: json.optInt('location_id'),
    );
  }

  final int gateEntryId;
  final String gatePassNo;
  final String vehicleNo;
  final int orderId;
  final String orderNo;
  final String customerName;
  final List<OrderItem> items;
  final String driverName;
  final int? locationId;

  bool get isEmpty => items.isEmpty;
}
