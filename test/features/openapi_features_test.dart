import 'package:flutter_test/flutter_test.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';
import 'package:rainbow_app/features/guard/models/gate_entry.dart';
import 'package:rainbow_app/features/guard/models/hold_reason.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';
import 'package:rainbow_app/features/guard/models/transporter.dart';
import 'package:rainbow_app/features/guard/models/vehicle_gate_pass_full.dart';
import 'package:rainbow_app/features/guard/models/vehicle_lookup.dart';
import 'package:rainbow_app/features/home/models/dashboard_summary.dart';
import 'package:rainbow_app/features/store/models/entered_vehicle.dart';

void main() {
  group('OpenAPI 3.0.3 Models Deserialization', () {
    test('Transporter parses OpenAPI schema', () {
      final Transporter transporter = Transporter.fromJson(
        const <String, Object?>{
          'id': 101,
          'name': 'V-Trans India Ltd',
          'code': 'VTR',
        },
      );
      expect(transporter.id, 101);
      expect(transporter.name, 'V-Trans India Ltd');
      expect(transporter.code, 'VTR');
    });

    test('HoldReason parses OpenAPI schema', () {
      final HoldReason reason = HoldReason.fromJson(const <String, Object?>{
        'code': 'quantity_mismatch',
        'label': 'Quantity Mismatch with Invoice',
      });
      expect(reason.code, 'quantity_mismatch');
      expect(reason.label, 'Quantity Mismatch with Invoice');
    });

    test('VehicleLookup parses OpenAPI schema', () {
      final VehicleLookup lookup = VehicleLookup.fromJson(<String, Object?>{
        'vehicle_no': 'AS-11-CC-1234',
        'driver_name': 'Mahesh Kumar',
        'driver_phone': '+91 89999 22333',
        'transporter_name': 'Speed Cargo',
        'last_visit_at': '2026-09-15T11:30:00Z',
      });
      expect(lookup.vehicleNo, 'AS-11-CC-1234');
      expect(lookup.driverName, 'Mahesh Kumar');
      expect(lookup.driverPhone, '+91 89999 22333');
      expect(lookup.transporterName, 'Speed Cargo');
      expect(lookup.lastVisitAt?.year, 2026);
    });

    test('DashboardSummary parses OpenAPI schema', () {
      final DashboardSummary summary =
          DashboardSummary.fromJson(<String, Object?>{
            'ready_orders_count': 30,
            'vehicles_inside_gate_count': 4,
            'loaded_vehicles_count': 2,
            'cleared_today_count': 8,
            'held_count': 1,
          });
      expect(summary.readyOrdersCount, 30);
      expect(summary.vehiclesInsideGateCount, 4);
      expect(summary.loadedVehiclesCount, 2);
      expect(summary.clearedTodayCount, 8);
      expect(summary.heldCount, 1);
    });

    test('VehicleGatePassFull parses complete audit trail and documents', () {
      final VehicleGatePassFull
      pass = VehicleGatePassFull.fromJson(<String, Object?>{
        'id': 5,
        'gate_pass_no': 'GP-20260915-0003',
        'vehicle_no': 'GJ 05 BX 2343',
        'driver_name': 'Mahesh Kumar',
        'driver_phone': '+91 89999 22333',
        'transporter_name': 'Speed Cargo',
        'sales_order_id': 1,
        'status': 'entered',
        'color_mark': 'orange',
        'pdf_url':
            'https://indigo-parrot-908857.hostingersite.com/gate-passes/5/print',
        'shipping_documents': <String, Object?>{
          'challan_no': 'CH-20260814-2',
          'eway_bill_no': 'HH-893534895',
          'invoice_no': 'INV-5345345',
        },
        'activity_timeline': <Map<String, Object?>>[
          <String, Object?>{
            'action': 'entered',
            'title': 'Gate-In Completed',
            'color_mark': 'orange',
            'timestamp': '2026-09-15T10:00:00Z',
            'user_name': 'Main Gate Security Guard',
          },
        ],
        'loaded_items': <Map<String, Object?>>[
          <String, Object?>{
            'item_id': 33,
            'product_name': '12FT Panel Design 6002',
            'sku': 'PVC-6002-12FT',
            'qty_pcs': 100,
            'qty_box': 10.0,
            'rate': 290.50,
            'line_total': 29050.0,
          },
        ],
      });

      expect(pass.id, 5);
      expect(pass.gatePassNo, 'GP-20260915-0003');
      expect(pass.shippingDocuments.hasAny, isTrue);
      expect(pass.shippingDocuments.challanNo, 'CH-20260814-2');
      expect(pass.timeline.length, 1);
      expect(pass.timeline.first.title, 'Gate-In Completed');
      expect(pass.items.length, 1);
      expect(pass.items.first.productName, '12FT Panel Design 6002');
      expect(pass.pdfUrl, isNotNull);
    });

    test('PagedResult supports nested pagination object from OpenAPI', () {
      final PagedResult<ReadyOrder> paged = PagedResult<ReadyOrder>.fromJson(
        <String, Object?>{
          'data': <Map<String, Object?>>[
            <String, Object?>{
              'order_id': 1,
              'order_number': 'SO-MIG-2026-002',
              'customer_name': 'Metro Decorators',
              'customer_code': 'PTR-CUST-002',
              'location_id': 1,
              'location_name': 'Central Plant',
              'total_lines': 4,
              'pending_pieces': 600.0,
            },
          ],
          'pagination': <String, Object?>{
            'current_page': 2,
            'last_page': 5,
            'per_page': 15,
            'total': 75,
          },
        },
        ReadyOrder.fromJson,
      );

      expect(paged.items.length, 1);
      expect(paged.items.first.id, 1);
      expect(paged.items.first.orderNo, 'SO-MIG-2026-002');
      expect(paged.items.first.pendingPcs, 600);
      expect(paged.currentPage, 2);
      expect(paged.lastPage, 5);
      expect(paged.total, 75);
      expect(paged.hasMore, isTrue);
    });

    test(
      'EnteredVehicle handles OpenAPI StoreEnteredVehicle schema fields',
      () {
        final EnteredVehicle vehicle =
            EnteredVehicle.fromJson(<String, Object?>{
              'id': 2,
              'vehicle_id': 2,
              'gate_pass_number': 'GP-20260919-0001',
              'vehicle_plate': 'AS-11-CC-9988',
              'order_number': 'SO-2026-0012',
              'customer_name': 'Acme Interiors',
              'status': 'entered',
              'pending_lines_count': 3,
              'transporter': 'SS Transporter',
              'entry_timestamp': '2026-09-19T14:30:00Z',
            });

        expect(vehicle.id, 2);
        expect(vehicle.gatePassNo, 'GP-20260919-0001');
        expect(vehicle.vehicleNo, 'AS-11-CC-9988');
        expect(vehicle.orderNo, 'SO-2026-0012');
        expect(vehicle.transporterName, 'SS Transporter');
        expect(vehicle.pendingLinesCount, 3);
        expect(vehicle.enteredAt?.year, 2026);
      },
    );

    test(
      'AssignedLocation handles OpenAPI Location schema with type and address',
      () {
        final AssignedLocation location =
            AssignedLocation.fromJson(const <String, Object?>{
              'id': 1,
              'code': 'FAC-MAIN',
              'name': 'Central Manufacturing Plant',
              'type': 'factory',
              'address': 'Plot 42, Industrial Area, Silchar',
              'gstin': '18AABCS1429B1Z5',
              'phone': '+91 94350 11223',
              'is_active': true,
            });

        expect(location.id, 1);
        expect(location.code, 'FAC-MAIN');
        expect(location.name, 'Central Manufacturing Plant');
        expect(location.type, 'factory');
        expect(location.address, 'Plot 42, Industrial Area, Silchar');
        expect(location.isActive, isTrue);
      },
    );
  });
}
