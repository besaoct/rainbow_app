/// Animation and timing constants.
///
/// Anything the user perceives as motion or waiting is defined here so that
/// timings stay consistent and can be tuned in one place.
abstract final class AppDurations {
  /// Colour and opacity changes on press.
  static const Duration instant = Duration(milliseconds: 120);

  /// The default for most state transitions.
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 320);
  static const Duration slow = Duration(milliseconds: 480);

  /// Page transitions pushed by the router.
  static const Duration pageTransition = Duration(milliseconds: 260);

  /// How long a snackbar stays on screen.
  static const Duration snackbar = Duration(seconds: 4);

  /// Debounce applied to search fields before a query is issued.
  static const Duration searchDebounce = Duration(milliseconds: 350);

  /// Network timeouts.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 25);
  static const Duration sendTimeout = Duration(seconds: 25);
}
