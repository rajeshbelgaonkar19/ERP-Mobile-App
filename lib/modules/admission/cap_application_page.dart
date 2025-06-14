import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api/admission/admission_provider.dart';

class CAPApplicationPage extends ConsumerStatefulWidget {
  const CAPApplicationPage({super.key});

  @override
  ConsumerState<CAPApplicationPage> createState() => _CAPApplicationPageState();
}

class _CAPApplicationPageState extends ConsumerState<CAPApplicationPage> {
  final _idController = TextEditingController();
  bool showForm = false;

  // Simulated application data (replace with API call in real app)
  Map<String, dynamic>? applicationData;

  // Hardcoded fallback lists
  final List<String> fallbackCategories = [
    'OBC', 'EBC', 'EWS', 'SBC', 'VJ', 'NT', 'SC', 'ST', 'TFWS', 'J&K'
  ];
  final List<String> fallbackBranches = [
    'Computer Engineering',
    'Computer Science & Engineering (Ai & MI)',
    'Electronics and Telecommunication Engineering',
    'Information Technology',
    'Mechatronics',
    'Electronics & Computer Science',
    'Electronics',
    'Artificial Intelligence and Data Science',
  ];

  // In your state:
  List<String> categories = [];
  List<String> branches = []; // Will be fetched from API

  List<String> allotmentTypes = ['CAP', 'AGAINST CAP', 'INSTITUTE LEVEL'];
  List<String> academicYears = [
    'First Year Bachelor of Engineering (F.Y. B.E.)',
    'Direct Second Year Engineering (D.S.E.)',
    'Second Year Engineering (S.E.)',
    'Third Year Engineering (T.E.)',
    'Final Year Engineering (B.E.)',
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

  void _checkApplication() async {
    if (_idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Application ID')),
      );
      return;
    }

    try {
      final data = await ref.read(admissionServiceProvider).getCapApplicationById(_idController.text.trim());
      setState(() {
        applicationData = data;
        // Set your controllers here from data if needed
        showForm = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Application not found')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    try {
      final catList = await ref.read(admissionCategoriesProvider.future);
      setState(() {
        categories = catList.map<String>((e) => e['cat_name'] as String).toList();
      });
    } catch (_) {
      setState(() {
        categories = fallbackCategories;
      });
    }
    try {
      final branchList = await ref.read(admissionBranchesProvider.future);
      setState(() {
        branches = branchList.map<String>((e) => e['branch_name'] as String).toList();
      });
    } catch (_) {
      setState(() {
        branches = fallbackBranches;
      });
    }
    // Fetch years
    final yearList = await ref.read(academicYearsProvider.future);
    setState(() {
      academicYears = yearList.map<String>((e) => e['academic_name'] as String).toList();
    });
  }

  Future<void> _updateApplication() async {
    // Validate all required fields
    if (_idController.text.trim().isEmpty ||
        _grController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _firstNameController.text.trim().isEmpty ||
        _fatherNameController.text.trim().isEmpty ||
        _motherNameController.text.trim().isEmpty ||
        _selectedCategory == null ||
        _selectedAllotmentType == null ||
        _roundController.text.trim().isEmpty ||
        _selectedAdmissionYear == null ||
        _selectedBranch == null ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields!')),
      );
      return;
    }

    final data = {
      "cap_application": _idController.text.trim(),
      "gr_number": _grController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "first_name": _firstNameController.text.trim(),
      "father_name": _fatherNameController.text.trim(),
      "mother_name": _motherNameController.text.trim(),
      "cat": _selectedCategory,
      "seat_type": _selectedAllotmentType,
      "round": _roundController.text.trim(),
      "years": _selectedAdmissionYear,
      "branch": _selectedBranch,
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
    };

    try {
      final result = await ref.read(admissionServiceProvider).addOrUpdateCapApp(data);
      // Show success dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Success'),
          content: Text(result['message'] ?? 'Application updated!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  showForm = false;
                  _idController.clear();
                  _grController.clear();
                  _lastNameController.clear();
                  _firstNameController.clear();
                  _fatherNameController.clear();
                  _motherNameController.clear();
                  _selectedCategory = null;
                  _selectedAllotmentType = null;
                  _roundController.clear();
                  _selectedAdmissionYear = null;
                  _selectedBranch = null;
                  _emailController.clear();
                  _passwordController.clear();
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update: $e')),
      );
    }
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
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8), // Reduced horizontal padding
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 340), // Reduced maxWidth to avoid overflow
              child: Column(
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
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: "Cap Application Number/College Id Number",
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
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 14),
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
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: "Academic Year",
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 14), // Smaller font
                    items: academicYears
                        .map((year) => DropdownMenuItem<String>(
                              value: year,
                              child: Text(year, style: const TextStyle(fontSize: 14)),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedAdmissionYear = val),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _selectedBranch,
                    isExpanded: true, // Ensures dropdown icon is inside the box
                    decoration: const InputDecoration(
                      labelText: "Branch",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 14),
                    items: branches
                        .map((branch) => DropdownMenuItem<String>(
                              value: branch,
                              child: Text(branch, overflow: TextOverflow.ellipsis),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
