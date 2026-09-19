import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/constants/route_constants.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_durations.dart';
import 'package:rainbow_app/core/widgets/app_scaffold.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/app_text_field.dart';
import 'package:rainbow_app/core/widgets/async_state_view.dart';
import 'package:rainbow_app/features/guard/models/gate_entry.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';
import 'package:rainbow_app/features/guard/widgets/gate_entry_card.dart';
import 'package:rainbow_app/features/guard/widgets/vehicle_filter_bar.dart';

/// Every vehicle registered at this gate, filterable by colour mark.
class VehiclesScreen extends ConsumerStatefulWidget {
  const VehiclesScreen({super.key});

  @override
  ConsumerState<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends ConsumerState<VehiclesScreen> {
  final TextEditingController _search = TextEditingController();
  final ScrollController _scroll = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _search.text = ref.read(vehicleFilterProvider).query;
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _search.dispose();
    super.dispose();
  }

  /// Requests the next page a little before the list actually ends, so the
  /// guard does not see a spinner at the bottom while scrolling.
  void _onScroll() {
    if (!_scroll.hasClients) return;
    final double remaining =
        _scroll.position.maxScrollExtent - _scroll.position.pixels;
    if (remaining < AppSize.buttonHeight * 4) {
      unawaited(ref.read(vehiclesProvider.notifier).loadMore());
    }
  }

  /// Search hits the server, so wait for a pause in typing.
  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      AppDurations.searchDebounce,
      () => ref.read(vehicleFilterProvider.notifier).setQuery(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PagedResult<GateEntry>> vehicles = ref.watch(
      vehiclesProvider,
    );
    final VehicleFilter filter = ref.watch(vehicleFilterProvider);

    return AppScaffold(
      title: context.l10n.guardVehiclesTitle,
      subtitle: context.l10n.guardVehiclesSubtitle,
      padded: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: AppSpacing.screenHeader,
            child: ContentWidthCap(
              child: AppTextField(
                label: context.l10n.actionSearch,
                hint: context.l10n.searchVehiclesHint,
                controller: _search,
                leadingIcon: AppAssets.iconSearch,
                textInputAction: TextInputAction.search,
                onChanged: _onQueryChanged,
              ),
            ),
          ),
          VehicleFilterBar(
            selected: filter.status,
            onChanged: ref.read(vehicleFilterProvider.notifier).setStatus,
          ),
          SizedBox(height: AppSpacing.sm),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: ref.read(vehiclesProvider.notifier).refresh,
              child: AsyncStateView<PagedResult<GateEntry>>(
                value: vehicles,
                onRetry: () => ref.invalidate(vehiclesProvider),
                isEmpty: (PagedResult<GateEntry> page) => page.items.isEmpty,
                empty: (BuildContext context) => ListView(
                  children: <Widget>[
                    AppEmptyState(
                      icon: AppAssets.iconTruck,
                      title: context.l10n.emptyVehiclesTitle,
                      message: filter.status == null && filter.query.isEmpty
                          ? context.l10n.emptyVehiclesMessage
                          : context.l10n.emptyVehiclesFilteredMessage,
                    ),
                  ],
                ),
                data: (BuildContext context, PagedResult<GateEntry> page) {
                  return ListView.separated(
                    controller: _scroll,
                    padding: AppSpacing.listContentUnderHeader,
                    itemCount: page.items.length + (page.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => SizedBox(height: AppSpacing.md),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= page.items.length) {
                        return Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: const AppLoadingIndicator(),
                        );
                      }
                      final GateEntry entry = page.items[index];
                      return ContentWidthCap(
                        child: GateEntryCard(
                          entry: entry,
                          onTap: () => context.pushNamed(
                            AppRoutes.guardInspectionName,
                            pathParameters: <String, String>{
                              AppRoutes.vehicleIdParam: '${entry.id}',
                            },
                          ),
                        ),
                      );
                    },
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
