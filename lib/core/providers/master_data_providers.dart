import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rainbow_app/core/data/master_data_repository.dart';
import 'package:rainbow_app/core/providers/core_providers.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';
import 'package:rainbow_app/features/guard/models/transporter.dart';
import 'package:rainbow_app/features/home/models/dashboard_summary.dart';

final Provider<MasterDataRepository> masterDataRepositoryProvider =
    Provider<MasterDataRepository>((Ref ref) {
  return MasterDataRepository(ref.watch(apiClientProvider));
}, name: 'masterDataRepository');

/// Active site and godown locations from `GET /locations`.
final FutureProvider<List<AssignedLocation>> locationsProvider =
    FutureProvider<List<AssignedLocation>>((Ref ref) async {
  return ref.watch(masterDataRepositoryProvider).fetchLocations(activeOnly: true);
}, name: 'locations');

/// Registered transporters from `GET /transporters`.
final transportersProvider =
    FutureProvider.family<List<Transporter>, String?>((
  Ref ref,
  String? search,
) async {
  return ref.watch(masterDataRepositoryProvider).fetchTransporters(search: search);
}, name: 'transporters');

/// Real-time operational dashboard KPIs from `GET /dashboard/summary`.
final FutureProvider<DashboardSummary> dashboardSummaryProvider =
    FutureProvider<DashboardSummary>((Ref ref) async {
  return ref.watch(masterDataRepositoryProvider).fetchDashboardSummary();
}, name: 'dashboardSummary');
