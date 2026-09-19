import 'package:flutter/widgets.dart';

import 'package:rainbow_app/core/theme/app_colors.dart';
import 'package:rainbow_app/l10n/generated/app_localizations.dart';

/// Where a vehicle is in the gate workflow.
///
/// Rainbow ERP drives the whole dispatch process with a colour mark, and the
/// transitions are one-way:
///
/// ```text
/// gate-in          store loads         guard clears
/// entered ──────▶ loaded ──────▶ cleared
/// (orange)        (red)          (green)
///                     └──────▶ held (issue recorded)
/// ```
enum GateEntryStatus {
  /// Orange mark — registered at the gate, not yet loaded.
  entered('entered'),

  /// Red mark — loaded and awaiting security clearance.
  loaded('loaded'),

  /// Green mark — cleared to leave.
  cleared('cleared'),

  /// Held at the gate with a recorded reason.
  held('rejected'),

  /// The server sent a status this build does not know about.
  unknown('');

  const GateEntryStatus(this.wireValue);

  /// The value the API uses in its `status` field.
  final String wireValue;

  /// Parses the API's `status` field, tolerating unknown future values.
  static GateEntryStatus fromWire(String? value) {
    if (value == null || value.isEmpty) return unknown;
    final String normalised = value.trim().toLowerCase();
    for (final GateEntryStatus status in values) {
      if (status.wireValue == normalised) return status;
    }
    // The API also sends `color_mark`, which matches for the three marks.
    return switch (normalised) {
      'orange' => entered,
      'red' => loaded,
      'green' => cleared,
      'rejected' || 'held' => held,
      _ => unknown,
    };
  }

  /// Statuses offered as filters on the vehicle list, in workflow order.
  static const List<GateEntryStatus> filterable = <GateEntryStatus>[
    entered,
    loaded,
    cleared,
    held,
  ];

  /// A vehicle may only be loaded while it is inside the gate.
  bool get canBeLoaded => this == entered;

  /// Security may only clear a vehicle once the store has recorded loading.
  bool get canBeCleared => this == loaded;

  /// Whether the workflow has finished for this vehicle.
  bool get isFinal => this == cleared || this == held;
}

/// How a [GateEntryStatus] is named and coloured in the UI.
///
/// The API also returns a human-readable `color_mark_label`, but it is only
/// available in English; resolving the label locally keeps every visible
/// string inside the localisation system.
extension GateEntryStatusPresentation on GateEntryStatus {
  /// Short label, for badges and filter chips.
  String label(AppLocalizations l10n) => switch (this) {
    GateEntryStatus.entered => l10n.statusEntered,
    GateEntryStatus.loaded => l10n.statusLoaded,
    GateEntryStatus.cleared => l10n.statusCleared,
    GateEntryStatus.held => l10n.statusRejected,
    GateEntryStatus.unknown => l10n.statusUnknown,
  };

  /// Full description, including the colour mark, for detail screens.
  String description(AppLocalizations l10n) => switch (this) {
    GateEntryStatus.entered => l10n.markEnteredLabel,
    GateEntryStatus.loaded => l10n.markLoadedLabel,
    GateEntryStatus.cleared => l10n.markClearedLabel,
    GateEntryStatus.held => l10n.markRejectedLabel,
    GateEntryStatus.unknown => l10n.statusUnknown,
  };

  /// Foreground colour of the mark.
  Color color(AppColors colors) => switch (this) {
    GateEntryStatus.entered => colors.markEntered,
    GateEntryStatus.loaded => colors.markLoaded,
    GateEntryStatus.cleared => colors.markCleared,
    GateEntryStatus.held => colors.markHeld,
    GateEntryStatus.unknown => colors.textTertiary,
  };

  /// Tinted background used behind [onContainerColor].
  Color containerColor(AppColors colors) => switch (this) {
    GateEntryStatus.entered => colors.markEnteredContainer,
    GateEntryStatus.loaded => colors.markLoadedContainer,
    GateEntryStatus.cleared => colors.markClearedContainer,
    GateEntryStatus.held => colors.markHeldContainer,
    GateEntryStatus.unknown => colors.surfaceSunken,
  };

  /// Text/icon colour to use on [containerColor].
  Color onContainerColor(AppColors colors) => switch (this) {
    GateEntryStatus.entered => colors.onMarkEnteredContainer,
    GateEntryStatus.loaded => colors.onMarkLoadedContainer,
    GateEntryStatus.cleared => colors.onMarkClearedContainer,
    GateEntryStatus.held => colors.onMarkHeldContainer,
    GateEntryStatus.unknown => colors.textSecondary,
  };
}
