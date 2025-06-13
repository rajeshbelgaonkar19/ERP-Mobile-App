import 'dart:developer';

import 'package:erp_mobile_app/modules/admission/applications/provider/admission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// class ApplicationsPage extends StatelessWidget {
//   const ApplicationsPage({super.key});
class StudentAdmissionDetailsPage extends ConsumerWidget {
  const StudentAdmissionDetailsPage({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return const Center(
  //     child: Text('Applications Page'),
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(admissionProvider);
    final notifier = ref.read(admissionProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8), // Reduced from 24
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12), // Reduced horizontal padding
          constraints: const BoxConstraints(maxWidth: 350), // Reduced width
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🎓 Student Admission Details",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),

              const SizedBox(height: 24),

              // Academic Year Dropdown
              _DropdownSection(
                label: "Select Academic Year",
                value: provider.selectedAcademicYear,
                hint: "Select Academic Year",
                items: provider.academicYears,
                onChanged: (value) {
                  notifier.selectAcademicYear(value.toString());
                },
              ),

              const SizedBox(height: 20),

              // Program Dropdown (only visible after academic year is selected)
              if (provider.selectedAcademicYear != null) ...[
                _DropdownSection(
                  label: "Select Program",
                  value: provider.selectedProgram,
                  hint: "Select The Program",
                  items: provider.programs,
                  onChanged: (value) {
                    notifier.selectProgram(value!);
                    
                  },
                ),
              ],

              const SizedBox(height: 20),

              // Branch Dropdown (only visible after program is selected)
              if (provider.selectedProgram != null) ...[
                _DropdownSection(
                  label: "Select Branch",
                  value: provider.selectedBranch,
                  hint: "Select The Branch",
                  items: provider.branches,
                  onChanged: (value) {
                    notifier.selectBranch(value!);
                  },
                ),
              ],

              const SizedBox(height: 30),

              // Generate Button
              if (provider.selectedBranch != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () {
                    },
                    child: const Text("Generate Report"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownSection extends StatelessWidget {
  final String label;
  final String? value;
  final String hint;
  final List<String> items;
  final void Function(String?) onChanged;

  const _DropdownSection({
    required this.label,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Colors.grey.shade800)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 16), // Smaller font
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12), // Reduced horizontal padding
          ),
          style: const TextStyle(fontSize: 16), // Smaller font
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 16))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}