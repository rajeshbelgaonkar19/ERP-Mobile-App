import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/api/admission/admission_provider.dart';

class StudentAdmissionPage extends ConsumerStatefulWidget {
  const StudentAdmissionPage({super.key});

  @override
  ConsumerState<StudentAdmissionPage> createState() => _StudentAdmissionPageState();
}

class _StudentAdmissionPageState extends ConsumerState<StudentAdmissionPage> {
  Map<String, dynamic>? selectedYear; // Store the selected year object
  String? admissionOpenFor;

  @override
  Widget build(BuildContext context) {
    final academicYearsAsync = ref.watch(academicYearsProvider);

    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: academicYearsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
              data: (years) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Start New Admission Process",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Academic Year",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: selectedYear,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      hint: const Text("Choose an academic year"),
                      items: years
                          .map<DropdownMenuItem<Map<String, dynamic>>>(
                            (year) => DropdownMenuItem(
                              value: year,
                              child: Text(year['academic_name']),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value;
                        });
                      },
                    ),
                    const SizedBox(height: 28),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text(
                        "Start Admission for Selected Year",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      onPressed: selectedYear == null
                          ? null
                          : () async {
                              final id = selectedYear!['academic_id'];
                              await ref.read(admissionServiceProvider).startAdmission(id);
                              setState(() {
                                admissionOpenFor = selectedYear!['academic_name'];
                              });
                            },
                    ),
                    const SizedBox(height: 16),
                    if (admissionOpenFor != null)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: Text(
                          "Stop Admission for $admissionOpenFor",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () async {
                          final id = selectedYear!['academic_id'];
                          await ref.read(admissionServiceProvider).stopAdmission(id);
                          setState(() {
                            admissionOpenFor = null;
                          });
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
