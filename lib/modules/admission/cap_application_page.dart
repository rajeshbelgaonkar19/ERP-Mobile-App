import 'package:flutter/material.dart';

class CAPApplicationPage extends StatefulWidget {
  const CAPApplicationPage({super.key});

  @override
  State<CAPApplicationPage> createState() => _CAPApplicationPageState();
}

class _CAPApplicationPageState extends State<CAPApplicationPage> {
  final _idController = TextEditingController();
  bool showForm = false;

  // Simulated application data (replace with API call in real app)
  Map<String, dynamic>? applicationData;

  // Simulated dropdown data
  final List<String> categories = ['EBC', 'OBC', 'SC', 'ST', 'OPEN'];
  final List<String> allotmentTypes = ['CAP', 'Institute'];
  final List<String> branches = ['Computer', 'Mechanical', 'Civil', 'ENTC'];
  final List<String> admissionYears = [
    '2024-25',
    '2025-26',
    '2026-27',
    '2027-28',
  ];

  // Form controllers
  final _grController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  String? _selectedCategory;
  String? _selectedAllotmentType;
  String? _selectedBranch;
  String? _selectedAdmissionYear;
  final _roundController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _checkApplication() {
    // Simulate API lookup
    setState(() {
      // If ID matches, show form with data, else show empty form
      if (_idController.text.trim().isNotEmpty) {
        applicationData = {
          'id': _idController.text.trim(),
          'gr': '',
          'lastName': '',
          'firstName': '',
          'fatherName': '',
          'motherName': '',
          'category': categories[0],
          'allotmentType': allotmentTypes[0],
          'round': '1',
          'admissionYear': admissionYears[0],
          'branch': branches[0],
          'email': 'rajeshbelgaonkar19@gmail.com',
        };
        // Fill controllers
        _grController.text = applicationData!['gr'];
        _lastNameController.text = applicationData!['lastName'];
        _firstNameController.text = applicationData!['firstName'];
        _fatherNameController.text = applicationData!['fatherName'];
        _motherNameController.text = applicationData!['motherName'];
        _selectedCategory = applicationData!['category'];
        _selectedAllotmentType = applicationData!['allotmentType'];
        _roundController.text = applicationData!['round'];
        _selectedAdmissionYear = applicationData!['admissionYear'];
        _selectedBranch = applicationData!['branch'];
        _emailController.text = applicationData!['email'];
        _passwordController.text = '';
        showForm = true;
      }
    });
  }

  void _updateApplication() {
    // TODO: Implement update logic (API call)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application updated!')),
    );
  }

  void _cancelUpdate() {
    setState(() {
      showForm = false;
      _idController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: showForm
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Update Application",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Cap Application Number/College Id Number",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          initialValue: applicationData?['id'],
                          enabled: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _grController,
                          decoration: const InputDecoration(
                            labelText: "Gr Number",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: "Last Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: "First Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _fatherNameController,
                          decoration: const InputDecoration(
                            labelText: "Father Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _motherNameController,
                          decoration: const InputDecoration(
                            labelText: "Mother Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: const InputDecoration(
                            labelText: "Category",
                            border: OutlineInputBorder(),
                          ),
                          items: categories
                              .map((cat) => DropdownMenuItem<String>(
                                    value: cat,
                                    child: Text(cat),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedCategory = val),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: _selectedAllotmentType,
                          decoration: const InputDecoration(
                            labelText: "Allotment Type",
                            border: OutlineInputBorder(),
                          ),
                          items: allotmentTypes
                              .map((type) => DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedAllotmentType = val),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _roundController,
                          decoration: const InputDecoration(
                            labelText: "Round",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: _selectedAdmissionYear,
                          decoration: const InputDecoration(
                            labelText: "Admission Year",
                            border: OutlineInputBorder(),
                          ),
                          items: admissionYears
                              .map((year) => DropdownMenuItem<String>(
                                    value: year,
                                    child: Text(year),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedAdmissionYear = val),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: _selectedBranch,
                          decoration: const InputDecoration(
                            labelText: "Branch",
                            border: OutlineInputBorder(),
                          ),
                          items: branches
                              .map((branch) => DropdownMenuItem<String>(
                                    value: branch,
                                    child: Text(branch),
                                  ))
                              .toList(),
                          onChanged: (val) => setState(() => _selectedBranch = val),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: "New Password (optional)",
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size.fromHeight(48),
                                ),
                                onPressed: _updateApplication,
                                child: const Text("Update"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[300],
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size.fromHeight(48),
                                ),
                                onPressed: _cancelUpdate,
                                child: const Text("Cancel"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Check Application",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Application ID / College ID",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _idController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.blue[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[500],
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            onPressed: _checkApplication,
                            child: const Text("Check Application"),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
