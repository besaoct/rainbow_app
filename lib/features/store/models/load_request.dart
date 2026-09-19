/// One line being loaded onto a vehicle.
class LoadLine {
  const LoadLine({
    required this.salesOrderLineId,
    required this.qtyPcs,
    required this.qtyBox,
  });

  final int salesOrderLineId;
  final int qtyPcs;
  final double qtyBox;

  Map<String, Object?> toJson() => <String, Object?>{
    'sales_order_line_id': salesOrderLineId,
    'qty_pcs': qtyPcs,
    // Two decimals matches what the ERP stores; sending the full binary
    // expansion of, say, 2/10 would be rejected as over-precise.
    'qty_box': double.parse(qtyBox.toStringAsFixed(2)),
  };
}

/// The payload for `POST /store/vehicles/{id}/load`.
class LoadRequest {
  const LoadRequest({
    required this.lines,
    this.challanNo,
    this.ewayBillNo,
    this.invoiceNo,
    this.remarks,
  });

  /// Only lines with a quantity greater than zero.
  final List<LoadLine> lines;

  final String? challanNo;
  final String? ewayBillNo;
  final String? invoiceNo;
  final String? remarks;

  bool get isEmpty => lines.isEmpty;

  Map<String, Object?> toJson() => <String, Object?>{
    'items': lines.map((LoadLine l) => l.toJson()).toList(growable: false),
    if (_present(challanNo)) 'challan_no': challanNo!.trim(),
    if (_present(ewayBillNo)) 'eway_bill_no': ewayBillNo!.trim(),
    if (_present(invoiceNo)) 'invoice_no': invoiceNo!.trim(),
    if (_present(remarks)) 'remarks': remarks!.trim(),
  };

  static bool _present(String? value) => (value?.trim() ?? '').isNotEmpty;
}

/// The server's confirmation that a vehicle was loaded.
class LoadResult {
  const LoadResult({
    required this.vehicleNo,
    required this.gatePassNo,
    required this.loadedItemsCount,
    required this.totalLoadedPcs,
  });

  factory LoadResult.fromJson(Map<String, Object?> json) {
    return LoadResult(
      vehicleNo: json['vehicle_no']?.toString() ?? '',
      gatePassNo: json['gate_pass_no']?.toString() ?? '',
      loadedItemsCount:
          int.tryParse(json['loaded_items_count']?.toString() ?? '') ?? 0,
      totalLoadedPcs:
          int.tryParse(json['total_loaded_pcs']?.toString() ?? '') ?? 0,
    );
  }

  final String vehicleNo;
  final String gatePassNo;
  final int loadedItemsCount;
  final int totalLoadedPcs;
}
