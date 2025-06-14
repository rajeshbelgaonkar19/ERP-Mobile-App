import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../admission/api_client.dart';

class AuthService {
  final Dio _dio = ApiClient.dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final token = response.data['token'];
      if (token != null) {
        await _secureStorage.write(key: 'auth_token', value: token);
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      print('❌ Login failed: ${e.response?.data}');
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }
}
