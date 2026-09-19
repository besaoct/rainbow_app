import 'package:flutter/foundation.dart';
import 'package:rainbow_app/core/network/api_response.dart';

/// A registered transport, logistics or freight carrier.
///
/// Returned by `GET /transporters`.
@immutable
class Transporter {
  const Transporter({
    required this.id,
    required this.name,
    required this.code,
  });

  factory Transporter.fromJson(Map<String, Object?> json) {
    return Transporter(
      id: json.requireInt('id'),
      name: json.requireString('name'),
      code: json.optString('code') ?? '',
    );
  }

  final int id;
  final String name;
  final String code;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'code': code,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Transporter && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
