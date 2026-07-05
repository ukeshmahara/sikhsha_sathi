import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage/token_service.dart';
import 'api_endpoints.dart';

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    tokenService: ref.read(tokenServiceProvider),
  ),
);

class ApiClient {
  final Dio _dio;
  final TokenService _tokenService;

  ApiClient({
    required TokenService tokenService,
    Dio? dio,
  })  : _tokenService = tokenService,
        _dio = dio ?? Dio() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenService.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
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

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
  }) {
    return _dio.put(path, data: data);
  }

  Future<Response<dynamic>> patch(  
    String path, {
    dynamic data,
    Options? options,
  }) {
    return _dio.patch(path, data: data, options: options);
  }

  Future<Response<dynamic>> delete(String path) {
    return _dio.delete(path);
  }

  Future<Response<dynamic>> uploadFile(
    String path, {
    required FormData formData,
    Options? options,
  }) {
    return _dio.put(
      path,
      data: formData,
      options: options,
    );
  }
}