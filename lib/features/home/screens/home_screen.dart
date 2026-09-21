import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_app/core/constants/asset_constants.dart';
import 'package:rainbow_app/core/constants/route_constants.dart';
import 'package:rainbow_app/core/enums/user_role.dart';
import 'package:rainbow_app/core/extensions/build_context_x.dart';
import 'package:rainbow_app/core/helpers/formatters.dart';
import 'package:rainbow_app/core/providers/master_data_providers.dart';
import 'package:rainbow_app/core/theme/app_dimensions.dart';
import 'package:rainbow_app/core/theme/app_typography.dart';
import 'package:rainbow_app/core/widgets/app_card.dart';
import 'package:rainbow_app/core/widgets/app_scaffold.dart';
import 'package:rainbow_app/core/widgets/app_state_views.dart';
import 'package:rainbow_app/core/widgets/responsive_layout.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';
import 'package:rainbow_app/features/auth/providers/auth_providers.dart';
import 'package:rainbow_app/features/guard/models/gate_entry.dart';
import 'package:rainbow_app/features/guard/providers/guard_providers.dart';
import 'package:rainbow_app/features/guard/widgets/gate_entry_card.dart';
import 'package:rainbow_app/features/home/models/dashboard_summary.dart';
import 'package:rainbow_app/features/home/widgets/home_header.dart';
import 'package:rainbow_app/features/home/widgets/quick_action_card.dart';
import 'package:rainbow_app/features/store/models/entered_vehicle.dart';
import 'package:rainbow_app/features/store/providers/store_providers.dart';

/// The role-aware dashboard.
///
/// A guard sees the gate queue and the way into registration; a store manager
/// sees what is waiting to be loaded. An administrator holds both roles and
/// sees both sections.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthUser? user = ref.watch(currentUserProvider);
    if (user == null) {
      // The router redirects a signed-out session away from here; this only
      // covers the frame between sign-out and that redirect.
      return const Scaffold(body: AppLoadingView());
    }

    final UserRole role = user.role;

    return AppScaffold(
      scrollable: true,
      maxContentWidth: AppSize.maxWideContentWidth,
      onRefresh: () async {
        ref.invalidate(dashboardSummaryProvider);
        if (role.canOperateGate) {
          ref
            ..invalidate(recentVehiclesProvider)
            ..invalidate(readyOrdersProvider);
        }
        if (role.canOperateStore) {
          ref.invalidate(enteredVehiclesProvider);
        }
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HomeHeader(
            user: user,
            onOpenSettings: () => context.pushNamed(AppRoutes.settingsName),
          ),
          SizedBox(height: AppSpacing.xxl),
          // On a tablet the dashboard splits: the actions and the locations
          // stay narrow on the left while the queues take the wider column,
          // rather than stretching one column across the whole window.
          ResponsiveLayout(
            compact: (BuildContext context) =>
                _Sections(user: user, role: role, stacked: true),
            expanded: (BuildContext context) =>
                _Sections(user: user, role: role, stacked: false),
          ),
        ],
      ),
    );
  }
}

/// The dashboard's sections, in one column or two.
class _Sections extends StatelessWidget {
  const _Sections({
    required this.user,
    required this.role,
    required this.stacked,
  });

  final AuthUser user;
  final UserRole role;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final List<Widget> actions = <Widget>[
      AppSectionHeader(title: context.l10n.homeQuickActions),
      _QuickActions(role: role),
      if (user.assignedLocations.isNotEmpty) ...<Widget>[
        SizedBox(height: AppSpacing.xxl),
        AppSectionHeader(title: context.l10n.homeAssignedLocations),
        _Locations(locations: user.assignedLocations),
      ],
    ];

    final List<Widget> queues = <Widget>[
      if (role.canOperateStore) ...<Widget>[
        const _StoreQueue(),
        SizedBox(height: AppSpacing.xxl),
      ],
      if (role.canOperateGate) const _GateSummary(),
    ];

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ...actions,
          SizedBox(height: AppSpacing.xxl),
          ...queues,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: actions,
          ),
        ),
        SizedBox(width: AppSpacing.xxl),
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: queues,
          ),
        ),
      ],
    );
  }
}

