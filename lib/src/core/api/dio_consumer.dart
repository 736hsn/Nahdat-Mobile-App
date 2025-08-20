import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/models/result.dart';
import 'endpoints.dart';

@singleton
class DioConsumer {
  final String baseUrl = EndPoints.baserUrl;
  late final Dio _dio;
  final SharedPreferences? _preferences = GetIt.instance<SharedPreferences>();

  DioConsumer() {
    _dio = Dio();
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: false,
        compact: false,
        maxWidth: 90,
      ),
    );
  }

  Map<String, dynamic> _generateHeaders([Map<String, String>? headers]) {
    return {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'authorization': "bearer ${_preferences?.getString('token')}",
      ...?headers,
    };
  }

  Future<Result<Response>> _sendRequest(
    String endpoint,
    Future<Response> Function() request,
  ) async {
    try {
      final response = await request();
      // print('api response statusCode: ${response.statusCode}');
      // print('--++-- api ${endpoint} ${response.statusCode}');

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        return Result(data: response);
      } else if (response.statusCode == 401) {
        return Result(error: 'Request failed: ${response.data}');
      } else {
        return Result(error: 'Request failed: ${response.data}');
      }
    } catch (e) {
      if (e is DioException) {
        return Result(error: e.response?.data?.toString() ?? e.toString());
      }
      return Result(error: e.toString());
    }
  }

  Future<Result<Response>> get({
    required String endpoint,
    Map<String, String>? headers,
    bool isMapSearch = false,
  }) async {
    return _sendRequest(
      endpoint,
      () => _dio.get(
        isMapSearch ? endpoint : '$baseUrl$endpoint',
        options: Options(headers: _generateHeaders(headers)),
      ),
    );
  }

  Future<Result<Response>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    return _sendRequest(
      endpoint,
      () => _dio.post(
        '$baseUrl$endpoint',
        options: Options(headers: _generateHeaders(headers)),
        data: body,
      ),
    );
  }

  Future<Result<Response>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _sendRequest(
      endpoint,
      () => _dio.put(
        '$baseUrl$endpoint',
        options: Options(headers: _generateHeaders(headers)),
        data: body,
        queryParameters: queryParameters,
      ),
    );
  }

  Future<Result<Response>> delete({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    return _sendRequest(
      endpoint,
      () => _dio.delete(
        '$baseUrl$endpoint',
        options: Options(headers: _generateHeaders(headers)),
      ),
    );
  }

  Future<Result<Response>> multipartPost({
    required String endpoint,
    required Map<String, String> fields,
    required Map<String, List<MultipartFile>> fileSections,
    Map<String, String>? headers,
  }) async {
    try {
      // Create a combined FormData object
      final formData = FormData.fromMap({
        ...fields,
        for (final entry in fileSections.entries) entry.key: entry.value,
      });

      // Perform the POST request
      final response = await _dio.post(
        '$baseUrl$endpoint',
        data: formData,
        options: Options(headers: _generateHeaders(headers)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Result(data: response);
      }

      return Result(error: 'Request failed: ${response.data}');
    } catch (e) {
      if (e is DioException) {
        return Result(error: e.response?.data?.toString() ?? e.toString());
      }
      return Result(error: e.toString());
    }
  }
}
