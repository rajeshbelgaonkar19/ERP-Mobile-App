import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:typed_data';

class ApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://api.test.vppcoe.getflytechnologies.com/api',
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // Add this interceptor ONCE, when the class is first used
  static bool _interceptorAdded = false;

  static void _addAuthInterceptor() {
    if (_interceptorAdded) return;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    _interceptorAdded = true;
  }

  static Future<dynamic> get(String endpoint, {Map<String, dynamic>? params}) async {
    _addAuthInterceptor();
    try {
      final response = await dio.get(endpoint, queryParameters: params);
      return response.data;
    } catch (e) {
      throw Exception('GET Error: $e');
    }
  }

  static Future<Response<Uint8List>> getRaw(String endpoint, {Map<String, dynamic>? params}) async {
    _addAuthInterceptor();
    try {
      return await dio.get(
        endpoint,
        queryParameters: params,
        options: Options(responseType: ResponseType.bytes),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    _addAuthInterceptor();
    try {
      final response = await dio.post(endpoint, data: body);
      return response.data;
    } catch (e) {
      throw Exception('POST Error: $e');
    }
  }
}
