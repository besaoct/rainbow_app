import 'package:flutter/widgets.dart';

/// The raw brand palette.
///
/// Nothing outside the theme layer should reference these directly — widgets
/// read semantic colours from `Theme.of(context).colorScheme` or from
/// `context.colors` (see `AppColors`), so that light and dark themes stay in
/// sync automatically.
abstract final class AppPalette {
  // Brand — indigo, taken from the logo's inner arc.
  static const Color indigo50 = Color(0xFFEEF2FF);
  static const Color indigo100 = Color(0xFFE0E7FF);
  static const Color indigo200 = Color(0xFFC7D2FE);
  static const Color indigo300 = Color(0xFFA5B4FC);
  static const Color indigo400 = Color(0xFF818CF8);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color indigo600 = Color(0xFF4F46E5);
  static const Color indigo700 = Color(0xFF4338CA);
  static const Color indigo900 = Color(0xFF312E81);
  static const Color indigo950 = Color(0xFF120B2E);

  // Accent — cyan, used for secondary emphasis and the store surface.
  static const Color cyan100 = Color(0xFFCFFAFE);
  static const Color cyan400 = Color(0xFF22D3EE);
  static const Color cyan600 = Color(0xFF0891B2);
  static const Color cyan800 = Color(0xFF155E75);

  // Neutrals.
  static const Color white = Color(0xFFFFFFFF);
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  // Dark-theme surfaces. Cooler and slightly violet so the brand carries over.
  static const Color ink900 = Color(0xFF0B1020);
  static const Color ink800 = Color(0xFF141A2E);
  static const Color ink700 = Color(0xFF1C2340);
  static const Color ink600 = Color(0xFF2A3355);

  // Feedback.
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);
  static const Color red300 = Color(0xFFFCA5A5);

  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);
  static const Color green300 = Color(0xFF86EFAC);

  static const Color amber100 = Color(0xFFFEF3C7);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber600 = Color(0xFFD97706);
  static const Color amber300 = Color(0xFFFCD34D);

  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);
  static const Color orange300 = Color(0xFFFDBA74);

  // "Held / issue" — deliberately outside the orange/red/green traffic-light
  // range so a held vehicle can never be mistaken for one of the three marks.
  static const Color pink100 = Color(0xFFFCE7F3);
  static const Color pink500 = Color(0xFFEC4899);
  static const Color pink600 = Color(0xFFDB2777);
  static const Color pink300 = Color(0xFFF9A8D4);

  /// The seven logo hues, outer arc first. Used for decorative brand accents.
  static const List<Color> spectrum = <Color>[
    red500,
    orange500,
    amber500,
    green500,
    cyan400,
    indigo500,
    Color(0xFF8B5CF6),
  ];
}
