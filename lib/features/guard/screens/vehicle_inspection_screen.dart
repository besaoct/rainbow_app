import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/enums/gate_entry_status.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/network/api_failure.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_feedback.dart';
import 'package:rainbow_app/core/widgets/app_scaffold.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/app_status_badge.dart';
import 'package:rainbow_app/core/widgets/async_state_view.dart';
import 'package:rainbow_app/features/guard/models/vehicle_inspection.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';
import 'package:rainbow_app/features/guard/widgets/hold_reason_sheet.dart';
import 'package:rainbow_app/features/guard/widgets/inspection_item_tile.dart';

/// The exit check: what was loaded, which documents accompany it, and the
/// decision to clear the vehicle or hold it.
class VehicleInspectionScreen extends ConsumerStatefulWidget {
  const VehicleInspectionScreen({required this.vehicleId, super.key});

  final int vehicleId;

  @override
  ConsumerState<VehicleInspectionScreen> createState() =>
      _VehicleInspectionScreenState();
}

class _VehicleInspectionScreenState
    extends ConsumerState<VehicleInspectionScreen> {
  bool _isSubmitting = false;

  Future<void> _approve(VehicleInspection inspection) async {
    final bool? confirmed = await AppDialog.confirm(
      context,
      title: context.l10n.guardApproveTitle,
      message: context.l10n.guardApproveMessage(
        Formatters.vehicleNumber(inspection.vehicleNo),
      ),
      confirmLabel: context.l10n.guardApproveExit,
    );
    if (confirmed != true || !mounted) return;
    await _submit(
      action: GateOutAction.approve,
      vehicleNo: inspection.vehicleNo,
    );
  }

  Future<void> _hold(VehicleInspection inspection) async {
    final HoldDecision? decision = await AppSheet.show<HoldDecision>(
      context,
      title: context.l10n.guardRejectTitle,
      builder: (_) => const HoldReasonSheet(),
    );
    if (decision == null || !mounted) return;
    await _submit(
      action: GateOutAction.reject,
      vehicleNo: inspection.vehicleNo,
      reason: decision.reason,
      remarks: decision.remarks,
    );
  }

  Future<void> _submit({
    required GateOutAction action,
    required String vehicleNo,
    String? reason,
    String? remarks,
  }) async {
    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(gateOutControllerProvider.notifier)
          .submit(
            vehicleId: widget.vehicleId,
            action: action,
            reason: reason,
            remarks: remarks,
          );
      if (!mounted) return;
      final String plate = Formatters.vehicleNumber(vehicleNo);
      AppSnackbar.success(
        context,
        action == GateOutAction.approve
            ? context.l10n.guardApproveSuccess(plate)
            : context.l10n.guardRejectSuccess(plate),
      );
      Navigator.of(context).pop();
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      AppSnackbar.error(context, failure.localizedMessage(context.l10n));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<VehicleInspection> inspection = ref.watch(
      vehicleInspectionProvider(widget.vehicleId),
    );
    final VehicleInspection? loaded = inspection.value;
    final bool canDecide = loaded != null && loaded.status.canBeCleared;

    return AppScaffold(
      title: context.l10n.guardInspectionTitle,
      subtitle: context.l10n.guardInspectionSubtitle,
      scrollable: true,
      onRefresh: () async =>
          ref.invalidate(vehicleInspectionProvider(widget.vehicleId)),
      bottomBar: canDecide
          ? _Decision(
              isBusy: _isSubmitting,
              onApprove: () => unawaited(_approve(loaded)),
              onHold: () => unawaited(_hold(loaded)),
            )
          : null,
      body: AsyncStateView<VehicleInspection>(
        value: inspection,
        onRetry: () =>
            ref.invalidate(vehicleInspectionProvider(widget.vehicleId)),
        data: (BuildContext context, VehicleInspection data) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _VehicleSummary(inspection: data),
            SizedBox(height: AppSpacing.xl),
            if (!data.status.canBeCleared && data.items.isEmpty)
              AppEmptyState(
                icon: AppAssets.iconBox,
                title: context.l10n.inspectionNotLoadedTitle,
                message: context.l10n.inspectionNotLoadedMessage,
              )
            else ...<Widget>[
              if (data.hasDocuments) ...<Widget>[
                AppSectionHeader(title: context.l10n.inspectionDocumentsTitle),
                _Documents(inspection: data),
                SizedBox(height: AppSpacing.xl),
              ],
              AppSectionHeader(title: context.l10n.inspectionItemsTitle),
              if (data.items.isEmpty)
                AppEmptyState(
                  icon: AppAssets.iconBox,
                  title: context.l10n.emptyInspectionItemsTitle,
                  message: context.l10n.emptyInspectionItemsMessage,
                )
              else ...<Widget>[
                for (final InspectionItem item in data.items)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.sm),
                    child: InspectionItemTile(item: item),
                  ),
                SizedBox(height: AppSpacing.md),
                _Totals(inspection: data),
              ],
            ],
            if (canDecide)
              SizedBox(height: AppSize.buttonHeight + AppSpacing.huge),
          ],
        ),
      ),
    );
  }
}

