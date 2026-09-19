import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/network/api_response.dart';

/// One loaded line a guard verifies against the physical load.
class InspectionItem {
  const InspectionItem({
    required this.itemId,
    required this.productName,
    required this.sku,
    required this.qtyPcs,
    required this.qtyBox,
    required this.rate,
    required this.lineTotal,
  });

  factory InspectionItem.fromJson(Map<String, Object?> json) {
    return InspectionItem(
      itemId: json.requireInt('item_id'),
      productName: json.requireString('product_name'),
      sku: json.optString('sku') ?? '',
      qtyPcs: json.requireInt('qty_pcs'),
      qtyBox: json.requireDouble('qty_box'),
      rate: json.requireDouble('rate'),
      lineTotal: json.requireDouble('line_total'),
    );
  }

  final int itemId;
  final String productName;
  final String sku;
  final int qtyPcs;
  final double qtyBox;
  final double rate;
  final double lineTotal;
}

/// What the store recorded, for the guard to check before clearing the exit.
///
/// Returned by `GET /guard/vehicles/{id}/inspection`.
class VehicleInspection {
  const VehicleInspection({
    required this.id,
    required this.gatePassNo,
    required this.vehicleNo,
    required this.status,
    required this.items,
    required this.totalPcs,
    required this.totalBoxes,
    this.driverName = '',
    this.driverPhone = '',
    this.transporterName = '',
    this.orderNo = '',
    this.customerName = '',
    this.loadedByName,
    this.loadedAt,
    this.challanNo,
    this.ewayBillNo,
    this.invoiceNo,
    this.loadingRemarks,
  });

  factory VehicleInspection.fromJson(Map<String, Object?> json) {
    return VehicleInspection(
      id: json.requireInt('id'),
      gatePassNo: json.requireString('gate_pass_no'),
      vehicleNo: json.requireString('vehicle_no'),
      status: GateEntryStatus.fromWire(
        json.optString('status') ?? json.optString('color_mark'),
      ),
      items: json
          .optMapList('items_to_verify')
          .map(InspectionItem.fromJson)
          .toList(growable: false),
      totalPcs: json.requireInt('total_pcs'),
      totalBoxes: json.requireDouble('total_boxes'),
      driverName: json.optString('driver_name') ?? '',
      driverPhone: json.optString('driver_phone') ?? '',
      transporterName: json.optString('transporter_name') ?? '',
      orderNo: json.optString('order_no') ?? '',
      customerName: json.optString('customer_name') ?? '',
      loadedByName: json.optString('loaded_by_name'),
      loadedAt: json.optDateTime('loaded_at'),
      challanNo: json.optString('challan_no'),
      ewayBillNo: json.optString('eway_bill_no'),
      invoiceNo: json.optString('invoice_no'),
      loadingRemarks: json.optString('loading_remarks'),
    );
  }

  final int id;
  final String gatePassNo;
  final String vehicleNo;
  final GateEntryStatus status;
  final List<InspectionItem> items;
  final int totalPcs;
  final double totalBoxes;
  final String driverName;
  final String driverPhone;
  final String transporterName;
  final String orderNo;
  final String customerName;
  final String? loadedByName;
  final DateTime? loadedAt;
  final String? challanNo;
  final String? ewayBillNo;
  final String? invoiceNo;
  final String? loadingRemarks;

  /// Whether the store has recorded a load. Until then there is nothing to
  /// verify and the exit cannot be cleared.
  bool get isLoaded => status.canBeCleared && items.isNotEmpty;

  /// Whether any shipping document was captured during loading.
  bool get hasDocuments =>
      (challanNo?.isNotEmpty ?? false) ||
      (ewayBillNo?.isNotEmpty ?? false) ||
      (invoiceNo?.isNotEmpty ?? false);

  /// Value of the load, used as a final sanity check at the gate.
  double get totalValue => items.fold<double>(
    0,
    (double sum, InspectionItem item) => sum + item.lineTotal,
  );
}

/// The two decisions a guard can make at the exit.
enum GateOutAction {
  approve('approve'),
  reject('reject');

  const GateOutAction(this.wireValue);

  final String wireValue;
}
