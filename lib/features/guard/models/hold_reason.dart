import 'package:flutter/foundation.dart';
import 'package:rainbow_app/core/network/api_response.dart';

/// A standardized reason for holding a vehicle at the gate.
///
/// Returned by `GET /guard/hold-reasons`.
@immutable
class HoldReason {
  const HoldReason({required this.code, required this.label});

  factory HoldReason.fromJson(Map<String, Object?> json) {
    return HoldReason(
      code: json.requireString('code'),
      label: json.requireString('label'),
    );
  }

  final String code;
  final String label;

  Map<String, Object?> toJson() => <String, Object?>{
    'code': code,
    'label': label,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is HoldReason && other.code == code);

  @override
  int get hashCode => code.hashCode;
}
