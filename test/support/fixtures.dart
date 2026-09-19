/// Payloads captured from the Rainbow ERP development server, trimmed to the
/// fields the app reads. Keeping them verbatim means a change in the API's
/// shape shows up as a test failure rather than as a runtime null.
abstract final class Fixtures {
  static const Map<String, Object?> loginGuard = <String, Object?>{
    'success': true,
    'message': 'Login successful',
    'data': <String, Object?>{
      'token': '1|test-token',
      'token_type': 'Bearer',
      'user': guardUser,
    },
  };

  static const Map<String, Object?> guardUser = <String, Object?>{
    'id': 1,
    'name': 'System Admin',
    'email': 'admin@rainbowerp.com',
    'phone': '+91 99999 00001',
    'roles': <String>['admin'],
    'is_guard': true,
    'is_store_manager': true,
    'permissions': <String>['gate.read', 'gate.update'],
    'assigned_locations': <Map<String, Object?>>[
      <String, Object?>{
        'id': 1,
        'name': 'Main Manufacturing Plant & Central Godown',
        'code': 'WH-MAIN',
      },
    ],
  };

  static const Map<String, Object?> salesUser = <String, Object?>{
    'id': 3,
    'name': 'Sales Executive',
    'email': 'sales@rainbowerp.com',
    'phone': '+91 99999 00003',
    'roles': <String>['sales'],
    'is_guard': false,
    'is_store_manager': false,
    'permissions': <String>['orders.read'],
    'assigned_locations': <Map<String, Object?>>[],
  };

  static const Map<String, Object?> ordersReady = <String, Object?>{
    'success': true,
    'data': <Map<String, Object?>>[
      <String, Object?>{
        'id': 34,
        'order_no': 'SO-20260818-786E',
        'order_date': '2026-08-18',
        'expected_date': null,
        'customer_name': 'Ambica Interior Studio',
        'customer_code': 'PTR-CUST-010',
        'location_id': 1,
        'location_name': 'Main Manufacturing Plant & Central Godown',
        'status': 'open',
        'total_lines': 1,
        'pending_pcs': 10,
      },
      <String, Object?>{
        'id': 31,
        'order_no': 'SO-MIG-2026-001',
        'order_date': '2026-07-05',
        'expected_date': null,
        'customer_name': 'Acme Interiors & Buildcon Pvt Ltd',
        'customer_code': 'PTR-CUST-001',
        'location_id': 1,
        'location_name': 'Main Manufacturing Plant & Central Godown',
        'status': 'open',
        'total_lines': 3,
        'pending_pcs': 1000,
      },
    ],
  };

  static const Map<String, Object?> guardVehicles = <String, Object?>{
    'success': true,
    'data': <String, Object?>{
      'current_page': 1,
      'last_page': 1,
      'per_page': 30,
      'total': 2,
      'data': <Map<String, Object?>>[
        <String, Object?>{
          'id': 1,
          'gate_pass_no': 'GP-20260919-0001',
          'vehicle_no': 'KA 01 ZZ 7777',
          'driver_name': 'Suresh Patel',
          'driver_phone': '+91 91234 56789',
          'transporter_name': 'Fast Express Cargo',
          'sales_order_id': 34,
          'order_no': 'SO-20260818-786E',
          'customer_name': 'Ambica Interior Studio',
          'location_name': 'Main Manufacturing Plant & Central Godown',
          'status': 'cleared',
          'color_mark': 'green',
          'color_mark_label': 'Green Mark (Cleared / Gate-Out)',
          'registered_at': '2026-09-19 14:09',
          'entered_at': '2026-09-19 14:09',
          'loaded_at': '2026-09-19 14:10',
          'cleared_at': '2026-09-19 14:12',
          'rejection_reason': null,
        },
        <String, Object?>{
          'id': 2,
          'gate_pass_no': 'GP-20260919-0002',
          'vehicle_no': 'GJ 05 AB 1234',
          'driver_name': 'Ramesh K',
          'driver_phone': '+91 90000 11111',
          'transporter_name': 'Blue Dart',
          'sales_order_id': 32,
          'order_no': 'SO-MIG-2026-002',
          'customer_name': 'Metro Decorators & Traders',
          'location_name': 'Main Manufacturing Plant & Central Godown',
          'status': 'rejected',
          'color_mark': 'rejected',
          'color_mark_label': 'Issue / Held',
          'registered_at': '2026-09-19 14:10',
          'entered_at': '2026-09-19 14:10',
          'loaded_at': '2026-09-19 14:10',
          'cleared_at': null,
          'rejection_reason': 'Challan mismatch',
        },
      ],
    },
  };

