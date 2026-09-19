import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_icon.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/app_text_field.dart';
import 'package:rainbow_app/core/widgets/async_state_view.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';
import 'package:rainbow_app/features/guard/widgets/ready_order_card.dart';

/// The searchable list of dispatchable orders shown inside a bottom sheet.
///
/// Search runs on the client: the endpoint returns the whole ready queue in
/// one call, so filtering locally is instant and works offline once loaded.
class OrderPicker extends ConsumerStatefulWidget {
  const OrderPicker({this.selectedId, super.key});

  final int? selectedId;

  @override
  ConsumerState<OrderPicker> createState() => _OrderPickerState();
}

class _OrderPickerState extends ConsumerState<OrderPicker> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ReadyOrder>> orders = ref.watch(readyOrdersProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: AppSpacing.screenHorizontal,
          child: AppTextField(
            label: context.l10n.actionSearch,
            hint: context.l10n.searchOrdersHint,
            controller: _search,
            leadingIcon: AppAssets.iconSearch,
            textInputAction: TextInputAction.search,
            onChanged: (String value) => setState(() => _query = value.trim()),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Flexible(
          child: AsyncStateView<List<ReadyOrder>>(
            value: orders,
            onRetry: () => ref.invalidate(readyOrdersProvider),
            data: (BuildContext context, List<ReadyOrder> all) {
              final List<ReadyOrder> filtered = all
                  .where((ReadyOrder o) => o.matches(_query))
                  .toList(growable: false);
              if (filtered.isEmpty) {
                return AppEmptyState(
                  icon: AppAssets.iconSearch,
                  title: _query.isEmpty
                      ? context.l10n.emptyReadyOrdersTitle
                      : context.l10n.emptySearchTitle,
                  message: _query.isEmpty
                      ? context.l10n.emptyReadyOrdersMessage
                      : context.l10n.emptySearchMessage,
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenH,
                  0,
                  AppSpacing.screenH,
                  AppSpacing.xl,
                ),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
                itemBuilder: (BuildContext context, int index) {
                  final ReadyOrder order = filtered[index];
                  return ReadyOrderCard(
                    order: order,
                    isSelected: order.id == widget.selectedId,
                    onTap: () => Navigator.of(context).pop(order),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

/// A form field that opens a picker sheet and shows the current choice.
class PickerField extends StatelessWidget {
  const PickerField({
    required this.label,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.secondary,
    this.icon,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  /// Localised field label.
  final String label;

  /// Localised text shown when nothing is chosen.
  final String placeholder;

  final VoidCallback onTap;

  /// The chosen value's primary line.
  final String? value;

  /// An optional second line under [value].
  final String? secondary;

  /// Path from `AppAssets`.
  final String? icon;

  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = (value ?? '').isNotEmpty;
    final Color borderColor = errorText != null
        ? context.colorScheme.error
        : context.colors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: AppRadius.inputRadius,
            child: Container(
              constraints: BoxConstraints(minHeight: AppSize.inputHeight),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? context.colors.surfaceRaised
                    : context.colors.surfaceRaised,
                borderRadius: AppRadius.inputRadius,
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: <Widget>[
                  if (icon != null) ...<Widget>[
                    AppIcon(
                      icon!,
                      size: AppIconSize.sm,
                      color: context.colors.textTertiary,
                    ),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          hasValue ? value! : placeholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: hasValue
                                ? context.colors.textPrimary
                                : context.colors.textTertiary,
                          ),
                        ),
                        if (hasValue && (secondary ?? '').isNotEmpty)
                          Text(
                            secondary!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  AppIcon(
                    AppAssets.iconChevronDown,
                    size: AppIconSize.sm,
                    color: context.colors.textTertiary,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null) ...<Widget>[
          SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
