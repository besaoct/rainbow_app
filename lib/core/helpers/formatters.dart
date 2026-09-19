import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Locale-aware formatting for dates, numbers and identifiers.
///
/// Formatters are constructed per call with the active locale so that
/// switching language updates every visible value without a restart.
abstract final class Formatters {
  /// The locale used when the requested one has no date symbols.
  static const String _fallbackLocale = 'en';

  /// Resolves a locale that `intl` can actually format dates in.
  ///
  /// `flutter_localizations` loads the active locale's symbols before any
  /// screen builds, but Assamese has no CLDR date data in `intl`, and a
  /// missing locale throws rather than degrading. Falling back keeps a date
  /// on screen instead of taking down the widget that shows it.
  static String _dateLocale(String localeCode) {
    try {
      if (DateFormat.localeExists(localeCode)) return localeCode;
      final String language = localeCode.split(RegExp('[-_]')).first;
      if (DateFormat.localeExists(language)) return language;
    } on Exception {
      // Symbol data is not initialised at all; the fallback is initialised
      // by `intl` itself.
    }
    return _fallbackLocale;
  }

  /// `19 Sep 2026`
  static String date(DateTime? value, String localeCode) {
    if (value == null) return '';
    return DateFormat.yMMMd(_dateLocale(localeCode)).format(value);
  }

  /// `19 Sep 2026, 14:09`
  static String dateTime(DateTime? value, String localeCode) {
    if (value == null) return '';
    return DateFormat.yMMMd(_dateLocale(localeCode)).add_Hm().format(value);
  }

  /// Locale used for every numeric value in the app.
  ///
  /// Deliberately fixed rather than following the interface language.
  /// Bengali and Assamese render digits in their own script (`১০` for ten),
  /// and every quantity in this app is cross-checked at the gate against a
  /// printed challan, e-way bill or invoice, all of which use Latin digits.
  /// A guard comparing `১০` on screen with `10` on paper is a defect waiting
  /// to happen, so digits stay Latin while grouping stays Indian —
  /// `1,50,000`, not `150,000`.
  static const String _numberLocale = 'en_IN';

  /// Indian-grouped integer in Latin digits.
  static String integer(num value) =>
      NumberFormat.decimalPattern(_numberLocale).format(value);

  /// Quantity with up to two decimals and no trailing zeros, so `1.0` boxes
  /// reads as `1` and `0.2` stays `0.2`.
  static String quantity(num value) {
    final NumberFormat format = NumberFormat.decimalPattern(_numberLocale)
      ..maximumFractionDigits = 2;
    return format.format(value);
  }

  /// Indian rupee amount, which is the currency the ERP quotes rates in.
  static String currency(num value) => NumberFormat.currency(
    locale: _numberLocale,
    symbol: '₹',
    decimalDigits: 2,
  ).format(value);

  /// Groups a normalised plate back into its readable form:
  /// `KA01ZZ7777` becomes `KA 01 ZZ 7777`.
  static String vehicleNumber(String value) {
    final String plate = value.toUpperCase().replaceAll(
      RegExp('[^A-Z0-9]'),
      '',
    );
    final RegExpMatch? match = RegExp(
      r'^([A-Z]{2})([0-9]{1,2})([A-Z]{0,3})([0-9]{1,4})$',
    ).firstMatch(plate);
    if (match == null) return value.toUpperCase().trim();
    return <String?>[
      match.group(1),
      match.group(2),
      match.group(3),
      match.group(4),
    ].where((String? p) => p != null && p.isNotEmpty).join(' ');
  }
}

/// Keeps a vehicle-number field upper-case as the user types, so the plate is
/// stored and displayed consistently no matter the keyboard.
class UpperCaseTextFormatter extends TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
