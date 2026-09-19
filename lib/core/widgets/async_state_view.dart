import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/widgets/app_state_views.dart';

/// Renders the four states of an asynchronous value: loading, error, empty
/// and data.
///
/// Every async screen in the app goes through this widget, which is what
/// guarantees none of them can leave the user on a blank page. While a
/// refresh is in flight the previous data stays on screen rather than being
/// replaced by a spinner.
class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    required this.value,
    required this.data,
    this.onRetry,
    this.isEmpty,
    this.empty,
    this.loading,
    super.key,
  });

  final AsyncValue<T> value;

  /// Builds the success state.
  final Widget Function(BuildContext context, T value) data;

  /// Retries the underlying request. Omit for values that cannot be retried.
  final VoidCallback? onRetry;

  /// Reports whether a successfully loaded value has nothing to show.
  final bool Function(T value)? isEmpty;

  /// Built when [isEmpty] returns true. Required if [isEmpty] is supplied.
  final WidgetBuilder? empty;

  /// Overrides the default loading view.
  final WidgetBuilder? loading;

  @override
  Widget build(BuildContext context) {
    // Prefer showing stale data over a spinner: a guard refreshing the
    // vehicle list should keep seeing the list.
    if (value.hasValue) {
      final T resolved = value.requireValue;
      if (isEmpty != null && isEmpty!(resolved)) {
        return empty?.call(context) ?? const SizedBox.shrink();
      }
      return data(context, resolved);
    }
    if (value.hasError) {
      return AppErrorView(failure: value.error!, onRetry: onRetry);
    }
    return loading?.call(context) ?? const AppLoadingView();
  }
}
