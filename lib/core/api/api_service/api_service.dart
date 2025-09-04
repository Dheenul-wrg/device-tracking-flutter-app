import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../status_code.dart';
import '../wrg_response.dart';

part 'api_service.g.dart';

const kBaseUrl = 'http://192.168.0.33:3000/api/';

abstract class ApiServiceBase {
  Future<WrgResponse<T>> get<T>({
    required String endpoint,
    required Map<String, dynamic> params,
    required T Function(dynamic) decoder,
  });
  Future<WrgResponse<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(dynamic) decoder,
    Map<String, dynamic>? params,
  });
  Future<WrgResponse<T>> delete<T>({
    required String endpoint,
    required T Function(dynamic data) decoder,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  });
  Future<WrgResponse<T>> patch<T>({
    required String endpoint,
    required T Function(dynamic data) decoder,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  });
}

@riverpod
ApiService devicetrackingApiService(Ref ref) {
  final dio = Dio();
  dio.options.baseUrl = kBaseUrl;

  // Add timeout configuration to prevent hanging
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  dio.options.sendTimeout = const Duration(seconds: 10);

  dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  return ApiService(dio: dio, ref: ref);
}

class ApiService implements ApiServiceBase {
  final Dio dio;
  final Ref ref;

  ApiService({required this.dio, required this.ref});

  @override
  Future<WrgResponse<T>> get<T>({
    required String endpoint,
    required Map<String, dynamic> params,
    required T Function(dynamic p1) decoder,
  }) async {
    try {
      final response = await dio.get(endpoint, queryParameters: params);
      return _parseResponse(response, decoder);
    } on DioException catch (e) {
      return _dioExceptionErrorResponse(e.type);
    }
  }

  @override
  Future<WrgResponse<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(dynamic p1) decoder,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await dio.post(
        endpoint,
        data: body,
        queryParameters: params,
      );
      return _parseResponse(response, decoder);
    } on DioException catch (e) {
      return _dioExceptionErrorResponse(e.type);
    }
  }

  @override
  Future<WrgResponse<T>> delete<T>({
    required String endpoint,
    required T Function(dynamic data) decoder,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await dio.delete(
        endpoint,
        data: body,
        queryParameters: params,
      );
      return _parseResponse(response, decoder);
    } on DioException catch (e) {
      return _dioExceptionErrorResponse(e.type);
    }
  }

  @override
  Future<WrgResponse<T>> patch<T>({
    required String endpoint,
    required T Function(dynamic data) decoder,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await dio.patch(
        endpoint,
        data: body,
        queryParameters: params,
      );
      return _parseResponse(response, decoder);
    } on DioException catch (e) {
      return _dioExceptionErrorResponse(e.type);
    }
  }

  // ✅ Parse Response
  WrgResponse<T> _parseResponse<T>(
    Response<dynamic>? response,
    T Function(dynamic data) decoder,
  ) {
    try {
      return WrgResponse(data: decoder(response?.data));
    } catch (e) {
      if (response?.data is Map && response?.data['error'] != null) {
        final error = ApiError.fromMap(response?.data['error']);
        return WrgResponse(error: error);
      }
      return _genericErrorResponse();
    }
  }

  WrgResponse<T> _dioExceptionErrorResponse<T>(DioExceptionType errorType) {
    switch (errorType) {
      case DioExceptionType.receiveTimeout ||
          DioExceptionType.connectionTimeout ||
          DioExceptionType.connectionError:
        return WrgResponse<T>(
          error: ApiError(
            status: StatusCode.noInternet,
            name: 'Connection Error',
            message:
                'Unable to connect. Please check your internet connection and try again.',
          ),
        );
      case DioExceptionType.badResponse:
        return WrgResponse<T>(
          error: ApiError(
            status: StatusCode.badRequest,
            name: 'Server Error',
            message: 'Server returned an error. Please try again later.',
          ),
        );
      case DioExceptionType.cancel:
        return WrgResponse<T>(
          error: ApiError(
            status: StatusCode.unknownError,
            name: 'Request Cancelled',
            message: 'Request was cancelled.',
          ),
        );
      default:
        return _genericErrorResponse();
    }
  }

  // ✅ Generic error fallback
  WrgResponse<T> _genericErrorResponse<T>({
    StatusCode code = StatusCode.unknownError,
  }) {
    return WrgResponse<T>(
      error: ApiError(
        status: code,
        name: 'Unknown Error',
        message: 'Something went wrong. Please try again later.',
      ),
    );
  }
}
