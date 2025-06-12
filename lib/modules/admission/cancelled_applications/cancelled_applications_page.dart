import 'package:flutter/material.dart';

class CancelledApplicationsPage extends StatefulWidget {
  const CancelledApplicationsPage({super.key});

  @override
  State<CancelledApplicationsPage> createState() => _CancelledApplicationsPageState();
}

class _CancelledApplicationsPageState extends State<CancelledApplicationsPage> {
  String selectedYear = '2025-26';
  String selectedProgram = '';
  final TextEditingController searchController = TextEditingController();

  final List<String> academicYears = [
    '2024-25',
    '2025-26',
    '2026-27',
    '2027-28',
    '2028-29',
    '2029-30',
    '2030-31',
  ];

  final List<String> programs = [
    'B.Tech',
    'M.Tech',
    'MBA',
    'MCA',
    // Add more as needed
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700; // Define a breakpoint for mobile

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Student's Cancelled Applications",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            // Conditionally render layout for filters based on screen size
            isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildFilterWidgets(isMobile),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildFilterWidgets(isMobile),
                  ),
            const SizedBox(height: 32),
            // Table Header
            // Hide some columns for mobile view or make them scrollable if necessary
            if (!isMobile)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                child: Row(
                  children: const [
                    _TableHeaderCell('Gr No.', flex: 2),
                    _TableHeaderCell('College ID', flex: 2),
                    _TableHeaderCell('Full Name', flex: 3),
                    _TableHeaderCell('Branch', flex: 2),
                    _TableHeaderCell('Selected Program', flex: 3),
                    _TableHeaderCell('Date of Cancellation', flex: 3),
                    _TableHeaderCell('Cancellation Document', flex: 3),
                    _TableHeaderCell('Action', flex: 2),
                    _TableHeaderCell('Cancel Details', flex: 2),
                  ],
                ),
              ),
            // Table Empty State (Consider showing a more compact view for mobile if data exists)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: const Text(
                'No cancelled applications found.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16), // Added some spacing before pagination
            // Pagination
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C7CFF).withOpacity(0.3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Prev'),
                ),
                const SizedBox(width: 16),
                const Text('0 results', style: TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C7CFF).withOpacity(0.3),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build filter widgets for responsiveness
  List<Widget> _buildFilterWidgets(bool isMobile) {
    return [
      // Academic Year Dropdown
      Expanded(
        flex: isMobile ? 0 : 2, // No flex on mobile to allow natural sizing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Academic Year', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedYear,
              items: academicYears
                  .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                  .toList(),
              onChanged: (val) => setState(() => selectedYear = val!),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: isMobile ? 20 : 32), // Adjust spacing
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C7CFF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Download Cancel Report',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      if (!isMobile) const SizedBox(width: 32), // Spacing only for larger screens
      // Program Dropdown & Search
      Expanded(
        flex: isMobile ? 0 : 3, // No flex on mobile
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: isMobile ? 20 : 0), // Add spacing for mobile above program dropdown
            const Text('Selected Program', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedProgram.isEmpty ? null : selectedProgram,
              hint: const Text('Select The Program'),
              items: programs
                  .map((prog) => DropdownMenuItem(value: prog, child: Text(prog)))
                  .toList(),
              onChanged: (val) => setState(() => selectedProgram = val ?? ''),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Search Student', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Student Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

class _TableHeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  const _TableHeaderCell(this.label, {this.flex = 1});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Color(0xFF3B3B3B),
        ),
      ),
    );
  }
}