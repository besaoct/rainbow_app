import 'package:rainbow_app/core/helpers/formatters.dart';

/// The payload for `POST /guard/vehicles/gate-in`.
///
/// Built by the gate-in form and validated before it is constructed, so a
/// value of this type is always safe to send.
class GateInRequest {
  const GateInRequest({
    required this.vehicleNo,
    required this.salesOrderId,
    required this.locationId,
    required this.driverName,
    this.driverPhone,
    this.transporterName,
    this.remarks,
  });

  final String vehicleNo;
  final int salesOrderId;
  final int locationId;
  final String driverName;
  final String? driverPhone;
  final String? transporterName;
  final String? remarks;

  /// Query parameters, with the plate normalised to the spaced form the ERP
  /// stores so the same vehicle is not recorded twice under two spellings.
  Map<String, Object?> toQuery() => <String, Object?>{
    'vehicle_no': Formatters.vehicleNumber(vehicleNo),
    'sales_order_id': salesOrderId.toString(),
    'location_id': locationId.toString(),
    'driver_name': driverName.trim(),
    'driver_phone': _nullIfBlank(driverPhone),
    'transporter_name': _nullIfBlank(transporterName),
    'remarks': _nullIfBlank(remarks),
  };

  Map<String, Object?> toJson() => <String, Object?>{
    'vehicle_no': Formatters.vehicleNumber(vehicleNo),
    'sales_order_id': salesOrderId,
    'location_id': locationId,
    'driver_name': driverName.trim(),
    if (_nullIfBlank(driverPhone) != null) 'driver_phone': driverPhone!.trim(),
    if (_nullIfBlank(transporterName) != null)
      'transporter_name': transporterName!.trim(),
    if (_nullIfBlank(remarks) != null) 'remarks': remarks!.trim(),
  };

  static String? _nullIfBlank(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
