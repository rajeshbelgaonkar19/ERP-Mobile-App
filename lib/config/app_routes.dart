import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/auth/login_page.dart';
import '../modules/admission/admission_dashboard.dart';
import '../modules/hr/hr_dashboard.dart';
import '../modules/student/student_dashboard.dart';
import '../modules/faculty/faculty_dashboard.dart';
import '../modules/hod/hod_dashboard.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/admission-dashboard', builder: (context, state) => const AdmissionDashboard()),
      GoRoute(path: '/hr-dashboard', builder: (context, state) => const HRDashboard()),
      GoRoute(path: '/student-dashboard', builder: (context, state) => const StudentDashboard()),
      GoRoute(path: '/faculty-dashboard', builder: (context, state) => const FacultyDashboard()),
      GoRoute(path: '/hod-dashboard', builder: (context, state) => const HODDashboard()),
    ],
  );
}
