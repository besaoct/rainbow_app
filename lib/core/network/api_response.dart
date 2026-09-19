import 'package:rainbow_app/core/network/api_failure.dart';

/// A decoded Rainbow ERP response.
///
/// The API wraps every successful payload as
/// `{"success": true, "message": "…", "data": …}`. [message] is retained for
/// logging and diagnostics; user-facing confirmation text is localised in the
/// UI layer rather than taken from the wire.
final class ApiResponse<T> {
  const ApiResponse({required this.data, this.message});

  final T data;
  final String? message;
}

/// Helpers for reading loosely-typed JSON without `dynamic` calls.
///
/// The ERP sends numbers as either JSON numbers or strings depending on the
/// column type, and nullable columns as `null`, so every accessor is
/// defensive: a malformed field yields the fallback rather than crashing a
/// screen that is otherwise fine.
extension JsonMap on Map<String, Object?> {
  String? optString(String key) {
    final Object? value = this[key];
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    return value.toString();
  }

  String requireString(String key) => optString(key) ?? '';

  int? optInt(String key) {
    final Object? value = this[key];
    return switch (value) {
      final int v => v,
      final double v => v.round(),
      final String v => int.tryParse(v) ?? double.tryParse(v)?.round(),
      _ => null,
    };
  }

  int requireInt(String key) => optInt(key) ?? 0;

  double? optDouble(String key) {
    final Object? value = this[key];
    return switch (value) {
      final double v => v,
      final int v => v.toDouble(),
      final String v => double.tryParse(v),
      _ => null,
    };
  }

  double requireDouble(String key) => optDouble(key) ?? 0;

  bool optBool(String key, {bool fallback = false}) {
    final Object? value = this[key];
    return switch (value) {
      final bool v => v,
      final int v => v != 0,
      final String v => v == 'true' || v == '1',
      _ => fallback,
    };
  }

  DateTime? optDateTime(String key) {
    final String? raw = optString(key);
    if (raw == null) return null;
    // The API mixes ISO-8601 (`2026-09-19T14:09:45+05:30`) with a display
    // format (`2026-09-19 14:09`); `DateTime.tryParse` accepts both.
    return DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  }

  Map<String, Object?>? optMap(String key) {
    final Object? value = this[key];
    return value is Map ? Map<String, Object?>.from(value) : null;
  }

  List<Map<String, Object?>> optMapList(String key) {
    final Object? value = this[key];
    if (value is! List) return const <Map<String, Object?>>[];
    return value
        .whereType<Map<Object?, Object?>>()
        .map(Map<String, Object?>.from)
        .toList(growable: false);
  }

  List<String> optStringList(String key) {
    final Object? value = this[key];
    if (value is! List) return const <String>[];
    return value.map((Object? e) => e.toString()).toList(growable: false);
  }
}

/// Converts a raw decoded body into a typed model, turning a shape mismatch
/// into an [ApiFailure] rather than a `TypeError` from deep inside a widget.
Map<String, Object?> asJsonMap(Object? data) {
  if (data is Map) return Map<String, Object?>.from(data);
  throw const UnknownFailure(serverMessage: 'Expected a JSON object');
}

/// As [asJsonMap], for a list of objects.
List<Map<String, Object?>> asJsonList(Object? data) {
  if (data is List) {
    return data
        .whereType<Map<Object?, Object?>>()
        .map(Map<String, Object?>.from)
        .toList(growable: false);
  }
  throw const UnknownFailure(serverMessage: 'Expected a JSON array');
}
