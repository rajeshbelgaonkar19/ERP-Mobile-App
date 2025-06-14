import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../services/api/admission/admission_provider.dart';

// Providers for dropdown selections
final selectedProgramProvider = StateProvider<String?>((ref) => null);
final selectedBranchProvider = StateProvider<String?>((ref) => null);
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final _selectedCategoryProvider = StateProvider<String>((ref) => 'OPEN');

class AdmissionDashboard extends ConsumerWidget {
  const AdmissionDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(admissionDashboardProvider);
    final branchesAsync = ref.watch(admissionBranchesProvider);

    final selectedProgram = ref.watch(selectedProgramProvider);
    final selectedBranch = ref.watch(selectedBranchProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (data) {
          final genderStats = data['genderCount'] ?? [];
          final branchStats = data['branchStats'] ?? [];
          final categoryStats = (data['categoryStats'] ?? []) as List;
          final cutOffTrend = data['cutOffTrend'] ?? [];

          // Program Dropdown (Year-wise)
          final programDropdownValue = selectedProgram ?? (genderStats.isNotEmpty ? genderStats.first['programm_name'] : null);

          // Category Dropdown
          final categoryDropdownValue = selectedCategory ?? (categoryStats.isNotEmpty ? categoryStats.first['category_name'] : null);

          // Filtered genderStats for selected program
          final selectedProgramData = genderStats.firstWhere(
            (e) => e['programm_name'] == programDropdownValue,
            orElse: () => genderStats.isNotEmpty ? genderStats.first : {},
          );

          final male = int.tryParse(selectedProgramData['male_count']?.toString() ?? '0') ?? 0;
          final female = int.tryParse(selectedProgramData['female_count']?.toString() ?? '0') ?? 0;
          final total = male + female;

          final screenWidth = MediaQuery.of(context).size.width;
          final cardWidth = screenWidth * 0.95;
          final chartSize = screenWidth * 0.7;

          return branchesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text("Error: $err")),
            data: (branches) {
              // Branch Dropdown
              final branchDropdownValue = selectedBranch ?? (branches.isNotEmpty ? branches.first['bname'] : null);

              // Find branchStats for selected branch
              final filteredBranchStats = branchStats.where((e) =>
                branchDropdownValue == null || e['branch_name'] == branchDropdownValue
              ).toList();

              // Branch Student Count
              int branchStudentCount = 0;
              if (filteredBranchStats.isNotEmpty) {
                branchStudentCount = int.tryParse(filteredBranchStats.first['application_count']?.toString() ?? '0') ?? 0;
              }

              // Filter only if categoryStats is not empty
              final filteredCategoryStats = categoryStats.isNotEmpty
                  ? categoryStats.where((e) =>
                      categoryDropdownValue == null || e['category_name'] == categoryDropdownValue
                    ).toList()
                  : [];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //1. Program/Year Dropdown (for 1st chart)
                    DropdownButton<String>(
                      value: programDropdownValue,
                      hint: const Text('Select Program/Year'),
                      isExpanded: true,
                      items: genderStats.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                          value: e['programm_name'],
                          child: Text(e['programm_name'].toString()),
                        );
                      }).toList(),
                      onChanged: (value) => ref.read(selectedProgramProvider.notifier).state = value,
                    ),
                    const SizedBox(height: 16),

                    //1. Responsive Card for 1st chart properly done
                    Center(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 2,
                        child: Container(
                          width: cardWidth,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Year wise Application Status", style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: chartSize,
                                width: chartSize,
                                child: DualSemiCircleGauge(
                                  male: male,
                                  female: female,
                                  total: total,
                                ),
                              ),
                              // Move text closer to chart
                              const SizedBox(height: 4),
                              Text('$total', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                              const Text('Total Applications'),
                              const SizedBox(height: 4),
                              Text('Male: $male'),
                              Text('Female: $female'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    //2. Branch Dropdown (for 2nd chart)
                    DropdownButton<String>(
                      value: branchDropdownValue,
                      hint: const Text('Select Branch'),
                      isExpanded: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ), // Smaller font for selected value
                      items: branches.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                          value: e['bname'],
                          child: Text(
                            e['bname'].toString(),
                            style: const TextStyle(fontSize: 14), // Smaller font for dropdown items
                            overflow: TextOverflow.ellipsis,      // Ensures long text is truncated
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => ref.read(selectedBranchProvider.notifier).state = value,
                    ),
                    const SizedBox(height: 8),

                    // 2. Branch-wise Admission Status (Gauge + Text inside Card)
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Container(
                        width: cardWidth,
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                        color: const Color.fromARGB(255, 247, 246, 250),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Branch wise Admission Status", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: chartSize * 0.8,
                              width: chartSize * 0.8,
                              child: BranchSemiCircleGauge(
                                count: branchStudentCount,
                                max: 500, // or set to your max branch count
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Students in $branchDropdownValue: $branchStudentCount',
                              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    //3. Responsive Card for 3rd chart properly done
                    Consumer(
                      builder: (context, ref, _) {
                        final categoriesAsync = ref.watch(admissionCategoriesProvider);

                        return categoriesAsync.when(
                          data: (categories) {
                            // Filter for only OPEN and OBC (or SEBC if that's the correct name)
                            final filtered = categories.where((cat) =>
                                cat['cat_name'] == 'OPEN' || cat['cat_name'] == 'OBC' || cat['cat_name'] == 'SEBC').toList();

                            // Use only OPEN and OBC/SEBC for dropdown and chart
                            final categoryNames = filtered.map<String>((cat) => cat['cat_name'] as String).toList();

                            // If OBC is not present but SEBC is, use SEBC as the second category
                            final dropdownNames = categoryNames.contains('OBC')
                                ? ['OPEN', 'OBC']
                                : ['OPEN', 'SEBC'];

                            // State for selected category (not really needed if not changing, but for UI consistency)
                            final selectedCategory = ref.watch(_selectedCategoryProvider);

                            // Set default if not in dropdownNames
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!dropdownNames.contains(selectedCategory)) {
                                ref.read(_selectedCategoryProvider.notifier).state = dropdownNames.first;
                              }
                            });

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Title inside the box
                                      const Text(
                                        "Category wise distribution",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Dropdown for categories
                                      DropdownButton<String>(
                                        value: selectedCategory,
                                        items: dropdownNames
                                            .map((name) => DropdownMenuItem(
                                                  value: name,
                                                  child: Text(
                                                    name,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            ref.read(_selectedCategoryProvider.notifier).state = value;
                                          }
                                        },
                                        underline: Container(),
                                        dropdownColor: Colors.white,
                                      ),
                                      const SizedBox(height: 12),
                                      // Donut chart with 2 categories
                                      SizedBox(
                                        height: 160,
                                        child: _SimpleDonutChart(
                                          categories: dropdownNames,
                                          selectedCategory: selectedCategory,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Legend
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: dropdownNames.map((name) {
                                          final color = _getCategoryColor(name);
                                          return Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                name,
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              const SizedBox(width: 16),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text('Error: $e'),
                          ),
                        );
                      },
                    ),

                    // // Category Dropdown (for 3rd chart)
                    // DropdownButton<String>(
                    //   value: categoryDropdownValue,
                    //   hint: const Text('Select Category'),
                    //   isExpanded: true,
                    //   items: categoryStats.map<DropdownMenuItem<String>>((e) {
                    //     return DropdownMenuItem<String>(
                    //       value: e['category_name'],
                    //       child: Text(e['category_name'].toString()),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) => ref.read(selectedCategoryProvider.notifier).state = value,
                    // ),
                    // const SizedBox(height: 8),

                    // // Only show chart if filteredCategoryStats is not empty
                    // if (filteredCategoryStats.isNotEmpty)
                    //   Card(
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    //     elevation: 2,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(16),
                    //       child: Column(
                    //         children: [
                    //           const Text("Category wise distribution", style: TextStyle(fontWeight: FontWeight.bold)),
                    //           SizedBox(
                    //             height: 200,
                    //             child: PieChart(
                    //               PieChartData(
                    //                 sections: filteredCategoryStats.map<PieChartSectionData>((e) {
                    //                   final value = e['application_count'];
                    //                   return PieChartSectionData(
                    //                     value: double.tryParse(value.toString()) ?? 0,
                    //                     title: e['category_name'],
                    //                     color: Colors.accents[filteredCategoryStats.indexOf(e) % Colors.accents.length],
                    //                     radius: 60,
                    //                     titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
                    //                   );
                    //                 }).toList(),
                    //                 sectionsSpace: 2,
                    //                 centerSpaceRadius: 30,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // const SizedBox(height: 24),

                    // 4. Gender-wise Distribution (Bar)
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text("Gender wise distribution", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 220,
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
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text(
                                                genderStats[idx]['programm_name'] ?? '',
                                                style: const TextStyle(fontSize: 10),
                                              ),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: true),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(show: true),
                                  borderData: FlBorderData(show: false),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    

                    // // 5. Cut-Off Trend (Stacked Bar)
                    // Card(
                    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    //   elevation: 2,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(16),
                    //     child: Column(
                    //       children: [
                    //         const Text("Cut-Off Trend", style: TextStyle(fontWeight: FontWeight.bold)),
                    //         SizedBox(
                    //           height: 220,
                    //           child: BarChart(
                    //             BarChartData(
                    //               barGroups: cutOffTrend.map<BarChartGroupData>((e) {
                    //                 return BarChartGroupData(
                    //                   x: cutOffTrend.indexOf(e),
                    //                   barRods: [
                    //                     BarChartRodData(
                    //                       toY: double.tryParse((e['open'] ?? '0').toString()) ?? 0,
                    //                       color: Colors.purple,
                    //                       width: 12,
                    //                     ),
                    //                     BarChartRodData(
                    //                       toY: double.tryParse((e['sebc'] ?? '0').toString()) ?? 0,
                    //                       color: Colors.teal,
                    //                       width: 12,
                    //                     ),
                    //                   ],
                    //                 );
                    //               }).toList(),
                    //               titlesData: FlTitlesData(
                    //                 bottomTitles: AxisTitles(
                    //                   sideTitles: SideTitles(
                    //                     showTitles: true,
                    //                     getTitlesWidget: (value, meta) {
                    //                       final idx = value.toInt();
                    //                       if (idx < cutOffTrend.length) {
                    //                         return Padding(
                    //                           padding: const EdgeInsets.only(top: 8.0),
                    //                           child: Text(
                    //                             cutOffTrend[idx]['year'] ?? '',
                    //                             style: const TextStyle(fontSize: 10),
                    //                           ),
                    //                         );
                    //                       }
                    //                       return const Text('');
                    //                     },
                    //                   ),
                    //                 ),
                    //                 leftTitles: AxisTitles(
                    //                   sideTitles: SideTitles(showTitles: true),
                    //                 ),
                    //                 rightTitles: AxisTitles(
                    //                   sideTitles: SideTitles(showTitles: false),
                    //                 ),
                    //                 topTitles: AxisTitles(
                    //                   sideTitles: SideTitles(showTitles: false),
                    //                 ),
                    //               ),
                    //               gridData: FlGridData(show: true),
                    //               borderData: FlBorderData(show: false),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(height: 24),

                    // // Chart 3: Category-wise Distribution
                    // Consumer(
                    //   builder: (context, ref, _) {
                    //     final categoriesAsync = ref.watch(admissionCategoriesProvider);

                    //     return categoriesAsync.when(
                    //       data: (categories) {
                    //         // Filter for only OPEN and OBC (or SEBC if that's the correct name)
                    //         final filtered = categories.where((cat) =>
                    //             cat['cat_name'] == 'OPEN' || cat['cat_name'] == 'OBC' || cat['cat_name'] == 'SEBC').toList();

                    //         // Use only OPEN and OBC/SEBC for dropdown and chart
                    //         final categoryNames = filtered.map<String>((cat) => cat['cat_name'] as String).toList();

                    //         // If OBC is not present but SEBC is, use SEBC as the second category
                    //         final dropdownNames = categoryNames.contains('OBC')
                    //             ? ['OPEN', 'OBC']
                    //             : ['OPEN', 'SEBC'];

                    //         // State for selected category (not really needed if not changing, but for UI consistency)
                    //         final selectedCategory = ref.watch(_selectedCategoryProvider);

                    //         // Set default if not in dropdownNames
                    //         WidgetsBinding.instance.addPostFrameCallback((_) {
                    //           if (!dropdownNames.contains(selectedCategory)) {
                    //             ref.read(_selectedCategoryProvider.notifier).state = dropdownNames.first;
                    //           }
                    //         });

                    //         return Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    //           child: Card(
                    //             elevation: 2,
                    //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    //             child: Padding(
                    //               padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    //               child: Column(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: [
                    //                   // Title inside the box
                    //                   const Text(
                    //                     "Category wise distribution",
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 16,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(height: 12),
                    //                   // Dropdown for categories
                    //                   DropdownButton<String>(
                    //                     value: selectedCategory,
                    //                     items: dropdownNames
                    //                         .map((name) => DropdownMenuItem(
                    //                               value: name,
                    //                               child: Text(
                    //                                 name,
                    //                                 style: const TextStyle(fontWeight: FontWeight.bold),
                    //                               ),
                    //                             ))
                    //                         .toList(),
                    //                     onChanged: (value) {
                    //                       if (value != null) {
                    //                         ref.read(_selectedCategoryProvider.notifier).state = value;
                    //                       }
                    //                     },
                    //                     underline: Container(),
                    //                     dropdownColor: Colors.white,
                    //                   ),
                    //                   const SizedBox(height: 12),
                    //                   // Donut chart with 2 categories
                    //                   SizedBox(
                    //                     height: 160,
                    //                     child: _SimpleDonutChart(
                    //                       categories: dropdownNames,
                    //                       selectedCategory: selectedCategory,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(height: 12),
                    //                   // Legend
                    //                   Row(
                    //                     mainAxisAlignment: MainAxisAlignment.center,
                    //                     children: dropdownNames.map((name) {
                    //                       final color = _getCategoryColor(name);
                    //                       return Row(
                    //                         children: [
                    //                           Container(
                    //                             width: 12,
                    //                             height: 12,
                    //                             decoration: BoxDecoration(
                    //                               color: color,
                    //                               shape: BoxShape.circle,
                    //                             ),
                    //                           ),
                    //                           const SizedBox(width: 4),
                    //                           Text(
                    //                             name,
                    //                             style: const TextStyle(fontWeight: FontWeight.w500),
                    //                           ),
                    //                           const SizedBox(width: 16),
                    //                         ],
                    //                       );
                    //                     }).toList(),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //       loading: () => const Padding(
                    //         padding: EdgeInsets.all(32.0),
                    //         child: Center(child: CircularProgressIndicator()),
                    //       ),
                    //       error: (e, _) => Padding(
                    //         padding: const EdgeInsets.all(32.0),
                    //         child: Text('Error: $e'),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Dual color semi-circle gauge widget
class DualSemiCircleGauge extends StatelessWidget {
  final int male;
  final int female;
  final int total;
  const DualSemiCircleGauge({
    required this.male,
    required this.female,
    required this.total,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DualSemiCircleGaugePainter(
        male: male,
        female: female,
        total: total,
      ),
    );
  }
}

class _DualSemiCircleGaugePainter extends CustomPainter {
  final int male;
  final int female;
  final int total;
  _DualSemiCircleGaugePainter({
    required this.male,
    required this.female,
    required this.total,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = size.width * 0.10;
    final startAngle = math.pi;
    final sweepAngle = math.pi;

    // Draw background arc
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect.deflate(strokeWidth / 2), startAngle, sweepAngle, false, bgPaint);

    if (total > 0) {
      // Draw male arc
      final malePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      final maleSweep = sweepAngle * (male / total);
      canvas.drawArc(rect.deflate(strokeWidth / 2), startAngle, maleSweep, false, malePaint);

      // Draw female arc
      final femalePaint = Paint()
        ..color = Colors.pink
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      final femaleSweep = sweepAngle * (female / total);
      canvas.drawArc(rect.deflate(strokeWidth / 2), startAngle + maleSweep, femaleSweep, false, femalePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Branch semi-circle gauge widget
class BranchSemiCircleGauge extends StatelessWidget {
  final int count;
  final int max;
  const BranchSemiCircleGauge({
    required this.count,
    required this.max,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BranchSemiCircleGaugePainter(
        count: count,
        max: max,
      ),
    );
  }
}

class _BranchSemiCircleGaugePainter extends CustomPainter {
  final int count;
  final int max;
  _BranchSemiCircleGaugePainter({
    required this.count,
    required this.max,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = size.width * 0.10;
    final startAngle = math.pi;
    final sweepAngle = math.pi;

    // Draw background arc
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect.deflate(strokeWidth / 2), startAngle, sweepAngle, false, bgPaint);

    if (max > 0) {
      // Draw filled arc based on count
      final fillPaint = Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      final sweep = sweepAngle * (count / max);
      canvas.drawArc(rect.deflate(strokeWidth / 2), startAngle, sweep, false, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Helper for category color
Color _getCategoryColor(String name) {
  switch (name) {
    case 'OPEN':
      return Colors.deepPurple;
    case 'OBC':
    case 'SEBC':
      return Colors.purple;
    default:
      return Colors.grey;
  }
}

// Dummy DonutChartWidget for illustration (replace with your actual chart widget)
class _SimpleDonutChart extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;

  const _SimpleDonutChart({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    // For demo: show 50/50 split
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: CircularProgressIndicator(
            value: 0.5,
            strokeWidth: 22,
            valueColor: AlwaysStoppedAnimation(_getCategoryColor(categories[0])),
            backgroundColor: _getCategoryColor(categories[1]),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${categories.length}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Text(
              'Categories',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}

class CategoryWiseDistributionChart extends StatelessWidget {
  const CategoryWiseDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final categoriesAsync = ref.watch(admissionCategoriesProvider);

        return categoriesAsync.when(
          data: (categories) {
            // Filter for only OPEN and OBC (or SEBC if that's the correct name)
            final filtered = categories.where((cat) =>
                cat['cat_name'] == 'OPEN' || cat['cat_name'] == 'OBC' || cat['cat_name'] == 'SEBC').toList();

            // Use only OPEN and OBC/SEBC for dropdown and chart
            final categoryNames = filtered.map<String>((cat) => cat['cat_name'] as String).toList();

            // If OBC is not present but SEBC is, use SEBC as the second category
            final dropdownNames = categoryNames.contains('OBC')
                ? ['OPEN', 'OBC']
                : ['OPEN', 'SEBC'];

            // State for selected category (not really needed if not changing, but for UI consistency)
            final selectedCategory = ref.watch(_selectedCategoryProvider);

            // Set default if not in dropdownNames
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!dropdownNames.contains(selectedCategory)) {
                ref.read(_selectedCategoryProvider.notifier).state = dropdownNames.first;
              }
            });

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title inside the box
                      const Text(
                        "Category wise distribution",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Dropdown for categories
                      DropdownButton<String>(
                        value: selectedCategory,
                        items: dropdownNames
                            .map((name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(
                                    name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(_selectedCategoryProvider.notifier).state = value;
                          }
                        },
                        underline: Container(),
                        dropdownColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      // Donut chart with 2 categories
                      SizedBox(
                        height: 160,
                        child: _SimpleDonutChart(
                          categories: dropdownNames,
                          selectedCategory: selectedCategory,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Legend
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dropdownNames.map((name) {
                          final color = _getCategoryColor(name);
                          return Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 16),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text('Error: $e'),
          ),
        );
      },
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ...your first four charts/widgets...
              // Chart 1
              // Chart 2
              // Chart 3
              // Chart 4

              // 5th Chart: Cut-Off Trend
              const CutoffTrendChart(),

              // ...any widgets after the 5th chart...
            ],
          ),
        ),
      ),
    );
  }
}

class CutoffTrendChart extends ConsumerStatefulWidget {
  const CutoffTrendChart({Key? key}) : super(key: key);

  @override
  ConsumerState<CutoffTrendChart> createState() => _CutoffTrendChartState();
}

class _CutoffTrendChartState extends ConsumerState<CutoffTrendChart> {
  @override
  Widget build(BuildContext context) {
    // Your chart building logic here
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Cut-Off Trend", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  barGroups: [], // Populate with your data
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Your x-axis label logic
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


