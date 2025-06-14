import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'api_client.dart';

class AdmissionService {
  Future<List<dynamic>> getBranches() async {
    final response = await ApiClient.get('/admission/getBranch');
    return response['branch'] ?? [];
  }

  Future<List<dynamic>> getPrograms() async {
    final response = await ApiClient.get('/admission/getProgram');
    return response['program'] ?? [];
  }

  Future<List<dynamic>> getCategories() async {
    final response = await ApiClient.get('/admission/getCategory');
    return response['category'] ?? [];
  }

  Future<Map<String, dynamic>> getDashboardData() async {
    return await ApiClient.get('/admission/admissionDashBoardN');
  }

  Future<List<dynamic>> getPendingCounts() async {
    return await ApiClient.get('/admission/pendingCount');
  }

  Future<List<dynamic>> getAcademicYears() async {
    final response = await ApiClient.get('/admission/academic-years');
    return response['academic_year'] ?? [];
  }

  Future<List<dynamic>> getApplications(int academicYear) async {
    final response = await ApiClient.get('/admission/applications', params: {
      'academicYear': academicYear,
    });
    return response['applications'] ?? [];
  }

  Future<List<dynamic>> getSignups(int academicYear) async {
    final response = await ApiClient.get('/admission/signup', params: {
      'academicYear': academicYear,
    });
    return response['branch'] ?? [];
  }

  Future<Map<String, dynamic>> getCapApplicationById(String studId) async {
    return await ApiClient.get('/admission/addCapApp/$studId');
  }

  Future<Map<String, dynamic>> startAdmission(int academicYear) async {
    return await ApiClient.post('/admission/start-admission', body: {
      'academicYear': academicYear,
    });
  }

  Future<Map<String, dynamic>> stopAdmission(int academicYear) async {
    return await ApiClient.post('/admission/stop-admission', body: {
      'academicYear': academicYear,
    });
  }

  Future<Map<String, dynamic>> addOrUpdateCapApp(Map<String, dynamic> data) async {
    return await ApiClient.post('/admission/addCapApp', body: data);
  }

  Future<Map<String, dynamic>> revertCancelledApp(int uid, int academicYear) async {
    return await ApiClient.post('/admission/revert_cancel', body: {
      'uid': uid,
      'academicYear': academicYear
    });
  }

  Future<List<dynamic>> getCancelledApplications(int academicYear) async {
    final response = await ApiClient.get('/admission/cancelled_applications', params: {
      'academicYear': academicYear
    });
    return response['cancelledResult'] ?? [];
  }

  Future<List<dynamic>> getCutoffTrend() async {
    final response = await ApiClient.get('/admission/cutoffTrend');
    return response['cutoff_trend'] ?? [];
  }

  // Future<Response<Uint8List>> downloadCancelledReport(int academicYear) async {
  //   return await ApiClient.getRaw('/admission/cancelled_applications_report', params: {
  //     'academicYear': academicYear
  //   });
  // }
}












// import 'package:dio/dio.dart';
// import '../api_client.dart';

// class AdmissionService {
//   final Dio _dio = ApiClient.dio;

//   Future<List<dynamic>> getBranches() async {
//     try {
//       final response = await _dio.get('/admission/getBranch');
//       return response.data['branch'];
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow;
//     }
//   }

//   Future<List<dynamic>> getPrograms() async {
//     final response = await _dio.get('/admission/getProgram');
//     return response.data['program'] as List<dynamic>;
//   }

//   Future<List<dynamic>> getCategories() async {
//     try {
//       final response = await _dio.get('/admission/getCategory');
//       return response.data['category'];
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>> getDashboardData() async {
//     try {
//       final response = await _dio.get('/admission/admissionDashBoardN');
//       return response.data;
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow;
//     }
//   }

//   Future<List<dynamic>> getAcademicYears() async {
//     try {
//       final response = await _dio.get('/admission/academic-years');
//       return response.data['academic_year'];
//     } on DioException catch (e) {
//       _handleDioError(e);
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>> getPendingCount() async {
//     final response = await _dio.get('/admission/pendingCount');
//     // API returns a list with one map
//     return (response.data as List).first as Map<String, dynamic>;
//   }

//   void _handleDioError(DioException e) {
//     print('🚨 DIO ERROR: ${e.message}');
//     print('🚨 Status Code: ${e.response?.statusCode}');
//     print('🚨 Response Body: ${e.response?.data}');
//   }
// }
