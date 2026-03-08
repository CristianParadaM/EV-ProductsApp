import 'package:dio/dio.dart';
import 'package:ev_products_app/core/environment/environments.dart';

class ClientApi {
  final Dio dio;

  ClientApi()
    : dio = Dio(
        BaseOptions(
          baseUrl: Environments.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.post<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.put<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return dio.delete<T>(path, data: data, queryParameters: queryParameters);
  }

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}
