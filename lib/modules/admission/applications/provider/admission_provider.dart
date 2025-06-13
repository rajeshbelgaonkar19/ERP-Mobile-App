import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/student_application.dart';
import '../service/admission_service.dart';

final admissionServiceProvider = Provider<AdmissionService>((ref) {
  return AdmissionService();
});

class AdmissionState {
  final List<String> academicYears;
  final String? selectedAcademicYear;

  final List<String> programs;
  final String? selectedProgram;

  final List<String> branches;
  final String? selectedBranch;

  AdmissionState({
    this.academicYears = const [],
    this.selectedAcademicYear,
    this.programs = const [],
    this.selectedProgram,
    this.branches = const [],
    this.selectedBranch,
  });

  AdmissionState copyWith({
    List<String>? academicYears,
    String? selectedAcademicYear,
    List<String>? programs,
    String? selectedProgram,
    List<String>? branches,
    String? selectedBranch,
  }) {
    return AdmissionState(
      academicYears: academicYears ?? this.academicYears,
      selectedAcademicYear: selectedAcademicYear ?? this.selectedAcademicYear,
      programs: programs ?? this.programs,
      selectedProgram: selectedProgram ?? this.selectedProgram,
      branches: branches ?? this.branches,
      selectedBranch: selectedBranch ?? this.selectedBranch,
    );
  }
}

class AdmissionNotifier extends StateNotifier<AdmissionState> {
  final AdmissionService _admissionService;

  AdmissionNotifier(this._admissionService) : super(AdmissionState()) {
    loadAcademicYears();
  }

  Future<void> loadAcademicYears() async {
    try {
      final years = await _admissionService.fetchAcademicYears();
      state = state.copyWith(
        academicYears: years,
      );
      // if (selected != null) {
      //   await selectAcademicYear(selected);
      // }
    } catch (e) {
      print('Error loading academic years: $e');
    }
  }

  Future<void> selectAcademicYear(String year) async {
    state = state.copyWith(
      selectedAcademicYear: year,
      programs: [],
      selectedProgram: null,
      branches: [],
      selectedBranch: null,
    );

    try {
      final programs = await _admissionService.fetchPrograms(year);
      // Ensure selectedProgram is null if not in new programs list
      String? selectedProgram = state.selectedProgram;
      if (selectedProgram == null || !programs.contains(selectedProgram)) {
        selectedProgram = null;
      }
      state = state.copyWith(programs: programs, selectedProgram: selectedProgram);
    } catch (e) {
      print('Error loading programs: $e');
    }
  }

  Future<void> selectProgram(String program) async {
    state = state.copyWith(
      selectedProgram: program,
      branches: [],
      selectedBranch: null,
    );

    final year = state.selectedAcademicYear;
    if (year != null) {
      try {
        final branches = await _admissionService.fetchBranches(year, program);
        // Ensure selectedBranch is null if not in new branches list
        String? selectedBranch = state.selectedBranch;
        if (selectedBranch == null || !branches.contains(selectedBranch)) {
          selectedBranch = null;
        }
        state = state.copyWith(branches: branches, selectedBranch: selectedBranch);
      } catch (e) {
        print('Error loading branches: $e');
      }
    }
  }

  void selectBranch(String branch) {
    state = state.copyWith(selectedBranch: branch);
  }
}

final admissionProvider =
    StateNotifierProvider<AdmissionNotifier, AdmissionState>((ref) {
  final service = ref.watch(admissionServiceProvider);
  return AdmissionNotifier(service);
});

final academicIdMap = {
  '2025-26': 0,
  '2024-25': 1,
  '2023-24': 2,
  '2022-23': 3,
  '2021-22': 4,
};

final searchQueryProvider = StateProvider<String>((ref) => '');

final studentApplicationsProvider =
    FutureProvider.autoDispose<List<StudentApplication>>((ref) async {
  final admissionState = ref.watch(admissionProvider);
  final selectedYear = admissionState.selectedAcademicYear;
  final selectedProgram = admissionState.selectedProgram;
  final selectedBranch = admissionState.selectedBranch;
  final searchQuery = ref.watch(searchQueryProvider);

  if (selectedYear == null) return [];

  final academicId = academicIdMap[selectedYear] ?? 1;
  final service = ref.watch(admissionServiceProvider);

  List<StudentApplication> applications =
      await service.fetchApplications(academicId.toString());

  if (selectedProgram != null && selectedProgram.isNotEmpty) {
    applications = applications
        .where((app) => app.programName == selectedProgram)
        .toList();
  }

  if (selectedBranch != null && selectedBranch.isNotEmpty) {
    applications =
        applications.where((app) => app.branch == selectedBranch).toList();
  }

  return applications;
});

final admissionDashboardProvider =
    FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final applications = await ref.watch(studentApplicationsProvider.future);

  return {
    'academicYears': _buildAcademicYearStats(applications),
    'branchStats': _buildBranchStats(applications),
    'categoryStats': _buildCategoryStats(applications),
    'genderCount': _buildGenderStats(applications),
    'cutOffTrend': _buildCutOffTrend(applications),
  };
});

List<Map<String, dynamic>> _buildAcademicYearStats(
  List<StudentApplication> list,
) {
  final map = <String, int>{};
  for (var app in list) {
    final year = app.academic_year ?? 'Unknown';
    map[year] = (map[year] ?? 0) + 1;
  }
  return map.entries
      .map((e) => {'academic_name': e.key, 'application_count': e.value})
      .toList();
}

List<Map<String, dynamic>> _buildBranchStats(List<StudentApplication> list) {
  final map = <String, int>{};
  for (var app in list) {
    final branch = app.branch ?? 'Unknown';
    map[branch] = (map[branch] ?? 0) + 1;
  }
  return map.entries
      .map((e) => {'branch_name': e.key, 'application_count': e.value})
      .toList();
}

List<Map<String, dynamic>> _buildCategoryStats(List<StudentApplication> list) {
  final map = <String, int>{};
  for (var app in list) {
    final cat = app.category ?? 'Unknown';
    map[cat] = (map[cat] ?? 0) + 1;
  }
  return map.entries
      .map((e) => {'category_name': e.key, 'application_count': e.value})
      .toList();
}

List<Map<String, dynamic>> _buildGenderStats(List<StudentApplication> list) {
  final grouped = <String, Map<String, dynamic>>{};
  for (var app in list) {
    final program = app.programName ?? 'Unknown';
    final isMale = app.gender?.toLowerCase() == 'male';

    grouped.putIfAbsent(
      program,
      () => {'programm_name': program, 'male_count': 0, 'female_count': 0},
    );

    if (isMale) {
      grouped[program]!['male_count'] += 1;
    } else {
      grouped[program]!['female_count'] += 1;
    }
  }
  return grouped.values.toList();
}

List<Map<String, dynamic>> _buildCutOffTrend(List<StudentApplication> list) {
  final map = <String, Map<String, double>>{};

  for (var app in list) {
    final year = app.academic_year ?? 'Unknown';
    final open = app.cutoffOpen ?? 0.0;
    final sebc = app.cutoffSebc ?? 0.0;

    map[year] = {
      'open': (map[year]?['open'] ?? 0.0) + open,
      'sebc': (map[year]?['sebc'] ?? 0.0) + sebc,
    };
  }

  return map.entries.map((e) {
    return {'year': e.key, 'open': e.value['open'], 'sebc': e.value['sebc']};
  }).toList();
}