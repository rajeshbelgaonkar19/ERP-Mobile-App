import 'package:flutter/material.dart';

class StudentAdmissionPage extends StatefulWidget {
  const StudentAdmissionPage({super.key});

  @override
  State<StudentAdmissionPage> createState() => _StudentAdmissionPageState();
}

class _StudentAdmissionPageState extends State<StudentAdmissionPage> {
  String? selectedYear;
  final List<String> academicYears = [
    '2024-25',
    '2025-26',
    '2026-27',
    '2027-28',
    '2028-29',
    '2029-30',
    '2030-31',
  ];

  // Simulate admission status for demo
  String? admissionOpenFor; // e.g. '2025-26'

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
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
                DropdownButtonFormField<String>(
                  value: selectedYear,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  hint: const Text("Choose an academic year"),
                  items: academicYears
                      .map((year) => DropdownMenuItem<String>(
                            value: year,
                            child: Text(year),
                          ))
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
                      : () {
                          setState(() {
                            admissionOpenFor = selectedYear;
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
                    onPressed: () {
                      setState(() {
                        admissionOpenFor = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
