import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Enforces the project's hard rule: no user-facing string literal may appear
/// in UI code.
///
/// Every visible string must come from `AppLocalizations`. This scans the
/// widget layer for literals in the places they leak in from — `Text(...)`,
/// label/hint/title/message/tooltip arguments — and fails with the file and
/// line so the offender is obvious.
void main() {
  /// Directories whose literals are not user-facing.
  const List<String> excludedPaths = <String>[
    'lib/l10n/generated/',
    'lib/core/constants/',
    'lib/core/network/api_endpoints.dart',
    'lib/core/theme/',
    'lib/app/theme/',
    'lib/app/config/',
  ];

  /// Literals that are punctuation, formatting or symbols rather than words:
  /// nothing here needs translating.
  bool isNonLinguistic(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) return true;
    // Digits, separators, punctuation and symbols only.
    return !RegExp('[A-Za-z]').hasMatch(trimmed);
  }

  /// Argument names whose value is rendered to the user.
  const List<String> visibleArguments = <String>[
    'label',
    'labelText',
    'hint',
    'hintText',
    'helper',
    'helperText',
    'title',
    'message',
    'errorText',
    'tooltip',
    'semanticLabel',
    'actionLabel',
    'confirmLabel',
    'cancelLabel',
    'placeholder',
    'subtitle',
    'value',
  ];

  List<File> dartFiles() =>
      Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((File f) => f.path.endsWith('.dart'))
          .where(
            (File f) => !excludedPaths.any((String e) => f.path.startsWith(e)),
          )
          .toList()
        ..sort((File a, File b) => a.path.compareTo(b.path));

  /// Matches a single- or double-quoted Dart string that is not adjacent to
  /// an identifier character (so it skips `r'...'` raw patterns).
  final RegExp textLiteral = RegExp(
    r"""\bText\(\s*(?:'([^'\\]*)'|"([^"\\]*)")""",
  );

  final RegExp namedLiteral = RegExp(
    '\\b(${visibleArguments.join('|')})'
    r""":\s*(?:'([^'\\]*)'|"([^"\\]*)")""",
  );

  test('lib contains dart files to scan', () {
    expect(dartFiles(), isNotEmpty);
  });

  test('no Text() is built from a string literal', () {
    final List<String> offences = <String>[];

    for (final File file in dartFiles()) {
      final List<String> lines = file.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        for (final RegExpMatch match in textLiteral.allMatches(lines[i])) {
          final String value = match.group(1) ?? match.group(2) ?? '';
          if (isNonLinguistic(value)) continue;
          offences.add('${file.path}:${i + 1}  Text(\'$value\')');
        }
      }
    }

    expect(
      offences,
      isEmpty,
      reason:
          'User-facing text must come from AppLocalizations:\n'
          '${offences.join('\n')}',
    );
  });

  test('no visible argument is given a string literal', () {
    final List<String> offences = <String>[];

    for (final File file in dartFiles()) {
      final List<String> lines = file.readAsLinesSync();
      for (int i = 0; i < lines.length; i++) {
        final String line = lines[i];
        // Skip documentation and comments.
        if (line.trimLeft().startsWith('//')) continue;
        for (final RegExpMatch match in namedLiteral.allMatches(line)) {
          final String argument = match.group(1)!;
          final String value = match.group(2) ?? match.group(3) ?? '';
          if (isNonLinguistic(value)) continue;
          offences.add('${file.path}:${i + 1}  $argument: \'$value\'');
        }
      }
    }

    expect(
      offences,
      isEmpty,
      reason:
          'User-facing text must come from AppLocalizations:\n'
          '${offences.join('\n')}',
    );
  });

  test(
    'every screen and widget file reaches strings through AppLocalizations',
    () {
      // A file under features/*/screens that renders text but never touches
      // `l10n` is a strong signal that something was hardcoded in a way the
      // patterns above did not catch.
      final List<String> suspicious = <String>[];

      for (final File file in dartFiles()) {
        if (!file.path.contains('/screens/')) continue;
        final String source = file.readAsStringSync();
        if (!source.contains('Text(')) continue;
        if (source.contains('context.l10n') || source.contains('l10n.')) {
          continue;
        }
        suspicious.add(file.path);
      }

      expect(suspicious, isEmpty, reason: suspicious.join('\n'));
    },
  );
}
