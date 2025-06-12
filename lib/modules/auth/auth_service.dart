import 'package:dio/dio.dart';
import '../../config/app_config.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/api/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return {
          'token': response.data['token'],
          'user_type': response.data['user_type'],
          'base': response.data['base'],
          'uid': response.data['uid'],
          'sid': response.data['sid'],
          'branch_id': response.data['branch_id'],
        };
      } else {
        return null;
      }
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> f863c1580f330f6827e97bf8d1a5547db5c12d6d
