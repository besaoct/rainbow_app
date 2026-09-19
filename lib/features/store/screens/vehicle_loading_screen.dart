import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/helpers/validators.dart';
import 'package:rainbow_app/core/network/api_failure.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_feedback.dart';
import 'package:rainbow_app/core/widgets/app_scaffold.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/app_text_field.dart';
import 'package:rainbow_app/core/widgets/async_state_view.dart';
import 'package:rainbow_app/features/store/models/load_request.dart';
import 'package:rainbow_app/features/store/models/order_item.dart';
import 'package:rainbow_app/features/store/providers/store_providers.dart';
import 'package:rainbow_app/features/store/widgets/load_line_tile.dart';

/// Records what was physically loaded onto a vehicle.
///
/// Submitting moves the vehicle to the red mark and puts it in the guard's
/// exit-clearance queue, so the quantities are checked twice: against the
/// pending quantity and against the stock on hand.
class VehicleLoadingScreen extends ConsumerStatefulWidget {
  const VehicleLoadingScreen({required this.vehicleId, super.key});

  final int vehicleId;

  @override
  ConsumerState<VehicleLoadingScreen> createState() =>
      _VehicleLoadingScreenState();
}

class _VehicleLoadingScreenState extends ConsumerState<VehicleLoadingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<int, TextEditingController> _quantities =
      <int, TextEditingController>{};
  final TextEditingController _challan = TextEditingController();
  final TextEditingController _eway = TextEditingController();
  final TextEditingController _invoice = TextEditingController();
  final TextEditingController _remarks = TextEditingController();

  bool _isSubmitting = false;
  String? _summaryError;
  Map<String, List<String>> _fieldErrors = const <String, List<String>>{};

  @override
  void dispose() {
    for (final TextEditingController controller in _quantities.values) {
      controller.dispose();
    }
    _challan.dispose();
    _eway.dispose();
    _invoice.dispose();
    _remarks.dispose();
    super.dispose();
  }

  /// One controller per line, created lazily so the list can arrive after the
  /// first build and controllers survive rebuilds.
  TextEditingController _controllerFor(OrderItem item) =>
      _quantities.putIfAbsent(item.salesOrderLineId, TextEditingController.new);

  List<LoadLine> _collectLines(List<OrderItem> items) {
    final List<LoadLine> lines = <LoadLine>[];
    for (final OrderItem item in items) {
      final int pieces =
          int.tryParse(_quantities[item.salesOrderLineId]?.text.trim() ?? '') ??
          0;
      if (pieces <= 0) continue;
      lines.add(
        LoadLine(
          salesOrderLineId: item.salesOrderLineId,
          qtyPcs: pieces,
          qtyBox: item.boxesFor(pieces),
        ),
      );
    }
    return lines;
  }

  Future<void> _submit(List<OrderItem> items) async {
    context.dismissKeyboard();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final List<LoadLine> lines = _collectLines(items);
    if (lines.isEmpty) {
      setState(
        () => _summaryError = context.l10n.validationSelectAtLeastOneItem,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _summaryError = null;
      _fieldErrors = const <String, List<String>>{};
    });

    try {
      final LoadResult result = await ref
          .read(loadControllerProvider.notifier)
          .submit(
            vehicleId: widget.vehicleId,
            request: LoadRequest(
              lines: lines,
              challanNo: _challan.text,
              ewayBillNo: _eway.text,
              invoiceNo: _invoice.text,
              remarks: _remarks.text,
            ),
          );
      if (!mounted) return;
      AppSnackbar.success(
        context,
        context.l10n.storeLoadingSuccessMessage(
          Formatters.vehicleNumber(result.vehicleNo),
        ),
      );
      Navigator.of(context).pop();
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        _fieldErrors = failure is ValidationFailure
            ? failure.fieldErrors
            : const <String, List<String>>{};
        _summaryError = failure.localizedMessage(context.l10n);
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<VehicleOrderItems> order = ref.watch(
      vehicleOrderItemsProvider(widget.vehicleId),
    );
    final VehicleOrderItems? loaded = order.value;
    final bool canSubmit = loaded != null && loaded.items.isNotEmpty;

    return AppScaffold(
      title: context.l10n.storeLoadingTitle,
      subtitle: context.l10n.storeLoadingSubtitle,
      scrollable: true,
      onRefresh: () async =>
          ref.invalidate(vehicleOrderItemsProvider(widget.vehicleId)),
      bottomBar: canSubmit
          ? AppButton(
              label: context.l10n.storeSubmitLoading,
              icon: AppAssets.iconBox,
              isBusy: _isSubmitting,
              onPressed: () => unawaited(_submit(loaded.items)),
            )
          : null,
      body: AsyncStateView<VehicleOrderItems>(
        value: order,
        onRetry: () =>
            ref.invalidate(vehicleOrderItemsProvider(widget.vehicleId)),
        data: (BuildContext context, VehicleOrderItems data) {
          if (data.isEmpty) {
            return AppEmptyState(
              icon: AppAssets.iconCheckCircle,
              title: context.l10n.emptyOrderItemsTitle,
              message: context.l10n.emptyOrderItemsMessage,
            );
          }
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _VehicleHeader(order: data),
                SizedBox(height: AppSpacing.xl),
                if (_summaryError != null) ...<Widget>[
                  AppInlineError(message: _summaryError!),
                  SizedBox(height: AppSpacing.lg),
                ],
                AppSectionHeader(
                  title: context.l10n.storeItemsSummary(
                    _collectLines(data.items).length,
                    data.items.length,
                  ),
                ),
                for (final OrderItem item in data.items)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: LoadLineTile(
                      item: item,
                      controller: _controllerFor(item),
                      enabled: !_isSubmitting,
                      // Recomputes the derived box count and the "n of m"
                      // summary as the manager types.
                      onChanged: (_) => setState(() => _summaryError = null),
                    ),
                  ),
                SizedBox(height: AppSpacing.lg),
                AppSectionHeader(title: context.l10n.inspectionDocumentsTitle),
                _Documents(
                  challan: _challan,
                  eway: _eway,
                  invoice: _invoice,
                  remarks: _remarks,
                  enabled: !_isSubmitting,
                  fieldErrors: _fieldErrors,
                ),
                SizedBox(height: AppSize.buttonHeight + AppSpacing.huge),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _VehicleHeader extends StatelessWidget {
  const _VehicleHeader({required this.order});

  final VehicleOrderItems order;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            Formatters.vehicleNumber(order.vehicleNo),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.displaySmall.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppDetailRow(
            label: context.l10n.gatePassLabel,
            value: order.gatePassNo,
          ),
          AppDetailRow(
            label: context.l10n.orderNumberLabel,
            value: order.orderNo,
          ),
          AppDetailRow(
            label: context.l10n.orderCustomerLabel,
            value: order.customerName,
          ),
          AppDetailRow(
            label: context.l10n.driverNameLabel,
            value: order.driverName,
          ),
        ],
      ),
    );
  }
}

