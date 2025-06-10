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
