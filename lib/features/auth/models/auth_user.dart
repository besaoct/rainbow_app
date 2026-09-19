import 'package:characters/characters.dart';
import 'package:flutter/foundation.dart';

import 'package:rainbow_app/core/enums/user_role.dart';
import 'package:rainbow_app/core/network/api_response.dart';

/// A warehouse or plant location the account may operate at.
@immutable
class AssignedLocation {
  const AssignedLocation({
    required this.id,
    required this.name,
    required this.code,
    this.type,
    this.address,
    this.gstin,
    this.phone,
    this.isActive = true,
    this.isAssigned = true,
  });

  factory AssignedLocation.fromJson(Map<String, Object?> json) {
    return AssignedLocation(
      id: json.requireInt('id'),
      name: json.requireString('name'),
      code: json.optString('code') ?? '',
      type: json.optString('type'),
      address: json.optString('address'),
      gstin: json.optString('gstin'),
      phone: json.optString('phone'),
      isActive: json.optBool('is_active', fallback: true),
      isAssigned: json.optBool('is_assigned', fallback: true),
    );
  }

  final int id;
  final String name;

  /// Short code such as `WH-MAIN`, shown where the full name will not fit.
  final String code;

  final String? type;
  final String? address;
  final String? gstin;
  final String? phone;
  final bool isActive;
  final bool isAssigned;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'code': code,
    if (type != null) 'type': type,
    if (address != null) 'address': address,
    if (gstin != null) 'gstin': gstin,
    if (phone != null) 'phone': phone,
    'is_active': isActive,
    'is_assigned': isAssigned,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AssignedLocation && other.id == id);

  @override
  int get hashCode => id.hashCode;
}

/// The signed-in account.
@immutable
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roleNames,
    required this.isGuard,
    required this.isStoreManager,
    required this.permissions,
    required this.assignedLocations,
  });

  factory AuthUser.fromJson(Map<String, Object?> json) {
    return AuthUser(
      id: json.requireInt('id'),
      name: json.requireString('name'),
      email: json.requireString('email'),
      phone: json.optString('phone') ?? '',
      roleNames: json.optStringList('roles'),
      isGuard: json.optBool('is_guard'),
      isStoreManager: json.optBool('is_store_manager'),
      permissions: json.optStringList('permissions'),
      assignedLocations: json
          .optMapList('assigned_locations')
          .map(AssignedLocation.fromJson)
          .toList(growable: false),
    );
  }

  final int id;
  final String name;
  final String email;
  final String phone;
  final List<String> roleNames;
  final bool isGuard;
  final bool isStoreManager;
  final List<String> permissions;
  final List<AssignedLocation> assignedLocations;

  /// The operational role, resolved from the server's capability flags.
  UserRole get role => UserRole.resolve(
    isGuard: isGuard,
    isStoreManager: isStoreManager,
    roleNames: roleNames,
  );

  /// The account's initials, for the dashboard avatar.
  String get initials {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return '';
    if (parts.length == 1) return _firstGrapheme(parts.first);
    return '${_firstGrapheme(parts.first)}${_firstGrapheme(parts.last)}';
  }

  /// First user-perceived character. Uses grapheme clusters so a Bengali or
  /// Devanagari name does not lose its vowel sign to a code-unit substring.
  static String _firstGrapheme(String value) {
    if (value.isEmpty) return '';
    return value.characters.first.toUpperCase();
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'roles': roleNames,
    'is_guard': isGuard,
    'is_store_manager': isStoreManager,
    'permissions': permissions,
    'assigned_locations': assignedLocations
        .map((AssignedLocation l) => l.toJson())
        .toList(growable: false),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AuthUser && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
