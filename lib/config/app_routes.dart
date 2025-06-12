import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/auth/login_page.dart';
import '../modules/admission/admission_dashboard.dart';
import '../modules/hr/hr_dashboard.dart';
import '../modules/student/student_dashboard.dart';
import '../modules/faculty/faculty_dashboard.dart';
import '../modules/hod/hod_dashboard.dart';
import '../modules/components/header_nav.dart';
import '../modules/admission/applications/applications_page.dart';
import '../modules/admission/cancelled_applications/cancelled_applications_page.dart';
import '../modules/admission/student_admission_page.dart';
import '../modules/admission/cap_application_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/admission-dashboard',
        builder: (context, state) => _withHeaderNav(const AdmissionDashboard()),
      ),
      GoRoute(
        path: '/hr-dashboard',
        builder: (context, state) => _withHeaderNav(const HRDashboard()),
      ),
      GoRoute(
        path: '/student-dashboard',
        builder: (context, state) => _withHeaderNav(const StudentDashboard()),
      ),
      GoRoute(
        path: '/faculty-dashboard',
        builder: (context, state) => _withHeaderNav(const FacultyDashboard()),
      ),
      GoRoute(
        path: '/hod-dashboard',
        builder: (context, state) => _withHeaderNav(const HODDashboard()),
      ),
      GoRoute(
        path: '/applications',
<<<<<<< HEAD
        // builder: (context, state) => _withHeaderNav(const ApplicationsPage()),
=======
>>>>>>> f863c1580f330f6827e97bf8d1a5547db5c12d6d
        builder: (context, state) => _withHeaderNav(StudentAdmissionDetailsPage()),
      ),
      GoRoute(
        path: '/cancelled-apps',
        builder: (context, state) => _withHeaderNav(const CancelledApplicationsPage()),
      ),
      GoRoute(
        path: '/student-admission',
        builder: (context, state) => _withHeaderNav(const StudentAdmissionPage()),
      ),
      // GoRoute(
      //   path: '/cancelled-applications',
      //   builder: (context, state) => _withHeaderNav(const CancelledApplicationsPage()),
      // ),
      // GoRoute(
      //   path: '/student-admission',
      //   builder: (context, state) => _withHeaderNav(const StudentAdmissionPage()),
      // ),
      GoRoute(
        path: '/cap-application',
        builder: (context, state) => _withHeaderNav(const CAPApplicationPage()),
      ),
    ],
  );

  // Helper to add the header navigation bar
  // In app_routes.dart
static Widget _withHeaderNav(Widget childPage) {
  return HeaderNav(bodyContent: childPage); // NOT using appBar anymore
}

}
