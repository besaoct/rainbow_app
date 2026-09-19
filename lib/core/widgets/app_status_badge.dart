import 'package:flutter/material.dart';

import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';

/// The colour mark a vehicle carries through the gate workflow.
///
/// Colour alone is never the only signal: the badge always shows its label,
/// and a dot precedes it, so the mark is readable to a colour-blind guard and
/// to a screen reader.
class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({required this.status, this.compact = false, super.key});

  final GateEntryStatus status;

  /// Drops the padding and uses the smallest type, for dense list rows.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final String label = status.label(context.l10n);
    return Semantics(
      label: context.l10n.a11yStatusMark(label),
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.sm : AppSpacing.md,
          vertical: compact ? AppSpacing.xxs : AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: status.containerColor(context.colors),
          borderRadius: AppRadius.chipRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _Dot(color: status.color(context.colors)),
            SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    (compact
                            ? AppTextStyles.labelSmall
                            : AppTextStyles.labelMedium)
                        .copyWith(
                          color: status.onContainerColor(context.colors),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final double size = AppIconSize.xs * 0.5;
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// A narrow vertical bar in the mark's colour, used down the leading edge of
/// a vehicle row so the queue can be scanned at a glance.
class StatusEdge extends StatelessWidget {
  const StatusEdge({required this.status, super.key});

  final GateEntryStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.xs,
      decoration: BoxDecoration(
        color: status.color(context.colors),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
    );
  }
}
