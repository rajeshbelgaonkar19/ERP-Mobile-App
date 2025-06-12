class StudentApplication {
  final String? grNumber;
  final String? collegeId;
  final String? fullName;
  final String? branch;
  final String? program;

  StudentApplication({
    this.grNumber,
    this.collegeId,
    this.fullName,
    this.branch,
    this.program,
  });

  factory StudentApplication.fromJson(Map<String, dynamic> json) {
    return StudentApplication(
      grNumber: json['gr_number'],
      collegeId: json['cap_application'],
      fullName: '${json['first_name'] ?? ''} ${json['last_name'] ?? ''}'.trim(),
      branch: json['branch'],
      program: json['years'],
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> f863c1580f330f6827e97bf8d1a5547db5c12d6d
