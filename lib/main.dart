import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/themes/app_theme.dart';
import 'config/app_routes.dart';

void main() {
<<<<<<< HEAD
  runApp(const ProviderScope(child: ERPApp()));
=======
  runApp(const ERPApp());
  runApp(ProviderScope(child: ERPApp()));
>>>>>>> f863c1580f330f6827e97bf8d1a5547db5c12d6d
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
