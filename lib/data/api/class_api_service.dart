import 'package:dio/dio.dart';
import 'package:elara/data/models/api_models.dart';

class ClassApiService {
  final Dio _dio;

  ClassApiService(this._dio);

  Future<List<ClassModel>> getClasses() async {
    try {
      final response = await _dio.get('/api/classes');
      final List<dynamic> data = response.data;
      return data.map((json) => ClassModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch classes: ${e.toString()}');
    }
  }

  Future<ClassModel> getClass(int id) async {
    try {
      final response = await _dio.get('/api/classes/$id');
      return ClassModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch class: ${e.toString()}');
    }
  }

  Future<ClassModel> createClass(String name, String description) async {
    try {
      final response = await _dio.post(
        '/api/classes',
        data: {
          'name': name,
          'description': description,
        },
      );
      return ClassModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create class: ${e.toString()}');
    }
  }

  Future<void> deleteClass(int id) async {
    try {
      await _dio.delete('/api/classes/$id');
    } catch (e) {
      throw Exception('Failed to delete class: ${e.toString()}');
    }
  }

  Future<List<ClassModel>> getStudentClasses() async {
    try {
      final response = await _dio.get('/api/students/classes');
      final List<dynamic> data = response.data;
      return data.map((json) => ClassModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch student classes: ${e.toString()}');
    }
  }
}
