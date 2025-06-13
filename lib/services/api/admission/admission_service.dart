import 'package:dio/dio.dart';
import '../api_client.dart';

class AdmissionService {
  final Dio _dio = ApiClient.dio;

  Future<List<dynamic>> getBranches() async {
    try {
      final response = await _dio.get('/admission/getBranch');
      return response.data['branch'];
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<List<dynamic>> getPrograms() async {
    final response = await _dio.get('/admission/getProgram');
    return response.data['program'] as List<dynamic>;
  }

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get('/admission/getCategory');
      return response.data['category'];
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await _dio.get('/admission/admissionDashBoardN');
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<List<dynamic>> getAcademicYears() async {
    try {
      final response = await _dio.get('/admission/academic-years');
      return response.data['academic_year'];
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPendingCount() async {
    final response = await _dio.get('/admission/pendingCount');
    // API returns a list with one map
    return (response.data as List).first as Map<String, dynamic>;
  }

  void _handleDioError(DioException e) {
    print('🚨 DIO ERROR: ${e.message}');
    print('🚨 Status Code: ${e.response?.statusCode}');
    print('🚨 Response Body: ${e.response?.data}');
  }
}
