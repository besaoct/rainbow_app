import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A grid whose cells are all exactly the same size.
///
/// Every cell takes the width of a column and the height of the *tallest*
/// child, so a card whose label wraps to two lines does not leave its
/// neighbour short. A `Wrap` cannot do this — its children size themselves
/// independently — and a `GridView` can only do it by fixing an aspect ratio,
/// which breaks as soon as the text scale or the language changes.
///
/// Children are measured once at the column width, then laid out again at the
/// resulting uniform height. Two passes over a handful of cards is cheap, and
/// it avoids depending on intrinsic sizing, which not every widget supports.
class UniformGrid extends MultiChildRenderObjectWidget {
  const UniformGrid({
    required this.columns,
    required this.spacing,
    required this.runSpacing,
    required super.children,
    super.key,
  }) : assert(columns > 0, 'A grid needs at least one column');

  /// Maximum number of columns. A grid with fewer children than this uses one
  /// column per child, so a lone card fills the row rather than sitting in a
  /// half-width box beside empty space.
  final int columns;

  /// Horizontal gap between columns.
  final double spacing;

  /// Vertical gap between rows.
  final double runSpacing;

  @override
  RenderUniformGrid createRenderObject(BuildContext context) {
    return RenderUniformGrid(columns, spacing, runSpacing);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderUniformGrid renderObject,
  ) {
    renderObject
      ..columns = columns
      ..spacing = spacing
      ..runSpacing = runSpacing;
  }
}

class _UniformGridParentData extends ContainerBoxParentData<RenderBox> {}

/// Layout for [UniformGrid].
class RenderUniformGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _UniformGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _UniformGridParentData> {
  /// Takes the column count, the column gap and the row gap, in that order.
  /// Positional because Dart does not allow a private field to be a named
  /// initialising formal.
  RenderUniformGrid(this._columns, this._spacing, this._runSpacing);

  int _columns;
  int get columns => _columns;
  set columns(int value) {
    if (_columns == value) return;
    _columns = value;
    markNeedsLayout();
  }

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  double _runSpacing;
  double get runSpacing => _runSpacing;
  set runSpacing(double value) {
    if (_runSpacing == value) return;
    _runSpacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! _UniformGridParentData) {
      child.parentData = _UniformGridParentData();
    }
  }

  /// Columns actually used, and the width of one of them.
  (int, double) _geometry(double maxWidth, int childCount) {
    final int used = math.min(_columns, math.max(childCount, 1));
    final double width = (maxWidth - _spacing * (used - 1)) / used;
    return (used, math.max(width, 0));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (childCount == 0) return constraints.smallest;
    final double maxWidth = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : constraints.minWidth;
    final (int used, double cellWidth) = _geometry(maxWidth, childCount);

    double cellHeight = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      final Size size = child.getDryLayout(
        BoxConstraints.tightFor(width: cellWidth),
      );
      cellHeight = math.max(cellHeight, size.height);
      child = childAfter(child);
    }
    return constraints.constrain(
      Size(maxWidth, _totalHeight(cellHeight, used)),
    );
  }

  double _totalHeight(double cellHeight, int used) {
    final int rows = (childCount / used).ceil();
    return rows * cellHeight + (rows - 1) * _runSpacing;
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    assert(
      constraints.hasBoundedWidth,
      'UniformGrid needs a bounded width; it cannot size columns against '
      'infinity. Give it a parent that constrains width.',
    );
    final double maxWidth = constraints.maxWidth;
    final (int used, double cellWidth) = _geometry(maxWidth, childCount);

    // Pass one: measure every child at the column width.
    double cellHeight = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints(minWidth: cellWidth, maxWidth: cellWidth),
        parentUsesSize: true,
      );
      cellHeight = math.max(cellHeight, child.size.height);
      child = childAfter(child);
    }

    // Pass two: give every child the same box and place it.
    int index = 0;
    child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints.tightFor(width: cellWidth, height: cellHeight),
      );
      (child.parentData! as _UniformGridParentData).offset = Offset(
        (index % used) * (cellWidth + _spacing),
        (index ~/ used) * (cellHeight + _runSpacing),
      );
      index++;
      child = childAfter(child);
    }

    size = constraints.constrain(
      Size(maxWidth, _totalHeight(cellHeight, used)),
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
