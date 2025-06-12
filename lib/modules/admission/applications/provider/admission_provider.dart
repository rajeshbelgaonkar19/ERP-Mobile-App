import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/student_application.dart';
import '../service/admission_service.dart';

final admissionServiceProvider = Provider((ref) => AdmissionService());

final selectedAcademicYearProvider = StateProvider<String?>((ref) => null);
final academicIdMap = {
  '2025-26': 0,
  '2024-25': 1,
  '2023-24': 2,
  '2022-23': 3,
  '2021-22': 4,
};

final studentApplicationsProvider = FutureProvider.autoDispose<List<StudentApplication>>((ref) async {
  final selectedYear = ref.watch(selectedAcademicYearProvider);
  if (selectedYear == null) return [];

  final academicId = academicIdMap[selectedYear] ?? 1;
  final service = ref.watch(admissionServiceProvider);

  return service.fetchApplications(academicId);
<<<<<<< HEAD
});
=======
});
>>>>>>> f863c1580f330f6827e97bf8d1a5547db5c12d6d
