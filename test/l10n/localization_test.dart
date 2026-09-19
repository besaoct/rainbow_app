import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

/// Guards the localisation contract.
///
/// Every locale must define every key, with the same placeholders. A missing
/// key silently falls back to English at runtime, which is exactly the kind
/// of regression that ships unnoticed.
void main() {
  final Directory arbDir = Directory('lib/l10n/arb');
  final RegExp placeholder = RegExp(r'\{(\w+)\}');

  Map<String, String> readArb(String locale) {
    final File file = File('${arbDir.path}/app_$locale.arb');
    expect(file.existsSync(), isTrue, reason: 'missing ${file.path}');
    final Map<String, Object?> decoded =
        jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    return <String, String>{
      for (final MapEntry<String, Object?> e in decoded.entries)
        if (!e.key.startsWith('@') && e.value is String)
          e.key: e.value! as String,
    };
  }

  late Map<String, String> english;

  setUpAll(() => english = readArb('en'));

  test('the template defines a meaningful number of strings', () {
    // A sanity floor: if this drops sharply, something deleted the source.
    expect(english.length, greaterThan(200));
  });

  test('every shipped locale has an ARB file', () {
    for (final Locale locale in AppConstants.supportedLocales) {
      expect(
        File('${arbDir.path}/app_${locale.languageCode}.arb').existsSync(),
        isTrue,
        reason: locale.languageCode,
      );
    }
  });

  for (final Locale locale in AppConstants.supportedLocales) {
    final String code = locale.languageCode;
    if (code == 'en') continue;

    group(code, () {
      test('defines every key in the template', () {
        final Map<String, String> translated = readArb(code);
        final Set<String> missing = english.keys.toSet().difference(
          translated.keys.toSet(),
        );
        expect(missing, isEmpty, reason: 'missing in $code: $missing');
      });

      test('defines no key the template does not have', () {
        final Map<String, String> translated = readArb(code);
        final Set<String> extra = translated.keys.toSet().difference(
          english.keys.toSet(),
        );
        expect(extra, isEmpty, reason: 'unknown in $code: $extra');
      });

      test('keeps every placeholder', () {
        final Map<String, String> translated = readArb(code);
        for (final MapEntry<String, String> entry in english.entries) {
          final Set<String> expected = placeholder
              .allMatches(entry.value)
              .map((RegExpMatch m) => m.group(1)!)
              .toSet();
          final Set<String> actual = placeholder
              .allMatches(translated[entry.key] ?? '')
              .map((RegExpMatch m) => m.group(1)!)
              .toSet();
          expect(
            expected.difference(actual),
            isEmpty,
            reason: '$code.${entry.key} drops a placeholder',
          );
        }
      });

      test('leaves no value empty', () {
        final Map<String, String> translated = readArb(code);
        for (final MapEntry<String, String> entry in translated.entries) {
          expect(entry.value.trim(), isNotEmpty, reason: '$code.${entry.key}');
        }
      });

      test('actually translates, rather than copying English', () {
        final Map<String, String> translated = readArb(code);
        // A handful of values are the same in every locale by design: the
        // brand name, example values inside hints, and pure format strings.
        const Set<String> sharedByDesign = <String>{
          'appName',
          'labelNotAvailable',
          'loginEmailHint',
          'vehicleNumberHint',
          'driverPhoneHint',
          'challanNumberHint',
          'ewayBillNumberHint',
          'invoiceNumberHint',
          'skuLabel',
          'settingsVersionValue',
          'languageEnglish',
          'languageHindi',
          'languageBengali',
          'languageAssamese',
        };
        final List<String> untranslated = <String>[
          for (final MapEntry<String, String> e in english.entries)
            if (!sharedByDesign.contains(e.key) && translated[e.key] == e.value)
              e.key,
        ];
        expect(untranslated, isEmpty, reason: 'still English in $code');
      });
    });
  }

  group('generated bindings', () {
    test('load for every supported locale', () async {
      for (final Locale locale in AppConstants.supportedLocales) {
        expect(
          AppLocalizations.delegate.isSupported(locale),
          isTrue,
          reason: locale.languageCode,
        );
        final AppLocalizations l10n = await AppLocalizations.delegate.load(
          locale,
        );
        expect(l10n.appName, isNotEmpty);
        expect(l10n.actionSignIn, isNotEmpty);
      }
    });

    test('resolve plurals and placeholders', () async {
      final AppLocalizations l10n = await AppLocalizations.delegate.load(
        const Locale('en'),
      );

      expect(l10n.itemCount(0), 'No items');
      expect(l10n.itemCount(1), '1 item');
      expect(l10n.itemCount(7), '7 items');
      expect(l10n.lineCount(1), '1 line');
      expect(
        l10n.guardGateInSuccessMessage('GP-1', 'KA 01 ZZ 7777'),
        contains('KA 01 ZZ 7777'),
      );
      expect(l10n.validationQuantityExceedsPending(10), contains('10'));
    });

    test('resolve plurals in every locale without throwing', () async {
      for (final Locale locale in AppConstants.supportedLocales) {
        final AppLocalizations l10n = await AppLocalizations.delegate.load(
          locale,
        );
        for (final int count in <int>[0, 1, 2, 11, 100]) {
          expect(l10n.itemCount(count), isNotEmpty);
          expect(l10n.lineCount(count), isNotEmpty);
          expect(l10n.vehicleCount(count), isNotEmpty);
        }
      }
    });
  });
}
