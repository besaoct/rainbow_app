import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/extensions/iterable_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/helpers/validators.dart';
import 'package:rainbow_app/core/network/api_failure.dart';
import 'package:rainbow_app/core/providers/master_data_providers.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_feedback.dart';
import 'package:rainbow_app/core/widgets/app_scaffold.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/app_text_field.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';
import 'package:rainbow_app/features/auth/providers/auth_providers.dart';
import 'package:rainbow_app/features/guard/models/gate_entry.dart';
import 'package:rainbow_app/features/guard/models/gate_in_request.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';
import 'package:rainbow_app/features/guard/models/transporter.dart';
import 'package:rainbow_app/features/guard/models/vehicle_lookup.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';
import 'package:rainbow_app/features/guard/widgets/location_picker.dart';
import 'package:rainbow_app/features/guard/widgets/order_picker.dart';
import 'package:rainbow_app/features/guard/widgets/transporter_picker.dart';

/// Registers an arriving vehicle against a sales order and issues a gate pass.
class GateInScreen extends ConsumerStatefulWidget {
  const GateInScreen({this.initialOrderId, super.key});

  /// Pre-selects an order when the screen is opened from the ready-orders
  /// list.
  final int? initialOrderId;

  @override
  ConsumerState<GateInScreen> createState() => _GateInScreenState();
}

