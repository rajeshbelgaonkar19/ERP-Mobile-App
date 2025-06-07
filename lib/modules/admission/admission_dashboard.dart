import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';

class AdmissionDashboard extends StatelessWidget {
  const AdmissionDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admission Dashboard', style: AppFonts.headingStyle(Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(
          'Welcome to Admission Dashboard!',
          style: AppFonts.subheadingStyle(AppColors.textPrimary),
        ),
      ),
    );
  }
}
