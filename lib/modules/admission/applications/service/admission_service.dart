import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:erp_mobile_app/config/app_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/student_application.dart';

class AdmissionService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage =
      FlutterSecureStorage(); // Made private
  final String _baseUrl = AppConfig.baseUrl; // Made private

  AdmissionService() {
    _dio.options.baseUrl = _baseUrl;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await _secureStorage.read(key: "auth_token");

          // Check if token is not null and not empty before adding to headers
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            print('Authentication error: Token expired or invalid.');
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<List<StudentApplication>> fetchApplications(String academicId) async {
    try {
      final response = await _dio.get(
        '/admission/applications',
        queryParameters: {'academicYear': academicId},
      );

      if (response.statusCode == 200) {
        final data = response.data['applications'] as List;
        return data.map((e) => StudentApplication.fromJson(e)).toList();
      } else {
        throw Exception(
          'Failed to load applications with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('Error fetching applications (DioException): ${e.message}');
      if (e.response != null) {
        print(
          'Server responded with status: ${e.response?.statusCode}, data: ${e.response?.data}',
        );
      }
      throw Exception('Failed to load applications: ${e.message}');
    } catch (e) {
      print('Unexpected error fetching applications: $e');
      throw Exception(
        'An unexpected error occurred while loading applications',
      );
    }
  }

  // Future<List<String>> fetchAcademicYears() async {
  //   try {
  //     final response = await _dio.get('/admission/academic-years');
  //     print("acad years");
  //     print(response);
  //       log("mmm"+response.data);

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data is List
  //           ? response.data as List<dynamic>
  //           : (response.data as Map<String, dynamic>)['academic_year'] as List<dynamic>;

  //       return List<String>.from(data);
  //     } else {
  //       throw Exception('Failed to load academic years with status: ${response.statusCode}');
  //     }
  //   } on DioException catch (e) {
  //     print('Error fetching academic years (DioException): ${e.message}');
  //     if (e.response != null) {
  //       print('Server responded with status: ${e.response?.statusCode}, data: ${e.response?.data}');
  //     }
  //     throw Exception('Failed to load academic years: ${e.message}');
  //   } catch (e) {
  //     print('Unexpected error fetching academic years: $e');
  //     throw Exception('An unexpected error occurred while loading academic years');
  //   }
  // }

  Future<List<String>> fetchAcademicYears() async {
    try {
      final response = await _dio.get('/admission/academic-years');
      print("acad years");
      print(response);

      if (response.statusCode == 200) {
        final List<dynamic> data =
            (response.data as Map<String, dynamic>)['academic_year']
                as List<dynamic>;

        // Extract only academic_name values
        final List<String> academicYears = data
            .map((item) => item['academic_name'].toString())
            .toList();

        return academicYears;
      } else {
        throw Exception(
          'Failed to load academic years with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('Error fetching academic years (DioException): ${e.message}');
      if (e.response != null) {
        print(
          'Server responded with status: ${e.response?.statusCode}, data: ${e.response?.data}',
        );
      }
      throw Exception('Failed to load academic years: ${e.message}');
    } catch (e) {
      print('Unexpected error fetching academic years: $e');
      throw Exception(
        'An unexpected error occurred while loading academic years',
      );
    }
  }

  Future<List<String>> fetchPrograms(String year) async {
    try {
      final response = await _dio.get(
        '/admission/getProgram',
        queryParameters: {'year': year},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data =
            (response.data as Map<String, dynamic>)['program'] as List<dynamic>;

        final List<String> programs = data
            .map((item) => item['programm_name'].toString())
            .toList();
        return programs;
      } else {
        throw Exception(
          'Failed to load programs with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('Error fetching programs (DioException): ${e.message}');
      if (e.response != null) {
        print(
          'Server responded with status: ${e.response?.statusCode}, data: ${e.response?.data}',
        );
      }
      throw Exception('Failed to load programs: ${e.message}');
    } catch (e) {
      print('Unexpected error fetching programs: $e');
      throw Exception('An unexpected error occurred while loading programs');
    }
  }

  Future<List<String>> fetchBranches(String year, String program) async {
    try {
      final response = await _dio.get(
        '/admission/getBranch',
        queryParameters: {'year': year, 'program': program},
      );

      if (response.statusCode == 200) {
        print(response.data);
        final List<dynamic> data =
            (response.data as Map<String, dynamic>)['branch'] as List<dynamic>;

        final List<String> branches= data
            .map((item) => item['bname'].toString())
            .toList();
        return branches;
      } else {
        throw Exception(
          'Failed to load branches with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('Error fetching branches (DioException): ${e.message}');
      if (e.response != null) {
        print(
          'Server responded with status: ${e.response?.statusCode}, data: ${e.response?.data}',
        );
      }
      throw Exception('Failed to load branches: ${e.message}');
    } catch (e) {
      print('Unexpected error fetching branches: $e');
      throw Exception('An unexpected error occurred while loading branches');
    }
  }
}