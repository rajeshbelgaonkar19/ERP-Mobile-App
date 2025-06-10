import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.test.vppcoe.getflytechnologies.com/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        const storage = FlutterSecureStorage();
        final token = await storage.read(key: 'auth_token');

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
    ));
}
