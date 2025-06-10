import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (password != '12345678') {
        _showError('Incorrect password!');
        return;
      }

      if (email == 'admission@pvppcoe.ac.in') {
        context.go('/admission-dashboard');
      } else if (email == 'hr@pvppcoe.ac.in') {
        context.go('/hr-dashboard');
      } else if (email == 'hodcomps@pvppcoe.ac.in') {
        context.go('/hod-dashboard');
      } else if (email == 'facultydemo@pvppcoe.ac.in') {
        context.go('/faculty-dashboard');
      } else if (email == 'dummy11@gmail.com') {
        context.go('/student-dashboard');
      } else {
        _showError('Invalid email for login.');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return Center(
            child: Container(
              width: isWide ? 800 : double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isWide
                  ? Row(
                      children: [
                        // Black box
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.textPrimary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                // Logo inside a white-background container
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Image.asset(
                                    'assets/logo.png',
                                    height: 100,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Vasantdada Patil Pratishthan's\nCollege of Engineering & Visual Arts",
                                  style: AppFonts.headingStyle(Colors.white, fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Login form
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: _buildLoginForm(),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        // Black box
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.textPrimary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              // Logo inside a white-background container
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/logo.png',
                                  height: 80,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Vasantdada Patil Pratishthan's\nCollege of Engineering & Visual Arts",
                                style: AppFonts.headingStyle(Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        // Login form
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildLoginForm(),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Login', style: AppFonts.headingStyle(AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Welcome to Acadamate. Please login for an account.', style: AppFonts.bodyStyle(AppColors.textSecondary)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email address'),
            validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            //   const Text("Don't have an account? "),
            //   TextButton(
            //     onPressed: () {},
            //     child: const Text('Sign Up'),
            //   ),
            // ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text('www.getflytechnologies.com', style: AppFonts.bodyStyle(AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
