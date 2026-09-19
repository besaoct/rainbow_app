import 'package:flutter/foundation.dart';

/// Bridges Riverpod providers to `GoRouter.refreshListenable`.
///
/// The router is built once and kept for the life of the app: rebuilding it
/// whenever the session changes would throw away the navigation stack. This
/// notifier instead pokes the existing router, whose `redirect` then re-reads
/// the current state and decides where the user belongs.
class RouterRefreshNotifier extends ChangeNotifier {
  /// Signals the router to re-evaluate its redirect.
  void notify() => notifyListeners();
}
