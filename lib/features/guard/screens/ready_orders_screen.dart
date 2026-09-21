import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/constants/route_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/widgets/app_scaffold.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/app_text_field.dart';
import 'package:rainbow_app/core/widgets/async_state_view.dart';
import 'package:rainbow_app/features/guard/models/ready_order.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';
import 'package:rainbow_app/features/guard/widgets/ready_order_card.dart';

/// Sales orders that are confirmed and still have quantities to dispatch.
///
/// Tapping one opens gate-in already bound to that order, which is the common
/// path: the guard is looking at the order number the driver quoted. Search
/// is client-side — the endpoint returns the queue in one call, so filtering
/// locally is instant and keeps working once loaded.
class ReadyOrdersScreen extends ConsumerStatefulWidget {
  const ReadyOrdersScreen({super.key});

  @override
  ConsumerState<ReadyOrdersScreen> createState() => _ReadyOrdersScreenState();
}

class _ReadyOrdersScreenState extends ConsumerState<ReadyOrdersScreen> {
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

    return AppScaffold(
      title: context.l10n.guardReadyOrdersTitle,
      subtitle: context.l10n.guardReadyOrdersSubtitle,
      padded: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: AppSpacing.screenHeader,
            child: ContentWidthCap(
              child: AppTextField(
                label: context.l10n.actionSearch,
                hint: context.l10n.searchOrdersHint,
                controller: _search,
                leadingIcon: AppAssets.iconSearch,
                textInputAction: TextInputAction.search,
                onChanged: (String value) =>
                    setState(() => _query = value.trim()),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async => ref.invalidate(readyOrdersProvider),
              child: AsyncStateView<List<ReadyOrder>>(
                value: orders,
                onRetry: () => ref.invalidate(readyOrdersProvider),
                data: (BuildContext context, List<ReadyOrder> all) {
                  final List<ReadyOrder> list = all
                      .where((ReadyOrder o) => o.matches(_query))
                      .toList(growable: false);

                  if (list.isEmpty) {
                    return ListView(
                      children: <Widget>[
                        AppEmptyState(
                          icon: _query.isEmpty
                              ? AppAssets.iconOrders
                              : AppAssets.iconSearch,
                          title: _query.isEmpty
                              ? context.l10n.emptyReadyOrdersTitle
                              : context.l10n.emptySearchTitle,
                          message: _query.isEmpty
                              ? context.l10n.emptyReadyOrdersMessage
                              : context.l10n.emptySearchMessage,
                          actionLabel: _query.isEmpty
                              ? context.l10n.actionRefresh
                              : null,
                          onAction: _query.isEmpty
                              ? () => ref.invalidate(readyOrdersProvider)
                              : null,
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: AppSpacing.listContentUnderHeader,
                    itemCount: list.length,
                    separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
                    itemBuilder: (BuildContext context, int index) =>
                        ContentWidthCap(
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
