import 'package:dio/dio.dart';
import 'package:erp_mobile_app/config/app_config.dart';
import '../model/student_application.dart';

class AdmissionService {
  final Dio _dio = Dio();
  final String baseUrl = AppConfig.baseUrl;

  Future<List<StudentApplication>> fetchApplications(int academicId) async {
    try {
      final response = await _dio.get('$baseUrl/admission/applications', queryParameters: {
        'academicYear': academicId,
      });

      final data = response.data['applications'] as List;
      return data.map((e) => StudentApplication.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching applications: $e');
      throw Exception('Failed to load applications');
    }
  }
}
