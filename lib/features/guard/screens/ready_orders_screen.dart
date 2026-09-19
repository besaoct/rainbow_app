import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/constants/route_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_scaffold.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/async_state_view.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';
import 'package:rainbow_app/features/guard/widgets/ready_order_card.dart';

/// Sales orders that are confirmed and still have quantities to dispatch.
///
/// Tapping one opens gate-in already bound to that order, which is the common
/// path: the guard is looking at the order number the driver quoted.
class ReadyOrdersScreen extends ConsumerWidget {
  const ReadyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ReadyOrder>> orders = ref.watch(readyOrdersProvider);

    return AppScaffold(
      title: context.l10n.guardReadyOrdersTitle,
      subtitle: context.l10n.guardReadyOrdersSubtitle,
      padded: false,
      onRefresh: () async => ref.invalidate(readyOrdersProvider),
      body: AsyncStateView<List<ReadyOrder>>(
        value: orders,
        onRetry: () => ref.invalidate(readyOrdersProvider),
        isEmpty: (List<ReadyOrder> list) => list.isEmpty,
        empty: (BuildContext context) => ListView(
          children: <Widget>[
            AppEmptyState(
              icon: AppAssets.iconOrders,
              title: context.l10n.emptyReadyOrdersTitle,
              message: context.l10n.emptyReadyOrdersMessage,
              actionLabel: context.l10n.actionRefresh,
              onAction: () => ref.invalidate(readyOrdersProvider),
            ),
          ],
        ),
        data: (BuildContext context, List<ReadyOrder> list) =>
            ListView.separated(
              padding: AppSpacing.listContent,
              itemCount: list.length,
              separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
              itemBuilder: (BuildContext context, int index) => ContentWidthCap(
                child: ReadyOrderCard(
                  order: list[index],
                  onTap: () => context.pushNamed(
                    AppRoutes.guardGateInName,
                    queryParameters: <String, String>{
                      'orderId': '${list[index].id}',
                    },
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
