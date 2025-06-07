import 'package:flutter/material.dart';
import 'core/themes/app_theme.dart';
import 'config/app_routes.dart';

void main() {
  runApp(const ERPApp());
}

class ERPApp extends StatelessWidget {
  const ERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ERP Mobile App',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
