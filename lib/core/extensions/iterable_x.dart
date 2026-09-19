/// Small collection helpers used by the feature layer.
extension IterableX<T> on Iterable<T> {
  /// The first element matching [test], or `null` — the nullable counterpart
  /// to `firstWhere`, without the `orElse` ceremony at every call site.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final T element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
