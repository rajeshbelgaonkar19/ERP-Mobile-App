import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../services/api/admission/admission_provider.dart';

// Add these providers at the top of your file or in a providers.dart
final selectedYearProvider = StateProvider<String?>((ref) => null);
final selectedBranchProvider = StateProvider<String?>((ref) => null);
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

class AdmissionDashboard extends ConsumerWidget {
  const AdmissionDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(admissionDashboardProvider);

    // In your build method, before the charts:
    final selectedYear = ref.watch(selectedYearProvider);
    final selectedBranch = ref.watch(selectedBranchProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (data) {
          final genderStats = data['genderCount'] ?? [];
          final academicYears = data['academicYears'] ?? [];
          final branchStats = data['branchStats'] ?? [];
          final categoryStats = data['categoryStats'] ?? [];
          final cutOffTrend = data['cutOffTrend'] ?? [];

          final filteredAcademicYear = selectedYear == null
              ? academicYears
              : academicYears.where((e) => e['academic_name'] == selectedYear).toList();
          final filteredBranchStats = branchStats.where((e) => e['branch_name'] == selectedBranch).toList();
          final filteredCategoryStats = categoryStats.where((e) => e['category_name'] == selectedCategory).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Year Dropdown
                DropdownButton<String>(
                  value: selectedYear ?? (academicYears.isNotEmpty ? academicYears.first['academic_name'] : null),
                  hint: const Text('Select Year'),
                  items: academicYears.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                      value: e['academic_name'] as String,
                      child: Text(e['academic_name'].toString()),
                    );
                  }).toList(),
                  onChanged: (value) => ref.read(selectedYearProvider.notifier).state = value,
                ),
                const SizedBox(height: 24),

                // 1. Year-wise Application Status (Gauge or Pie)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("Year wise Application Status", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 180,
                          child: PieChart(
                            PieChartData(
                              sections: filteredAcademicYear.map<PieChartSectionData>((e) {
                                final value = e['application_count'];
                                return PieChartSectionData(
                                  value: double.tryParse(value.toString()) ?? 0,
                                  title: e['academic_name'],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Branch-wise Admission Status (Pie)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("Branch wise Admission Status", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 180,
                          child: PieChart(
                            PieChartData(
                              sections: branchStats.map<PieChartSectionData>((e) {
                                final value = e['application_count'];
                                return PieChartSectionData(
                                  value: double.tryParse(value.toString()) ?? 0,
                                  title: e['branch_name'],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Category-wise Distribution (Pie)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("Category wise distribution", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 180,
                          child: PieChart(
                            PieChartData(
                              sections: categoryStats.map<PieChartSectionData>((e) {
                                final value = e['application_count'];
                                return PieChartSectionData(
                                  value: double.tryParse(value.toString()) ?? 0,
                                  title: e['category_name'],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Gender-wise Distribution (Bar)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("Gender wise distribution", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              barGroups: genderStats.map<BarChartGroupData>((e) {
                                return BarChartGroupData(
                                  x: genderStats.indexOf(e),
                                  barRods: [
                                    BarChartRodData(
                                      toY: double.tryParse((e['male_count'] ?? '0').toString()) ?? 0,
                                      color: Colors.blue,
                                      width: 12,
                                    ),
                                    BarChartRodData(
                                      toY: double.tryParse((e['female_count'] ?? '0').toString()) ?? 0,
                                      color: Colors.pink,
                                      width: 12,
                                    ),
                                  ],
                                  showingTooltipIndicators: [0, 1],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final idx = value.toInt();
                                      if (idx < genderStats.length) {
                                        return Text(genderStats[idx]['programm_name'] ?? '');
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Cut-Off Trend (Stacked Bar)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text("Cut-Off Trend", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              barGroups: cutOffTrend.map<BarChartGroupData>((e) {
                                return BarChartGroupData(
                                  x: cutOffTrend.indexOf(e),
                                  barRods: [
                                    BarChartRodData(
                                      toY: double.tryParse((e['open'] ?? '0').toString()) ?? 0,
                                      color: Colors.purple,
                                      width: 12,
                                    ),
                                    BarChartRodData(
                                      toY: double.tryParse((e['sebc'] ?? '0').toString()) ?? 0,
                                      color: Colors.teal,
                                      width: 12,
                                    ),
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final idx = value.toInt();
                                      if (idx < cutOffTrend.length) {
                                        return Text(cutOffTrend[idx]['year'] ?? '');
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
