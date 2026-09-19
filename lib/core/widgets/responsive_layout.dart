import 'package:flutter/material.dart';

import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/uniform_grid.dart';

/// Chooses a different widget tree per screen class.
///
/// Use this only when the *structure* changes — a single column becoming two,
/// a sheet becoming a side panel. Size changes are handled globally by
/// `AppScale`, so a layout should not need this just to look right on a
/// bigger phone.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.compact,
    this.medium,
    this.expanded,
    super.key,
  });

  /// Phones. Always required: it is the baseline layout.
  final WidgetBuilder compact;

  /// Small tablets and large foldables. Falls back to [compact].
  final WidgetBuilder? medium;

  /// Large tablets and desktop-class windows. Falls back to [medium].
  final WidgetBuilder? expanded;

  @override
  Widget build(BuildContext context) {
    return switch (context.screenClass) {
      ScreenClass.expanded => (expanded ?? medium ?? compact)(context),
      ScreenClass.medium => (medium ?? compact)(context),
      ScreenClass.compact => compact(context),
    };
  }
}

/// Lays children out in a grid whose column count follows the screen class.
///
/// Every cell is the same size — the column width, and the height of the
/// tallest child — so a row of cards reads as one block however long the
/// translated labels are. See [UniformGrid] for the layout itself.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.compactColumns = 2,
    this.mediumColumns = 3,
    this.expandedColumns = 4,
    this.spacing,
    this.runSpacing,
    super.key,
  });

  final List<Widget> children;
  final int compactColumns;
  final int mediumColumns;
  final int expandedColumns;

  /// Gap between columns. Defaults to [AppSpacing.md].
  final double? spacing;

  /// Gap between rows. Defaults to [spacing].
  final double? runSpacing;

  @override
  Widget build(BuildContext context) {
    final int columns = switch (context.screenClass) {
      ScreenClass.compact => compactColumns,
      ScreenClass.medium => mediumColumns,
      ScreenClass.expanded => expandedColumns,
    };
    final double gap = spacing ?? AppSpacing.md;

    return UniformGrid(
      columns: columns,
      spacing: gap,
      runSpacing: runSpacing ?? gap,
      children: children,
    );
  }
}