/// The dashboard's tiles, with the size of each queue where there is one.
///
/// Counts come from providers the dashboard already loads and already
/// refreshes, so showing them costs no extra request: a guard can see there
/// are orders waiting without opening the list.
class _QuickActions extends ConsumerWidget {
  const _QuickActions({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Counts come from the summary endpoint rather than from the length of a
    // list: `orders-ready` caps its page, so counting its rows under-reports
    // the queue — the server reports 32 where the list returns 15. The list
    // length is kept only as a fallback for when the summary call fails, so
    // a tile shows an approximate number instead of none at all.
    final DashboardSummary? summary = ref.watch(dashboardSummaryProvider).value;
    final int? readyOrders = role.canOperateGate
        ? (summary?.readyOrdersCount ??
              ref.watch(readyOrdersProvider).value?.length)
        : null;
    final int? insideGate = role.canOperateStore
        ? (summary?.vehiclesInsideGateCount ??
              ref.watch(enteredVehiclesProvider).value?.length)
        : null;

    return ResponsiveGrid(
      mediumColumns: 2,
      expandedColumns: 2,
      children: <Widget>[
        if (role.canOperateGate) ...<Widget>[
          QuickActionCard(
            icon: AppAssets.iconGateIn,
            label: context.l10n.quickActionGateIn,
            accent: context.colors.markEntered,
            onTap: () => context.pushNamed(AppRoutes.guardGateInName),
          ),
          QuickActionCard(
            icon: AppAssets.iconOrders,
            label: context.l10n.quickActionReadyOrders,
            accent: context.colorScheme.secondary,
            count: readyOrders,
            onTap: () => context.pushNamed(AppRoutes.guardReadyOrdersName),
          ),
          QuickActionCard(
            icon: AppAssets.iconTruck,
            label: context.l10n.quickActionVehicles,
            onTap: () => context.pushNamed(AppRoutes.guardVehiclesName),
          ),
        ],
        if (role.canOperateStore)
          QuickActionCard(
            icon: AppAssets.iconWarehouse,
            label: context.l10n.quickActionInsideGate,
            accent: context.colors.markLoaded,
            count: insideGate,
            onTap: () => context.pushNamed(AppRoutes.storeEnteredVehiclesName),
          ),
      ],
    );
  }
}

/// A breakdown of the gate queue by colour mark, plus the newest vehicles.
class _GateSummary extends ConsumerWidget {
  const _GateSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<GateEntry>> recent = ref.watch(
      recentVehiclesProvider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppSectionHeader(
          title: context.l10n.homeRecentVehicles,
          actionLabel: context.l10n.actionViewAll,
          onAction: () => context.pushNamed(AppRoutes.guardVehiclesName),
        ),
        recent.when(
          loading: () => const AppLoadingView(),
          error: (Object error, StackTrace _) => AppInlineError(
            message: context.l10n.errorGeneric,
            onRetry: () => ref.invalidate(recentVehiclesProvider),
          ),
          data: (List<GateEntry> entries) {
            if (entries.isEmpty) {
              return AppEmptyState(
                icon: AppAssets.iconTruck,
                title: context.l10n.emptyVehiclesTitle,
                message: context.l10n.emptyVehiclesMessage,
              );
            }
            return Column(
              children: <Widget>[
                for (final GateEntry entry in entries)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md),
                    child: GateEntryCard(
                      entry: entry,
                      onTap: entry.status.canBeCleared
                          ? () => context.pushNamed(
                              AppRoutes.guardInspectionName,
                              pathParameters: <String, String>{
                                AppRoutes.vehicleIdParam: '${entry.id}',
                              },
                            )
                          : null,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// How many vehicles are waiting for the store team.
class _StoreQueue extends ConsumerWidget {
  const _StoreQueue();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<EnteredVehicle>> vehicles = ref.watch(
      enteredVehiclesProvider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppSectionHeader(
          title: context.l10n.storeEnteredVehiclesTitle,
          actionLabel: context.l10n.actionViewAll,
          onAction: () => context.pushNamed(AppRoutes.storeEnteredVehiclesName),
        ),
        vehicles.when(
          loading: () => const AppLoadingView(),
          error: (Object error, StackTrace _) => AppInlineError(
            message: context.l10n.errorGeneric,
            onRetry: () => ref.invalidate(enteredVehiclesProvider),
          ),
          data: (List<EnteredVehicle> list) {
            final int pendingLines = list.fold<int>(
              0,
              (int sum, EnteredVehicle v) => sum + v.pendingLinesCount,
            );
            return ResponsiveGrid(
              compactColumns: 2,
              mediumColumns: 3,
              expandedColumns: 3,
              children: <Widget>[
                StatTile(
                  value: Formatters.integer(list.length),
                  label: context.l10n.storeEnteredVehiclesTitle,
                  color: context.colors.markEntered,
                ),
                StatTile(
                  value: Formatters.integer(pendingLines),
                  label: context.l10n.storePendingLinesLabel,
                  color: context.colors.info,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Locations extends StatelessWidget {
  const _Locations({required this.locations});

  final List<AssignedLocation> locations;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        for (final AssignedLocation location in locations)
          Container(
            constraints: BoxConstraints(
              maxWidth: context.screenSize.width - AppSpacing.screenH * 2,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceRaised,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: context.colors.border),
            ),
            child: Text(
              location.code.isEmpty
                  ? location.name
                  : '${location.code} · ${location.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.labelSmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}
