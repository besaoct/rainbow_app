import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/enums/user_role.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';
import 'package:rainbow_app/features/guard/models/gate_entry.dart';
import 'package:rainbow_app/features/guard/models/gate_in_request.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';
import 'package:rainbow_app/features/guard/models/vehicle_inspection.dart';
import 'package:rainbow_app/features/store/models/entered_vehicle.dart';
import 'package:rainbow_app/features/store/models/load_request.dart';
import 'package:rainbow_app/features/store/models/order_item.dart';

import '../support/fixtures.dart';

/// Reads the `data` payload out of a fixture envelope.
Map<String, Object?> _data(Map<String, Object?> envelope) =>
    Map<String, Object?>.from(envelope['data']! as Map<Object?, Object?>);

List<Map<String, Object?>> _list(Map<String, Object?> envelope) =>
    (envelope['data']! as List<Object?>)
        .map(
          (Object? e) => Map<String, Object?>.from(e! as Map<Object?, Object?>),
        )
        .toList();

void main() {
  group('AuthUser', () {
    test('parses the login payload', () {
      final AuthUser user = AuthUser.fromJson(Fixtures.guardUser);

      expect(user.id, 1);
      expect(user.name, 'System Admin');
      expect(user.assignedLocations, hasLength(1));
      expect(user.assignedLocations.first.code, 'WH-MAIN');
    });

    test('resolves both capability flags to the administrator role', () {
      expect(AuthUser.fromJson(Fixtures.guardUser).role, UserRole.admin);
    });

    test('an account with neither flag has no operations access', () {
      final AuthUser sales = AuthUser.fromJson(Fixtures.salesUser);

      expect(sales.role, UserRole.sales);
      expect(sales.role.hasOperationsAccess, isFalse);
      expect(sales.role.canOperateGate, isFalse);
      expect(sales.role.canOperateStore, isFalse);
    });

    test('builds initials from grapheme clusters, not code units', () {
      AuthUser withName(String name) => AuthUser.fromJson(<String, Object?>{
        ...Fixtures.guardUser,
        'name': name,
      });

      expect(withName('System Admin').initials, 'SA');
      expect(withName('Suresh').initials, 'S');
      expect(withName('').initials, '');
      // A Bengali name keeps its vowel sign attached to the consonant.
      expect(withName('সুরেশ পটেল').initials.isNotEmpty, isTrue);
    });

    test('survives a round trip through the secure store', () {
      final AuthUser original = AuthUser.fromJson(Fixtures.guardUser);
      final AuthUser restored = AuthUser.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.role, original.role);
      expect(restored.assignedLocations.first.id, 1);
    });
  });

  group('GateEntryStatus', () {
    test('maps every status the API sends', () {
      expect(GateEntryStatus.fromWire('entered'), GateEntryStatus.entered);
      expect(GateEntryStatus.fromWire('loaded'), GateEntryStatus.loaded);
      expect(GateEntryStatus.fromWire('cleared'), GateEntryStatus.cleared);
      expect(GateEntryStatus.fromWire('rejected'), GateEntryStatus.held);
    });

    test('also accepts the colour mark, for older payloads', () {
      expect(GateEntryStatus.fromWire('orange'), GateEntryStatus.entered);
      expect(GateEntryStatus.fromWire('red'), GateEntryStatus.loaded);
      expect(GateEntryStatus.fromWire('green'), GateEntryStatus.cleared);
    });

    test('degrades to unknown rather than throwing on a new value', () {
      expect(GateEntryStatus.fromWire('teleported'), GateEntryStatus.unknown);
      expect(GateEntryStatus.fromWire(null), GateEntryStatus.unknown);
      expect(GateEntryStatus.fromWire(''), GateEntryStatus.unknown);
    });

    test('enforces the workflow order', () {
      expect(GateEntryStatus.entered.canBeLoaded, isTrue);
      expect(GateEntryStatus.entered.canBeCleared, isFalse);
      expect(GateEntryStatus.loaded.canBeCleared, isTrue);
      expect(GateEntryStatus.loaded.canBeLoaded, isFalse);
      expect(GateEntryStatus.cleared.isFinal, isTrue);
      expect(GateEntryStatus.held.isFinal, isTrue);
    });
  });

  group('GateEntry', () {
    test('parses a paginated list', () {
      final PagedResult<GateEntry> page = PagedResult<GateEntry>.fromJson(
        _data(Fixtures.guardVehicles),
        GateEntry.fromJson,
      );

      expect(page.total, 2);
      expect(page.hasMore, isFalse);
      expect(page.items.first.status, GateEntryStatus.cleared);
      expect(page.items.last.status, GateEntryStatus.held);
      expect(page.items.last.rejectionReason, 'Challan mismatch');
    });

    test('parses the API’s display timestamps', () {
      final GateEntry entry = PagedResult<GateEntry>.fromJson(
        _data(Fixtures.guardVehicles),
        GateEntry.fromJson,
      ).items.first;

      expect(entry.enteredAt, DateTime(2026, 9, 19, 14, 9));
      expect(entry.latestActivityAt, DateTime(2026, 9, 19, 14, 12));
    });

    test('merging a page appends without losing the earlier one', () {
      final PagedResult<GateEntry> first = PagedResult<GateEntry>.fromJson(
        _data(Fixtures.guardVehicles),
        GateEntry.fromJson,
      );
      final PagedResult<GateEntry> merged = first.merge(first);

      expect(merged.items, hasLength(first.items.length * 2));
    });
  });

  group('ReadyOrder', () {
    test('parses the dispatch queue', () {
      final List<ReadyOrder> orders = _list(
        Fixtures.ordersReady,
      ).map(ReadyOrder.fromJson).toList();

      expect(orders, hasLength(2));
      expect(orders.first.pendingPcs, 10);
      expect(orders.first.orderDate, DateTime(2026, 8, 18));
    });

    test('matches on order number, customer and code', () {
      final ReadyOrder order = ReadyOrder.fromJson(
        _list(Fixtures.ordersReady).first,
      );

      expect(order.matches(''), isTrue);
      expect(order.matches('786e'), isTrue);
      expect(order.matches('ambica'), isTrue);
      expect(order.matches('PTR-CUST-010'), isTrue);
      expect(order.matches('nothing'), isFalse);
    });
  });

  group('VehicleInspection', () {
    test('parses a loaded vehicle and totals its value', () {
      final VehicleInspection inspection = VehicleInspection.fromJson(
        _data(Fixtures.inspectionLoaded),
      );

      expect(inspection.status, GateEntryStatus.loaded);
      expect(inspection.isLoaded, isTrue);
      expect(inspection.hasDocuments, isTrue);
      expect(inspection.items, hasLength(1));
      expect(inspection.totalValue, 2100);
    });
  });

  group('OrderItem', () {
    test('caps the loadable quantity at the lower of pending and stock', () {
      OrderItem item({required int pending, required int stock}) =>
          OrderItem.fromJson(<String, Object?>{
            'sales_order_line_id': 1,
            'product_id': 1,
            'product_name': 'Panel',
            'pcs_per_box': 10,
            'qty_ordered_pcs': 100,
            'qty_dispatched_pcs': 0,
            'qty_pending_pcs': pending,
            'qty_pending_boxes': pending / 10,
            'current_stock_pcs': stock,
            'rate': 210,
          });

      expect(item(pending: 10, stock: 50).maxLoadablePcs, 10);
      expect(item(pending: 50, stock: 10).maxLoadablePcs, 10);
      expect(item(pending: 10, stock: 0).isLoadable, isFalse);
    });

    test('never divides by zero when a product has no box size', () {
      final OrderItem item = OrderItem.fromJson(<String, Object?>{
        'sales_order_line_id': 1,
        'product_id': 1,
        'product_name': 'Panel',
        'pcs_per_box': 0,
        'qty_ordered_pcs': 10,
        'qty_dispatched_pcs': 0,
        'qty_pending_pcs': 10,
        'qty_pending_boxes': 0,
        'current_stock_pcs': 10,
        'rate': 1,
      });

      expect(item.piecesPerBox, 1);
      expect(item.boxesFor(10), 10);
    });

    test('converts pieces to boxes', () {
      final VehicleOrderItems order = VehicleOrderItems.fromJson(
        _data(Fixtures.orderItems),
      );

      expect(order.items.first.boxesFor(10), 1.0);
      expect(order.items.first.boxesFor(2), closeTo(0.2, 1e-9));
    });
  });

  group('EnteredVehicle', () {
    test('parses the store queue', () {
      final List<EnteredVehicle> vehicles = _list(
        Fixtures.enteredVehicles,
      ).map(EnteredVehicle.fromJson).toList();

      expect(vehicles, hasLength(1));
      expect(vehicles.first.status, GateEntryStatus.entered);
      expect(vehicles.first.enteredByName, 'System Admin');
      expect(vehicles.first.pendingLinesCount, 1);
    });
  });

  group('request payloads', () {
    test('GateInRequest normalises the plate and drops blank optionals', () {
      const GateInRequest request = GateInRequest(
        vehicleNo: 'ka01zz7777',
        salesOrderId: 34,
        locationId: 1,
        driverName: '  Suresh Patel ',
        driverPhone: '   ',
        transporterName: null,
      );

      final Map<String, Object?> query = request.toQuery();

      expect(query['vehicle_no'], 'KA 01 ZZ 7777');
      expect(query['driver_name'], 'Suresh Patel');
      expect(query['driver_phone'], isNull);
      expect(query['transporter_name'], isNull);
    });

    test('LoadRequest rounds boxes to the precision the ERP stores', () {
      const LoadRequest request = LoadRequest(
        lines: <LoadLine>[
          LoadLine(salesOrderLineId: 3127, qtyPcs: 2, qtyBox: 2 / 10),
        ],
        challanNo: '  ',
      );

      final Map<String, Object?> json = request.toJson();
      final List<Object?> items = json['items']! as List<Object?>;
      final Map<String, Object?> line = items.first! as Map<String, Object?>;

      expect(line['qty_box'], 0.2);
      // A blank document number is omitted rather than sent as an empty
      // string, which the ERP would store verbatim.
      expect(json.containsKey('challan_no'), isFalse);
    });
  });
}
