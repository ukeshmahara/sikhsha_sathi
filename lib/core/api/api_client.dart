import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_endpoints.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(),
);

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? _createDio();

  final Dio _dio;

  static Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  Future<Response<dynamic>> get(String path) {
    return _dio.get(path);
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
  }) {
    return _dio.post(path, data: data);
  }
}
