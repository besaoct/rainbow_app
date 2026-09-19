import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

/// Form validation, kept out of widgets so the rules can be unit-tested and
/// reused. Every message is resolved from [AppLocalizations].
abstract final class Validators {
  // Deliberately permissive: the goal is to catch typos, not to re-implement
  // RFC 5322. The server is the authority on whether an account exists.
  static final RegExp _email = RegExp(
    r'^[\w.!#$%&*+/=?^`{|}~-]+@[\w-]+(\.[\w-]+)+$',
  );

  // Indian registration plates in their common spacings, plus the older
  // series and BH-series formats. Case and spacing are normalised first.
  static final RegExp _vehicleNumber = RegExp(
    r'^[A-Z]{2}[0-9]{1,2}[A-Z]{0,3}[0-9]{4}$',
  );

  static final RegExp _phone = RegExp(r'^\+?[0-9]{7,15}$');

  static String? email(String? value, AppLocalizations l10n) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty) return l10n.validationEmailRequired;
    if (!_email.hasMatch(input)) return l10n.validationEmailInvalid;
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    final String input = value ?? '';
    if (input.isEmpty) return l10n.validationPasswordRequired;
    if (input.length < AppConstants.minPasswordLength) {
      return l10n.validationMinLength(AppConstants.minPasswordLength);
    }
    return null;
  }

  static String? required(String? value, AppLocalizations l10n) {
    if ((value?.trim() ?? '').isEmpty) return l10n.validationRequired;
    return null;
  }

  static String? vehicleNumber(String? value, AppLocalizations l10n) {
    final String input = normalizeVehicleNumber(value ?? '');
    if (input.isEmpty) return l10n.validationVehicleNumberRequired;
    if (!_vehicleNumber.hasMatch(input)) {
      return l10n.validationVehicleNumberInvalid;
    }
    return null;
  }

  static String? driverName(String? value, AppLocalizations l10n) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty) return l10n.validationDriverNameRequired;
    if (input.length > AppConstants.maxNameLength) {
      return l10n.validationMaxLength(AppConstants.maxNameLength);
    }
    return null;
  }

  /// The driver's phone is optional; only a non-empty value is checked.
  static String? optionalPhone(String? value, AppLocalizations l10n) {
    final String input = (value ?? '').replaceAll(RegExp(r'[\s()-]'), '');
    if (input.isEmpty) return null;
    if (!_phone.hasMatch(input)) return l10n.validationPhoneInvalid;
    return null;
  }

  static String? maxLength(String? value, int max, AppLocalizations l10n) {
    if ((value ?? '').length > max) return l10n.validationMaxLength(max);
    return null;
  }

  static String? holdReason(String? value, AppLocalizations l10n) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty) return l10n.validationReasonRequired;
    return maxLength(input, AppConstants.maxReasonLength, l10n);
  }

  /// Validates a quantity typed into the loading form.
  ///
  /// An empty field means "not loading this line" and is valid; a value must
  /// be a non-negative number that exceeds neither the pending quantity nor
  /// the stock on hand.
  static String? loadQuantity(
    String? value, {
    required int pendingPcs,
    required int stockPcs,
    required AppLocalizations l10n,
  }) {
    final String input = value?.trim() ?? '';
    if (input.isEmpty) return null;
    final num? parsed = num.tryParse(input);
    if (parsed == null) return l10n.validationNumberInvalid;
    if (parsed < 0) return l10n.validationQuantityNegative;
    if (parsed > pendingPcs) {
      return l10n.validationQuantityExceedsPending(pendingPcs);
    }
    if (parsed > stockPcs) return l10n.validationQuantityExceedsStock(stockPcs);
    return null;
  }

  /// Uppercases a plate and strips separators so `ka-01 zz7777` and
  /// `KA 01 ZZ 7777` validate identically.
  static String normalizeVehicleNumber(String value) =>
      value.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');
}
