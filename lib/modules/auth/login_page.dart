import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final _storage = const FlutterSecureStorage();
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://api.test.vppcoe.getflytechnologies.com/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final response = await _dio.post('/login', data: {
          'email': email,
          'password': password,
        });

        final data = response.data;
        final token = data['token'];
        final userType = data['user_type'];

        if (token == null || userType == null) {
          _showError("Invalid response from server");
          return;
        }

        // Save token
        await _storage.write(key: 'auth_token', value: token);

        // Navigate based on role
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
            _showError('Unknown user type');
        }
      } on DioException catch (e) {
        final message = e.response?.data['message'] ?? 'Login failed';
        _showError(message);
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
                        Expanded(child: _buildLeftPanel()),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: _buildLoginForm(),
                        )),
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
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
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
          const SizedBox(height: 8),
          Center(
            child: Text('www.getflytechnologies.com', style: AppFonts.bodyStyle(AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
