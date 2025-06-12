import 'package:erp_mobile_app/core/constants/colors.dart';
import 'package:erp_mobile_app/modules/admission/applications/model/student_application.dart';
import 'package:erp_mobile_app/modules/admission/applications/provider/admission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ApplicationsPage extends StatelessWidget {
//   const ApplicationsPage({super.key});
class StudentAdmissionDetailsPage extends ConsumerWidget {
  final List<String> academicYears = ['2025-26', '2024-25', '2023-24', '2022-23', '2021-22'];

  @override
  // Widget build(BuildContext context) {
  //   return const Center(
  //     child: Text('Applications Page'),
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAcademicYear = ref.watch(selectedAcademicYearProvider);
    final applicationsAsync = ref.watch(studentApplicationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterSection(ref, selectedAcademicYear),
            Expanded(
              child: applicationsAsync.when(
                data: (apps) => apps.isEmpty ? _buildEmptyState() : _buildResultsList(apps),
                loading: () => Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(WidgetRef ref, String? selectedYear) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Academic Year", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          _buildCustomDropdown(
            value: selectedYear,
            hint: 'Select Academic Year',
            items: academicYears,
            onChanged: (value) {
              ref.read(selectedAcademicYearProvider.notifier).state = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
        color: AppColors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(hint, style: TextStyle(color: AppColors.textSecondary)),
          ),
          isExpanded: true,
          icon: Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          ),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(item, style: TextStyle(color: AppColors.textPrimary)),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildResultsList(List<StudentApplication> apps) {
    return ListView.builder(
      itemCount: apps.length,
      itemBuilder: (context, index) {
        final app = apps[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(flex: 1, child: Text(app.grNumber ?? '-')),
              Expanded(flex: 2, child: Text(app.collegeId ?? '-')),
              Expanded(flex: 3, child: Text(app.fullName ?? '-')),
              Expanded(flex: 2, child: Text(app.branch ?? '-')),
              Expanded(flex: 2, child: Text(app.program ?? '-')),
              Expanded(flex: 2, child: Icon(Icons.arrow_forward_ios, size: 16)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 60, color: AppColors.primary.withOpacity(0.3)),
          SizedBox(height: 16),
          Text('No Students Found', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Select an academic year to view student records', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
