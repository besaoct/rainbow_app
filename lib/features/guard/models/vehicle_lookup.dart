import 'package:rainbow_app/core/network/api_response.dart';

/// Historical driver and transporter details for a known vehicle license plate.
///
/// Returned by `GET /guard/vehicles/lookup`.
class VehicleLookup {
  const VehicleLookup({
    required this.vehicleNo,
    this.driverName = '',
    this.driverPhone = '',
    this.transporterName = '',
    this.lastVisitAt,
  });

  factory VehicleLookup.fromJson(Map<String, Object?> json) {
    return VehicleLookup(
      vehicleNo: json.requireString('vehicle_no'),
      driverName: json.optString('driver_name') ?? '',
      driverPhone: json.optString('driver_phone') ?? '',
      transporterName: json.optString('transporter_name') ?? '',
      lastVisitAt: json.optDateTime('last_visit_at'),
    );
  }

  final String vehicleNo;
  final String driverName;
  final String driverPhone;
  final String transporterName;
  final DateTime? lastVisitAt;

  Map<String, Object?> toJson() => <String, Object?>{
    'vehicle_no': vehicleNo,
    'driver_name': driverName,
    'driver_phone': driverPhone,
    'transporter_name': transporterName,
    if (lastVisitAt != null) 'last_visit_at': lastVisitAt!.toIso8601String(),
  };
}
