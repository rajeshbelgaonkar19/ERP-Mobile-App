class StudentApplication {
  final String? grNumber;
  final String? collegeId;
  final String? fullName;
  final String? branch;
  final String? programName;
  final String? academic_year;
  final String? category;
  final String? gender;
  final double? cutoffOpen;
  final double? cutoffSebc;

  StudentApplication({
    this.grNumber,
    this.collegeId,
    this.fullName,
    this.branch,
    this.programName,
    this.academic_year,
    this.category,
    this.gender,
    this.cutoffOpen,
    this.cutoffSebc,
  });

  factory StudentApplication.fromJson(Map<String, dynamic> json) {
    return StudentApplication(
      grNumber: json['gr_number'],
      collegeId: json['cap_application'],
      fullName: '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
      branch: json['branch'],
      programName: json['years'],
      academic_year: json['academic_year'],
      category: json['category'],
      gender: json['gender'],
      cutoffOpen: (json['cutoff_open'] != null)
          ? double.tryParse(json['cutoff_open'].toString())
          : null,
      cutoffSebc: (json['cutoff_sebc'] != null)
          ? double.tryParse(json['cutoff_sebc'].toString())
          : null,
    );
  }
}
