import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admission_service.dart';

final admissionServiceProvider = Provider<AdmissionService>((ref) {
  return AdmissionService();
});

final admissionDashboardProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(admissionServiceProvider).getDashboardData();
});

final admissionBranchesProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.read(admissionServiceProvider).getBranches();
});

final admissionProgramsProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.read(admissionServiceProvider).getPrograms();
});

final admissionCategoriesProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.read(admissionServiceProvider).getCategories();
});

final admissionYearsProvider = FutureProvider<List<dynamic>>((ref) {
  return ref.read(admissionServiceProvider).getAcademicYears();
});

final pendingCountProvider = FutureProvider<Map<String, dynamic>>((ref) {
  return ref.read(admissionServiceProvider).getPendingCount();
});

final programIdMapProvider = FutureProvider<Map<String, int>>((ref) async {
  final programs = await ref.watch(admissionProgramsProvider.future);
  return {
    for (final p in programs)
      p['programm_name'] as String: p['programm_id'] as int,
  };
});
