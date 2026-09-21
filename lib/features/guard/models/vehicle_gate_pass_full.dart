import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/network/api_response.dart';
import 'package:rainbow_app/features/guard/models/vehicle_inspection.dart';

/// One activity step in the vehicle's gate journey.
class ActivityTimelineItem {
  const ActivityTimelineItem({
    required this.action,
    required this.title,
    required this.colorMark,
    this.timestamp,
    this.userName = '',
    this.remarks,
  });

  factory ActivityTimelineItem.fromJson(Map<String, Object?> json) {
    return ActivityTimelineItem(
      action: json.optString('action') ?? '',
      title: json.optString('title') ?? '',
      colorMark: json.optString('color_mark') ?? '',
      timestamp: json.optDateTime('timestamp'),
      userName: json.optString('user_name') ?? '',
      remarks: json.optString('remarks'),
    );
  }

  final String action;
  final String title;
  final String colorMark;
  final DateTime? timestamp;
  final String userName;
  final String? remarks;
}

/// Shipping and tax documents associated with the loaded dispatch.
class ShippingDocuments {
  const ShippingDocuments({this.challanNo, this.ewayBillNo, this.invoiceNo});

  factory ShippingDocuments.fromJson(Map<String, Object?> json) {
    return ShippingDocuments(
      challanNo: json.optString('challan_no'),
      ewayBillNo: json.optString('eway_bill_no'),
      invoiceNo: json.optString('invoice_no'),
    );
  }

  final String? challanNo;
  final String? ewayBillNo;
  final String? invoiceNo;

  bool get hasAny =>
      (challanNo?.isNotEmpty ?? false) ||
      (ewayBillNo?.isNotEmpty ?? false) ||
      (invoiceNo?.isNotEmpty ?? false);
}

/// Complete vehicle gate pass record including timeline, shipping documents,
/// loaded items, and PDF gate pass download link.
///
/// Returned by `GET /guard/vehicles/{id}`.
class VehicleGatePassFull {
  const VehicleGatePassFull({
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
    this.customerCode = '',
    this.locationName = '',
    this.locationCode = '',
    this.pdfUrl,
    this.shippingDocuments = const ShippingDocuments(),
    this.items = const <InspectionItem>[],
    this.timeline = const <ActivityTimelineItem>[],
    this.registeredAt,
    this.enteredAt,
    this.loadedAt,
    this.clearedAt,
    this.rejectedAt,
    this.rejectionReason,
    this.dispatchNo,
  });

  factory VehicleGatePassFull.fromJson(Map<String, Object?> json) {
    final Map<String, Object?>? docsJson = json.optMap('shipping_documents');
    final Map<String, Object?>? locationJson = json.optMap('location');
    final Map<String, Object?>? orderJson = json.optMap('sales_order');

    return VehicleGatePassFull(
      id: json.requireInt('id'),
      gatePassNo:
          json.optString('gate_pass_no') ??
          json.optString('gate_pass_number') ??
          '',
      vehicleNo:
          json.optString('vehicle_no') ?? json.optString('vehicle_plate') ?? '',
      status: GateEntryStatus.fromWire(
        json.optString('status') ?? json.optString('color_mark'),
      ),
      driverName: json.optString('driver_name') ?? '',
      driverPhone: json.optString('driver_phone') ?? '',
      transporterName:
          json.optString('transporter_name') ??
          json.optString('transporter') ??
          '',
      salesOrderId: json.optInt('sales_order_id') ?? orderJson?.optInt('id'),
      orderNo:
          json.optString('order_no') ?? orderJson?.optString('order_no') ?? '',
      customerName:
          json.optString('customer_name') ??
          orderJson?.optString('customer_name') ??
          '',
      customerCode: orderJson?.optString('customer_code') ?? '',
      locationName:
          json.optString('location_name') ??
          locationJson?.optString('name') ??
          '',
      locationCode: locationJson?.optString('code') ?? '',
      pdfUrl: json.optString('pdf_url') ?? json.optString('gate_pass_pdf_url'),
      shippingDocuments: docsJson != null
          ? ShippingDocuments.fromJson(docsJson)
          : ShippingDocuments(
              challanNo: json.optString('challan_no'),
              ewayBillNo: json.optString('eway_bill_no'),
              invoiceNo: json.optString('invoice_no'),
            ),
      items:
          (json.optMapList('loaded_items').isNotEmpty
                  ? json.optMapList('loaded_items')
                  : json.optMapList('items'))
              .map(InspectionItem.fromJson)
              .toList(growable: false),
      timeline:
          (json.optMapList('activity_timeline').isNotEmpty
                  ? json.optMapList('activity_timeline')
                  : json.optMapList('timeline'))
              .map(ActivityTimelineItem.fromJson)
              .toList(growable: false),
      registeredAt: json.optDateTime('registered_at'),
      enteredAt: json.optDateTime('entered_at'),
      loadedAt: json.optDateTime('loaded_at'),
      clearedAt: json.optDateTime('cleared_at'),
      rejectedAt: json.optDateTime('rejected_at'),
      rejectionReason: json.optString('rejection_reason'),
      dispatchNo: json.optString('dispatch_no'),
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
  final String customerCode;
  final String locationName;
  final String locationCode;
  final String? pdfUrl;
  final ShippingDocuments shippingDocuments;
  final List<InspectionItem> items;
  final List<ActivityTimelineItem> timeline;
  final DateTime? registeredAt;
  final DateTime? enteredAt;
  final DateTime? loadedAt;
  final DateTime? clearedAt;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final String? dispatchNo;
}