class _GateInScreenState extends ConsumerState<GateInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _vehicleNo = TextEditingController();
  final TextEditingController _driverName = TextEditingController();
  final TextEditingController _driverPhone = TextEditingController();
  final TextEditingController _transporter = TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  Timer? _lookupDebounce;

  ReadyOrder? _order;
  AssignedLocation? _location;
  bool _isSubmitting = false;
  String? _orderError;
  String? _locationError;
  Map<String, List<String>> _fieldErrors = const <String, List<String>>{};

  @override
  void initState() {
    super.initState();
    if (widget.initialOrderId != null) {
      // The orders may still be loading; adopt the pre-selection as soon as
      // they arrive rather than blocking the form on them.
      WidgetsBinding.instance.addPostFrameCallback((_) => _adoptInitialOrder());
    }
  }

  @override
  void dispose() {
    _lookupDebounce?.cancel();
    _vehicleNo.dispose();
    _driverName.dispose();
    _driverPhone.dispose();
    _transporter.dispose();
    _remarks.dispose();
    super.dispose();
  }

  void _onVehicleNoChanged(String value) {
    _lookupDebounce?.cancel();
    final String clean = value.replaceAll(RegExp(r'\s+'), '');
    if (clean.length < 5) return;
    _lookupDebounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final VehicleLookup? lookup = await ref
            .read(guardRepositoryProvider)
            .lookupVehicle(value);
        if (lookup != null && mounted) {
          setState(() {
            if (_driverName.text.trim().isEmpty &&
                lookup.driverName.isNotEmpty) {
              _driverName.text = lookup.driverName;
            }
            if (_driverPhone.text.trim().isEmpty &&
                lookup.driverPhone.isNotEmpty) {
              _driverPhone.text = lookup.driverPhone;
            }
            if (_transporter.text.trim().isEmpty &&
                lookup.transporterName.isNotEmpty) {
              _transporter.text = lookup.transporterName;
            }
          });
        }
      } on Exception {
        // Silently continue if lookup fails
      }
    });
  }

  void _adoptInitialOrder() {
    final List<ReadyOrder>? orders = ref.read(readyOrdersProvider).value;
    final ReadyOrder? match = orders?.firstWhereOrNull(
      (ReadyOrder o) => o.id == widget.initialOrderId,
    );
    if (match != null && mounted) _selectOrder(match);
  }

  /// Choosing an order also fixes the location: the order already belongs to
  /// one, and registering the vehicle anywhere else would be a data error.
  void _selectOrder(ReadyOrder order) {
    setState(() {
      _order = order;
      _orderError = null;
      _location = _locationsFor(
        order,
      ).firstWhereOrNull((AssignedLocation l) => l.id == order.locationId);
      _locationError = null;
    });
  }

  /// The locations offered: dynamic locations from the API + the account's assignments,
  /// plus the selected order's own location when it is not among them.
  List<AssignedLocation> _locationsFor(ReadyOrder? order) {
    final List<AssignedLocation> dynamicLocations =
        ref.watch(locationsProvider).value ?? const <AssignedLocation>[];
    final List<AssignedLocation> assigned =
        ref.read(currentUserProvider)?.assignedLocations ??
        const <AssignedLocation>[];

    final Map<int, AssignedLocation> unique = <int, AssignedLocation>{};
    for (final AssignedLocation loc in <AssignedLocation>[
      ...assigned,
      ...dynamicLocations,
    ]) {
      unique[loc.id] = loc;
    }

    if (order != null && !unique.containsKey(order.locationId)) {
      unique[order.locationId] = AssignedLocation(
        id: order.locationId,
        name: order.locationName,
        code: '',
      );
    }

    return unique.values.toList(growable: false);
  }

  Future<void> _pickOrder() async {
    final ReadyOrder? picked = await AppSheet.show<ReadyOrder>(
      context,
      title: context.l10n.guardSelectOrderTitle,
      builder: (_) => OrderPicker(selectedId: _order?.id),
    );
    if (picked != null) _selectOrder(picked);
  }

  Future<void> _pickLocation() async {
    final List<AssignedLocation> locations = _locationsFor(_order);
    if (locations.isEmpty) return;
    final AssignedLocation? picked = await AppSheet.show<AssignedLocation>(
      context,
      title: context.l10n.guardSelectLocationTitle,
      builder: (_) =>
          LocationPicker(locations: locations, selectedId: _location?.id),
    );
    if (picked != null) {
      setState(() {
        _location = picked;
        _locationError = null;
      });
    }
  }

  Future<void> _submit() async {
    context.dismissKeyboard();
    final bool formValid = _formKey.currentState?.validate() ?? false;
    final ReadyOrder? order = _order;
    final AssignedLocation? location = _location;

    setState(() {
      _orderError = order == null ? context.l10n.validationOrderRequired : null;
      _locationError = location == null
          ? context.l10n.validationLocationRequired
          : null;
    });
    if (!formValid || order == null || location == null) return;

    setState(() {
      _isSubmitting = true;
      _fieldErrors = const <String, List<String>>{};
    });

    try {
      final GateEntry entry = await ref
          .read(gateInControllerProvider.notifier)
          .submit(
            GateInRequest(
              vehicleNo: _vehicleNo.text,
              salesOrderId: order.id,
              locationId: location.id,
              driverName: _driverName.text,
              driverPhone: _driverPhone.text,
              transporterName: _transporter.text,
              remarks: _remarks.text,
            ),
          );
      if (!mounted) return;
      AppSnackbar.success(
        context,
        context.l10n.guardGateInSuccessMessage(
          entry.gatePassNo,
          Formatters.vehicleNumber(entry.vehicleNo),
        ),
      );
      Navigator.of(context).pop();
    } on ApiFailure catch (failure) {
      if (!mounted) return;
      setState(() {
        _fieldErrors = failure is ValidationFailure
            ? failure.fieldErrors
            : const <String, List<String>>{};
      });
      AppSnackbar.error(context, failure.localizedMessage(context.l10n));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<AssignedLocation> locations = _locationsFor(_order);

    return AppScaffold(
      title: context.l10n.guardGateInTitle,
      subtitle: context.l10n.guardGateInSubtitle,
      scrollable: true,
      bottomBar: AppButton(
        label: context.l10n.guardGateInSubmit,
        icon: AppAssets.iconGateIn,
        isBusy: _isSubmitting,
        onPressed: () => unawaited(_submit()),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PickerField(
              label: context.l10n.salesOrderLabel,
              placeholder: context.l10n.salesOrderHint,
              icon: AppAssets.iconDocument,
              value: _order?.orderNo,
              secondary: _order?.customerName,
              errorText: _orderError ?? _fieldErrors['sales_order_id']?.first,
              enabled: !_isSubmitting,
              onTap: () => unawaited(_pickOrder()),
            ),
            SizedBox(height: AppSpacing.lg),
            PickerField(
              label: context.l10n.locationLabel,
              placeholder: context.l10n.locationHint,
              icon: AppAssets.iconWarehouse,
              value: _location?.name,
              secondary: _location?.code,
              errorText: _locationError ?? _fieldErrors['location_id']?.first,
              enabled: !_isSubmitting && locations.isNotEmpty,
              onTap: () => unawaited(_pickLocation()),
            ),
            if (locations.isEmpty) ...<Widget>[
              SizedBox(height: AppSpacing.sm),
              AppInlineError(message: context.l10n.homeNoAssignedLocations),
            ],
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.vehicleNumberLabel,
              hint: context.l10n.vehicleNumberHint,
              controller: _vehicleNo,
              enabled: !_isSubmitting,
              textCapitalization: TextCapitalization.characters,
              leadingIcon: AppAssets.iconTruck,
              textInputAction: TextInputAction.next,
              errorText: _fieldErrors['vehicle_no']?.first,
              onChanged: _onVehicleNoChanged,
              inputFormatters: const <TextInputFormatter>[
                UpperCaseTextFormatter(),
              ],
              validator: (String? v) =>
                  Validators.vehicleNumber(v, context.l10n),
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.driverNameLabel,
              hint: context.l10n.driverNameHint,
              controller: _driverName,
              enabled: !_isSubmitting,
              leadingIcon: AppAssets.iconUser,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              maxLength: AppConstants.maxNameLength,
              errorText: _fieldErrors['driver_name']?.first,
              validator: (String? v) => Validators.driverName(v, context.l10n),
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.driverPhoneLabel,
              hint: context.l10n.driverPhoneHint,
              controller: _driverPhone,
              enabled: !_isSubmitting,
              isOptional: true,
              leadingIcon: AppAssets.iconPhone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              errorText: _fieldErrors['driver_phone']?.first,
              validator: (String? v) =>
                  Validators.optionalPhone(v, context.l10n),
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.transporterLabel,
              hint: context.l10n.transporterHint,
              controller: _transporter,
              enabled: !_isSubmitting,
              isOptional: true,
              leadingIcon: AppAssets.iconWarehouse,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              maxLength: AppConstants.maxNameLength,
              errorText: _fieldErrors['transporter_name']?.first,
              onChanged: (_) => setState(() {}),
              validator: (String? v) => Validators.maxLength(
                v,
                AppConstants.maxNameLength,
                context.l10n,
              ),
            ),
            TransporterPicker(
              transporters:
                  ref.watch(transportersProvider(null)).value ??
                  const <Transporter>[],
              selectedName: _transporter.text,
              enabled: !_isSubmitting,
              onSelected: (String? name) {
                setState(() {
                  _transporter.text = name ?? '';
                  // Keep the caret after the inserted name so the field is
                  // immediately editable for a correction.
                  _transporter.selection = TextSelection.collapsed(
                    offset: _transporter.text.length,
                  );
                });
              },
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.remarksLabel,
              hint: context.l10n.remarksHint,
              controller: _remarks,
              enabled: !_isSubmitting,
              isOptional: true,
              maxLines: 3,
              minLines: 2,
              maxLength: AppConstants.maxRemarksLength,
              textInputAction: TextInputAction.newline,
              errorText: _fieldErrors['remarks']?.first,
              validator: (String? v) => Validators.maxLength(
                v,
                AppConstants.maxRemarksLength,
                context.l10n,
              ),
            ),
            // Clears the bottom action bar so the last field is reachable.
            SizedBox(height: AppSize.buttonHeight + AppSpacing.huge),
          ],
        ),
      ),
    );
  }
}
