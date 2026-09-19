import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:rainbow_app/core/helpers/formatters.dart';

void main() {
  // `flutter_localizations` does this for the active locale at runtime.
  setUpAll(initializeDateFormatting);

  group('vehicleNumber', () {
    test('groups a plate into its readable form', () {
      expect(Formatters.vehicleNumber('KA01ZZ7777'), 'KA 01 ZZ 7777');
      expect(Formatters.vehicleNumber('ka-01-zz-7777'), 'KA 01 ZZ 7777');
      expect(Formatters.vehicleNumber('KA 01 ZZ 7777'), 'KA 01 ZZ 7777');
    });

    test('handles the shorter series without a letter block', () {
      expect(Formatters.vehicleNumber('DL1C1234'), 'DL 1 C 1234');
    });

    test('leaves an unrecognised value alone rather than mangling it', () {
      expect(Formatters.vehicleNumber('TEMP-PERMIT'), 'TEMP-PERMIT');
    });
  });

  group('quantity', () {
    test('drops trailing zeros so whole boxes read as whole numbers', () {
      expect(Formatters.quantity(1), '1');
      expect(Formatters.quantity(1.0), '1');
    });

    test('keeps a partial box', () {
      expect(Formatters.quantity(0.2), '0.2');
      expect(Formatters.quantity(1.25), '1.25');
    });
  });

  group('integer', () {
    test('uses Indian grouping', () {
      expect(Formatters.integer(1000), '1,000');
      expect(Formatters.integer(150000), '1,50,000');
      expect(Formatters.integer(0), '0');
    });

    test('keeps Latin digits regardless of interface language, so on-screen '
        'quantities match the printed challan', () {
      expect(Formatters.integer(150000), '1,50,000');
      expect(Formatters.quantity(1.25), '1.25');
      expect(Formatters.currency(2100), startsWith('₹'));
      expect(Formatters.currency(2100), contains('2,100'));
    });
  });

  group('date', () {
    test('returns an empty string for a missing value', () {
      expect(Formatters.date(null, 'en'), '');
      expect(Formatters.dateTime(null, 'en'), '');
    });

    test('formats a timestamp', () {
      final DateTime value = DateTime(2026, 9, 19, 14, 9);
      expect(Formatters.date(value, 'en'), 'Sep 19, 2026');
      expect(Formatters.dateTime(value, 'en'), contains('14:09'));
    });

    test('falls back rather than throwing for a locale intl cannot format', () {
      final DateTime value = DateTime(2026, 9, 19, 14, 9);
      // Assamese has no CLDR date data; the app must still show a date.
      expect(Formatters.date(value, 'as'), isNotEmpty);
    });
  });
}
