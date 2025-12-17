/*

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient;

  ApiService(this._dioClient);

  String _generateRequestId() {
    return const Uuid().v4();
  }

  void updateAuthToken(String token) {
    _dioClient.dio.options.headers.addAll({'Authorization': 'Bearer $token'});
  }

  Future<ResponseModel> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final requestId = _generateRequestId();
      final result = await _dioClient.dio.get(endpoint, queryParameters: params, options: Options(
        headers: {
          'x-request-id': requestId,
        },
      ),);
      return ResponseModel.fromJson(result.data);
    } catch (e) {
      throw Exception("GET request failed: $e");
    }
  }

  Future<ResponseModel> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final requestId = _generateRequestId();
      final result =  await _dioClient.dio.post(endpoint, data: data, options: Options(
        headers: {
          'x-request-id': requestId,
        },
      ),);
      return ResponseModel.fromJson(result.data);
    } catch (e) {
      throw Exception("POST request failed: $e");
    }
  }

  Future<ResponseModel> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      final requestId = _generateRequestId();
      final result = await _dioClient.dio.put(endpoint, data: data, options: Options(
        headers: {
          'x-request-id': requestId,
        },
      ),);
      return ResponseModel.fromJson(result.data);
    } catch (e) {
      throw Exception("PUT request failed: $e");
    }
  }

  Future<ResponseModel> delete(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final requestId = _generateRequestId();
      final result = await _dioClient.dio.delete(endpoint, queryParameters: params, options: Options(
        headers: {
          'x-request-id': requestId,
        },
      ),);
      return ResponseModel.fromJson(result.data);
    } catch (e) {
      throw Exception("DELETE request failed: $e");
    }
  }
}

// API service provider
final apiServiceProvider = Provider((ref) => ApiService(ref.read(dioClientProvider)));*/