class _VehicleSummary extends StatelessWidget {
  const _VehicleSummary({required this.inspection});

  final VehicleInspection inspection;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  Formatters.vehicleNumber(inspection.vehicleNo),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.displaySmall.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              AppStatusBadge(status: inspection.status),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            inspection.status.description(context.l10n),
            style: AppTextStyles.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Divider(height: AppSpacing.lg, color: context.colors.border),
          AppDetailRow(
            label: context.l10n.gatePassLabel,
            value: inspection.gatePassNo,
          ),
          AppDetailRow(
            label: context.l10n.orderNumberLabel,
            value: inspection.orderNo,
          ),
          AppDetailRow(
            label: context.l10n.orderCustomerLabel,
            value: inspection.customerName,
          ),
          AppDetailRow(
            label: context.l10n.driverNameLabel,
            value: inspection.driverName,
          ),
          AppDetailRow(
            label: context.l10n.driverPhoneLabel,
            value: inspection.driverPhone,
          ),
          AppDetailRow(
            label: context.l10n.transporterLabel,
            value: inspection.transporterName,
          ),
          if (inspection.loadedByName != null)
            AppDetailRow(
              label: context.l10n.loadedByLabel,
              value: inspection.loadedByName!,
            ),
          if (inspection.loadedAt != null)
            AppDetailRow(
              label: context.l10n.loadedAtLabel,
              value: Formatters.dateTime(
                inspection.loadedAt,
                context.localeCode,
              ),
            ),
        ],
      ),
    );
  }
}

class _Documents extends StatelessWidget {
  const _Documents({required this.inspection});

  final VehicleInspection inspection;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (inspection.challanNo != null)
            AppDetailRow(
              label: context.l10n.challanNumberLabel,
              value: inspection.challanNo!,
              valueStyle: AppTextStyles.mono.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          if (inspection.ewayBillNo != null)
            AppDetailRow(
              label: context.l10n.ewayBillNumberLabel,
              value: inspection.ewayBillNo!,
              valueStyle: AppTextStyles.mono.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          if (inspection.invoiceNo != null)
            AppDetailRow(
              label: context.l10n.invoiceNumberLabel,
              value: inspection.invoiceNo!,
              valueStyle: AppTextStyles.mono.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          if (inspection.loadingRemarks != null)
            AppDetailRow(
              label: context.l10n.loadingRemarksLabel,
              value: inspection.loadingRemarks!,
            ),
        ],
      ),
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.inspection});

  final VehicleInspection inspection;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: context.colors.infoContainer,
      borderColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppDetailRow(
            label: context.l10n.totalPiecesLabel,
            value: Formatters.integer(inspection.totalPcs),
            valueStyle: AppTextStyles.mono.copyWith(
              color: context.colors.onInfoContainer,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          AppDetailRow(
            label: context.l10n.totalBoxesLabel,
            value: Formatters.quantity(inspection.totalBoxes),
            valueStyle: AppTextStyles.mono.copyWith(
              color: context.colors.onInfoContainer,
              fontWeight: AppFontWeight.bold,
            ),
          ),
          AppDetailRow(
            label: context.l10n.totalValueLabel,
            value: Formatters.currency(inspection.totalValue),
            valueStyle: AppTextStyles.mono.copyWith(
              color: context.colors.onInfoContainer,
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Decision extends StatelessWidget {
  const _Decision({
    required this.isBusy,
    required this.onApprove,
    required this.onHold,
  });

  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onHold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: AppButton.secondary(
            label: context.l10n.guardRejectExit,
            onPressed: isBusy ? null : onHold,
            icon: AppAssets.iconAlertTriangle,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: AppButton(
            label: context.l10n.guardApproveExit,
            onPressed: onApprove,
            isBusy: isBusy,
            icon: AppAssets.iconGateOut,
          ),
        ),
      ],
    );
  }
}
