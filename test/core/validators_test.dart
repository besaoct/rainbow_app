import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/helpers/validators.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
  });

  group('email', () {
    test('rejects an empty value', () {
      expect(Validators.email('', l10n), l10n.validationEmailRequired);
      expect(Validators.email(null, l10n), l10n.validationEmailRequired);
    });

    test('rejects a malformed address', () {
      for (final String value in <String>[
        'guard',
        'guard@',
        'guard@rainbow',
        '@rainbowerp.com',
        'guard rainbow@erp.com',
      ]) {
        expect(
          Validators.email(value, l10n),
          l10n.validationEmailInvalid,
          reason: value,
        );
      }
    });

    test('accepts the ERP account formats', () {
      for (final String value in <String>[
        'guard@rainbowerp.com',
        'stores@rainbowerp.com',
        'first.last+shift@sub.rainbowerp.co.in',
      ]) {
        expect(Validators.email(value, l10n), isNull, reason: value);
      }
    });

    test('tolerates surrounding whitespace', () {
      expect(Validators.email('  guard@rainbowerp.com ', l10n), isNull);
    });
  });

  group('vehicle number', () {
    test('accepts Indian plates in any spacing or case', () {
      for (final String value in <String>[
        'KA 01 ZZ 7777',
        'ka01zz7777',
        'KA-01-ZZ-7777',
        'GJ 05 AB 1234',
        'DL1CAB1234',
      ]) {
        expect(Validators.vehicleNumber(value, l10n), isNull, reason: value);
      }
    });

    test('rejects a plate that is not a plate', () {
      for (final String value in <String>['1234', 'KA', 'KA01ZZ', '99 99 99']) {
        expect(
          Validators.vehicleNumber(value, l10n),
          l10n.validationVehicleNumberInvalid,
          reason: value,
        );
      }
    });

    test('reports an empty plate as missing, not malformed', () {
      expect(
        Validators.vehicleNumber('', l10n),
        l10n.validationVehicleNumberRequired,
      );
    });
  });

  group('optional phone', () {
    test('accepts an empty value, because the field is optional', () {
      expect(Validators.optionalPhone('', l10n), isNull);
      expect(Validators.optionalPhone(null, l10n), isNull);
    });

    test('accepts formatted Indian numbers', () {
      for (final String value in <String>[
        '+91 91234 56789',
        '9123456789',
        '+91-91234-56789',
        '(0361) 2345678',
      ]) {
        expect(Validators.optionalPhone(value, l10n), isNull, reason: value);
      }
    });

    test('rejects a value that cannot be a phone number', () {
      expect(
        Validators.optionalPhone('12345', l10n),
        l10n.validationPhoneInvalid,
      );
      expect(
        Validators.optionalPhone('not a number', l10n),
        l10n.validationPhoneInvalid,
      );
    });
  });

  group('load quantity', () {
    String? check(String? value, {int pending = 100, int stock = 100}) =>
        Validators.loadQuantity(
          value,
          pendingPcs: pending,
          stockPcs: stock,
          l10n: l10n,
        );

    test('treats an empty field as "not loading this line"', () {
      expect(check(''), isNull);
      expect(check(null), isNull);
    });

    test('rejects a value above the pending quantity', () {
      expect(
        check('101', pending: 100, stock: 500),
        l10n.validationQuantityExceedsPending(100),
      );
    });

    test('rejects a value above the stock on hand', () {
      expect(
        check('60', pending: 100, stock: 50),
        l10n.validationQuantityExceedsStock(50),
      );
    });

    test('accepts a value within both limits', () {
      expect(check('50', pending: 100, stock: 60), isNull);
    });

    test('rejects a negative quantity and a non-number', () {
      expect(check('-1'), l10n.validationQuantityNegative);
      expect(check('ten'), l10n.validationNumberInvalid);
    });
  });

  group('hold reason', () {
    test('is mandatory, because a held vehicle needs a recorded cause', () {
      expect(Validators.holdReason('   ', l10n), l10n.validationReasonRequired);
      expect(Validators.holdReason('Challan mismatch', l10n), isNull);
    });
  });
}
