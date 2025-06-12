import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth/auth_service.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import 'secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _secureStorage = const FlutterSecureStorage();
  final _authService = AuthService();
  final _storageService = SecureStorageService();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      setState(() => _isLoading = true);

      try {
        final result = await _authService.login(email, password);

        setState(() => _isLoading = false);

        if (result != null && result['token'] != null && result['user_type'] != null) {
          final token = result['token'];
          final userType = result['user_type'];

          await _secureStorage.write(key: 'auth_token', value: token);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );

          switch (userType) {
            case 3:
              context.go('/admission-dashboard');
              break;
            case 1:
              context.go('/hr-dashboard');
              break;
            case 7:
              context.go('/hod-dashboard');
              break;
            case 2:
              context.go('/faculty-dashboard');
              break;
            case 4:
              context.go('/student-dashboard');
              break;
            default:
              _showError('Unknown user role.');
          }
        } else {
          _showError('Login failed. Please check credentials.');
        }
      } on DioException catch (e) {
        setState(() => _isLoading = false);
        final message = e.response?.data['message'] ?? 'Login failed';
        _showError(message);
      } catch (e) {
        setState(() => _isLoading = false);
        _showError('An unexpected error occurred.');
      }
    }
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
                        Expanded(child: _buildLeftPanel()),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: _buildLoginForm(),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildLeftPanel(isMobile: true),
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

  Widget _buildLeftPanel({bool isMobile = false}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/logo.png',
              height: isMobile ? 80 : 100,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Vasantdada Patil Pratishthan's\nCollege of Engineering & Visual Arts",
            style: AppFonts.headingStyle(Colors.white, fontSize: isMobile ? 16 : 18),
            textAlign: TextAlign.center,
          ),
        ],
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
          Text(
            'Welcome to Acadamate. Please login for an account.',
            style: AppFonts.bodyStyle(AppColors.textSecondary),
          ),
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
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 8),
          // Removed the "Don't have an account? Sign Up" row here
          const SizedBox(height: 8),
          Center(
            child: Text('www.getflytechnologies.com', style: AppFonts.bodyStyle(AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
