import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/constants/app_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/validators.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_button.dart';
import 'package:rainbow_app/core/widgets/app_text_field.dart';
import 'package:rainbow_app/features/guard/models/hold_reason.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';

/// What the guard recorded when holding a vehicle.
class HoldDecision {
  const HoldDecision({required this.reason, this.remarks});

  final String reason;
  final String? remarks;
}

/// Collects the reason a vehicle is being held.
///
/// Standardized reasons from `GET /guard/hold-reasons` are offered as one-tap
/// chips to streamline guard workflows and standardize ERP analytics.
class HoldReasonSheet extends ConsumerStatefulWidget {
  const HoldReasonSheet({super.key});

  @override
  ConsumerState<HoldReasonSheet> createState() => _HoldReasonSheetState();
}

class _HoldReasonSheetState extends ConsumerState<HoldReasonSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _remarks = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    _remarks.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      HoldDecision(reason: _reason.text.trim(), remarks: _remarks.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<HoldReason> reasons =
        ref.watch(holdReasonsProvider).value ?? const <HoldReason>[];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        0,
        AppSpacing.screenH,
        // Lift the sheet clear of the keyboard.
        AppSpacing.xl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              context.l10n.guardRejectMessage,
              style: AppTextStyles.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            if (reasons.isNotEmpty) ...<Widget>[
              SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: reasons.map((HoldReason r) {
                  final bool selected =
                      _reason.text == r.label || _reason.text == r.code;
                  return ChoiceChip(
                    label: Text(r.label),
                    selected: selected,
                    onSelected: (bool isSelected) {
                      setState(() {
                        _reason.text = isSelected ? r.label : '';
                      });
                    },
                  );
                }).toList(growable: false),
              ),
            ],
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.guardHoldReasonLabel,
              hint: context.l10n.guardHoldReasonHint,
              controller: _reason,
              autofocus: reasons.isEmpty,
              maxLength: AppConstants.maxReasonLength,
              textInputAction: TextInputAction.next,
              validator: (String? v) => Validators.holdReason(v, context.l10n),
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: context.l10n.remarksLabel,
              hint: context.l10n.remarksHint,
              controller: _remarks,
              isOptional: true,
              maxLines: 3,
              minLines: 2,
              maxLength: AppConstants.maxRemarksLength,
              validator: (String? v) => Validators.maxLength(
                v,
                AppConstants.maxRemarksLength,
                context.l10n,
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            Row(
              children: <Widget>[
                Expanded(
                  child: AppButton.secondary(
                    label: context.l10n.actionCancel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton.danger(
                    label: context.l10n.guardRejectExit,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
