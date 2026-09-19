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
import 'package:rainbow_app/features/store/models/entered_vehicle.dart';
import 'package:rainbow_app/features/store/providers/store_providers.dart';
import 'package:rainbow_app/features/store/widgets/entered_vehicle_card.dart';

/// The store team's queue: vehicles inside the gate waiting to be loaded.
class EnteredVehiclesScreen extends ConsumerStatefulWidget {
  const EnteredVehiclesScreen({super.key});

  @override
  ConsumerState<EnteredVehiclesScreen> createState() =>
      _EnteredVehiclesScreenState();
}

class _EnteredVehiclesScreenState extends ConsumerState<EnteredVehiclesScreen> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.text = ref.read(enteredVehicleQueryProvider);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<EnteredVehicle>> vehicles = ref.watch(
      filteredEnteredVehiclesProvider,
    );
    final String query = ref.watch(enteredVehicleQueryProvider);

    return AppScaffold(
      title: context.l10n.storeEnteredVehiclesTitle,
      subtitle: context.l10n.storeEnteredVehiclesSubtitle,
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
                onChanged: ref
                    .read(enteredVehicleQueryProvider.notifier)
                    .setQuery,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () async => ref.invalidate(enteredVehiclesProvider),
              child: AsyncStateView<List<EnteredVehicle>>(
                value: vehicles,
                onRetry: () => ref.invalidate(enteredVehiclesProvider),
                isEmpty: (List<EnteredVehicle> list) => list.isEmpty,
                empty: (BuildContext context) => ListView(
                  children: <Widget>[
                    AppEmptyState(
                      icon: AppAssets.iconTruck,
                      title: query.isEmpty
                          ? context.l10n.emptyEnteredVehiclesTitle
                          : context.l10n.emptySearchTitle,
                      message: query.isEmpty
                          ? context.l10n.emptyEnteredVehiclesMessage
                          : context.l10n.emptySearchMessage,
                    ),
                  ],
                ),
                data: (BuildContext context, List<EnteredVehicle> list) =>
                    ListView.separated(
                      padding: AppSpacing.listContentUnderHeader,
                      itemCount: list.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: AppSpacing.md),
                      itemBuilder: (BuildContext context, int index) =>
                          ContentWidthCap(
                            child: EnteredVehicleCard(
                              vehicle: list[index],
                              onStartLoading: () => context.pushNamed(
                                AppRoutes.storeLoadingName,
                                pathParameters: <String, String>{
                                  AppRoutes.vehicleIdParam: '${list[index].id}',
                                },
                              ),
                            ),
                          ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
