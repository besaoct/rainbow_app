/// Every Rainbow ERP endpoint the app calls.
///
/// Paths are relative to `AppConfig.apiBaseUrl`.
abstract final class ApiEndpoints {
  static const String _v1 = '/api/v1';

  // --- Auth --------------------------------------------------------------
  static const String login = '$_v1/auth/login';
  static const String logout = '$_v1/auth/logout';
  static const String me = '$_v1/auth/me';

  // --- Master data -------------------------------------------------------
  static const String locations = '$_v1/locations';
  static const String locationsAssigned = '$_v1/locations/assigned';
  static const String transporters = '$_v1/transporters';

  // --- Dashboard ----------------------------------------------------------
  static const String dashboardSummary = '$_v1/dashboard/summary';

  // --- Security guard ----------------------------------------------------
  /// Confirmed sales orders with pending quantities.
  static const String guardOrdersReady = '$_v1/guard/orders-ready';

  /// Standardized hold/rejection reasons for exit clearance.
  static const String guardHoldReasons = '$_v1/guard/hold-reasons';

  /// Auto-fill lookup for vehicle license plates.
  static const String guardVehicleLookup = '$_v1/guard/vehicles/lookup';

  /// Registers a vehicle arriving outside gate (red mark).
  static const String guardVehiclesRegister = '$_v1/guard/vehicles/register';

  /// Registers a vehicle arriving at the gate (orange mark).
  static const String guardGateIn = '$_v1/guard/vehicles/gate-in';

  /// Paginated list of every gate entry.
  static const String guardVehicles = '$_v1/guard/vehicles';

  /// Complete gate pass record with timeline and shipping documents.
  static String guardVehicleDetail(int vehicleId) =>
      '$_v1/guard/vehicles/$vehicleId';

  /// Loaded items and documents to verify before clearing a vehicle.
  static String guardInspection(int vehicleId) =>
      '$_v1/guard/vehicles/$vehicleId/inspection';

  /// Approves (green mark) or holds a loaded vehicle.
  static String guardGateOut(int vehicleId) =>
      '$_v1/guard/vehicles/$vehicleId/gate-out';

  // --- Store manager -----------------------------------------------------
  /// Vehicles that are inside the gate and waiting to be loaded.
  static const String storeEnteredVehicles = '$_v1/store/entered-vehicles';

  /// Order lines with pending quantities and current stock.
  static String storeOrderItems(int vehicleId) =>
      '$_v1/store/vehicles/$vehicleId/order-items';

  /// Records what was loaded onto the vehicle (red mark).
  static String storeLoad(int vehicleId) =>
      '$_v1/store/vehicles/$vehicleId/load';

  // --- Query parameters --------------------------------------------------
  static const String qLogin = 'login';
  static const String qPassword = 'password';
  static const String qDeviceName = 'device_name';
  static const String qStatus = 'status';
  static const String qSearch = 'search';
  static const String qPage = 'page';
  static const String qPerPage = 'per_page';
  static const String qAction = 'action';
  static const String qDecision = 'decision';
  static const String qReason = 'reason';
  static const String qRejectionReason = 'rejection_reason';
  static const String qRemarks = 'remarks';
  static const String qVehicleNo = 'vehicle_no';
  static const String qSalesOrderId = 'sales_order_id';
  static const String qDriverName = 'driver_name';
  static const String qDriverPhone = 'driver_phone';
  static const String qTransporterName = 'transporter_name';
  static const String qLocationId = 'location_id';
  static const String qType = 'type';
  static const String qActiveOnly = 'active_only';
  static const String qIncludeInactive = 'include_inactive';
  static const String qChallanNo = 'challan_no';
  static const String qEwayBillNo = 'eway_bill_no';
  static const String qInvoiceNo = 'invoice_no';
}