  static const Map<String, Object?> inspectionLoaded = <String, Object?>{
    'success': true,
    'data': <String, Object?>{
      'id': 1,
      'gate_pass_no': 'GP-20260919-0001',
      'vehicle_no': 'KA 01 ZZ 7777',
      'driver_name': 'Suresh Patel',
      'driver_phone': '+91 91234 56789',
      'transporter_name': 'Fast Express Cargo',
      'order_no': 'SO-20260818-786E',
      'customer_name': 'Ambica Interior Studio',
      'status': 'loaded',
      'color_mark': 'red',
      'color_mark_label': 'Red Mark (Loaded / Pending Clearance)',
      'loaded_by_name': 'System Admin',
      'loaded_at': '2026-09-19 14:10',
      'challan_no': 'CH-2026-901',
      'eway_bill_no': 'EWB-8877665544',
      'invoice_no': 'INV-2026-102',
      'loading_remarks': 'All items loaded.',
      'items_to_verify': <Map<String, Object?>>[
        <String, Object?>{
          'item_id': 1,
          'product_name': '10FT Panel Design 6197',
          'sku': '10FT-6197',
          'qty_pcs': 10,
          'qty_box': 1,
          'rate': 210,
          'line_total': 2100,
        },
      ],
      'total_pcs': 10,
      'total_boxes': 1,
    },
  };

  static const Map<String, Object?> enteredVehicles = <String, Object?>{
    'success': true,
    'data': <Map<String, Object?>>[
      <String, Object?>{
        'id': 1,
        'gate_pass_no': 'GP-20260919-0001',
        'vehicle_no': 'KA 01 ZZ 7777',
        'driver_name': 'Suresh Patel',
        'driver_phone': '+91 91234 56789',
        'transporter_name': 'Fast Express Cargo',
        'sales_order_id': 34,
        'order_no': 'SO-20260818-786E',
        'customer_name': 'Ambica Interior Studio',
        'location_id': 1,
        'location_name': 'Main Manufacturing Plant & Central Godown',
        'status': 'entered',
        'color_mark': 'orange',
        'color_mark_label': 'Orange Mark (Entered / Gate-In)',
        'entered_at': '2026-09-19 14:09',
        'entered_by_name': 'System Admin',
        'pending_lines_count': 1,
      },
    ],
  };

  static const Map<String, Object?> orderItems = <String, Object?>{
    'success': true,
    'data': <String, Object?>{
      'gate_entry_id': 1,
      'gate_pass_no': 'GP-20260919-0001',
      'vehicle_no': 'KA 01 ZZ 7777',
      'driver_name': 'Suresh Patel',
      'order_id': 34,
      'order_no': 'SO-20260818-786E',
      'customer_name': 'Ambica Interior Studio',
      'location_id': 1,
      'items': <Map<String, Object?>>[
        <String, Object?>{
          'sales_order_line_id': 3127,
          'product_id': 548,
          'product_name': '10FT Panel Design 6197',
          'sku': '10FT-6197',
          'pcs_per_box': 10,
          'qty_ordered_pcs': 10,
          'qty_dispatched_pcs': 0,
          'qty_pending_pcs': 10,
          'qty_pending_boxes': 1,
          'current_stock_pcs': 36,
          'rate': 210,
          'status': 'pending',
        },
      ],
    },
  };

  static const Map<String, Object?> gateInCreated = <String, Object?>{
    'success': true,
    'message': 'Vehicle KA 01 ZZ 7777 registered and marked as Entered.',
    'data': <String, Object?>{
      'id': 1,
      'gate_pass_no': 'GP-20260919-0001',
      'vehicle_no': 'KA 01 ZZ 7777',
      'status': 'entered',
      'color_mark': 'orange',
    },
  };

  static const Map<String, Object?> validationError = <String, Object?>{
    'message': 'The vehicle no field is required. (and 1 more error)',
    'errors': <String, Object?>{
      'vehicle_no': <String>['The vehicle no field is required.'],
      'sales_order_id': <String>['The sales order id field is required.'],
    },
  };

  static const Map<String, Object?> workflowError = <String, Object?>{
    'success': false,
    'message':
        "Vehicle must be in 'loaded' status for security exit clearance "
        '(current status: entered).',
  };

  static const Map<String, Object?> unauthorized = <String, Object?>{
    'success': false,
    'message': 'The provided credentials do not match our records.',
  };
}