class _Documents extends StatelessWidget {
  const _Documents({
    required this.challan,
    required this.eway,
    required this.invoice,
    required this.remarks,
    required this.enabled,
    required this.fieldErrors,
  });

  final TextEditingController challan;
  final TextEditingController eway;
  final TextEditingController invoice;
  final TextEditingController remarks;
  final bool enabled;
  final Map<String, List<String>> fieldErrors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppTextField(
          label: context.l10n.challanNumberLabel,
          hint: context.l10n.challanNumberHint,
          controller: challan,
          enabled: enabled,
          isOptional: true,
          leadingIcon: AppAssets.iconDocument,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.next,
          maxLength: AppConstants.maxDocumentNumberLength,
          errorText: fieldErrors['challan_no']?.first,
          validator: (String? v) => Validators.maxLength(
            v,
            AppConstants.maxDocumentNumberLength,
            context.l10n,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: context.l10n.ewayBillNumberLabel,
          hint: context.l10n.ewayBillNumberHint,
          controller: eway,
          enabled: enabled,
          isOptional: true,
          leadingIcon: AppAssets.iconDocument,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.next,
          maxLength: AppConstants.maxDocumentNumberLength,
          errorText: fieldErrors['eway_bill_no']?.first,
          validator: (String? v) => Validators.maxLength(
            v,
            AppConstants.maxDocumentNumberLength,
            context.l10n,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: context.l10n.invoiceNumberLabel,
          hint: context.l10n.invoiceNumberHint,
          controller: invoice,
          enabled: enabled,
          isOptional: true,
          leadingIcon: AppAssets.iconDocument,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.next,
          maxLength: AppConstants.maxDocumentNumberLength,
          errorText: fieldErrors['invoice_no']?.first,
          validator: (String? v) => Validators.maxLength(
            v,
            AppConstants.maxDocumentNumberLength,
            context.l10n,
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: context.l10n.loadingRemarksLabel,
          hint: context.l10n.remarksHint,
          controller: remarks,
          enabled: enabled,
          isOptional: true,
          maxLines: 3,
          minLines: 2,
          maxLength: AppConstants.maxRemarksLength,
          errorText: fieldErrors['remarks']?.first,
          validator: (String? v) => Validators.maxLength(
            v,
            AppConstants.maxRemarksLength,
            context.l10n,
          ),
        ),
      ],
    );
  }
}
