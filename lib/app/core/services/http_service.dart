import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import '../config/environment_config.dart';
import '../utils/api_result.dart';
import 'error_handler_center.dart';

/// HTTP服务类 - 重构后的统一版本
class HttpService extends getx.GetxService {
  static HttpService get to => getx.Get.find();

  late Dio _dio;
  final Connectivity _connectivity = Connectivity();
  final EnvironmentConfig _envConfig = EnvironmentConfig.instance;
  final ErrorHandlerCenter _errorHandler = ErrorHandlerCenter();

  /// 基础URL
  String get baseUrl => _envConfig.baseUrl;

  /// 连接超时时间（毫秒）
  int get connectTimeout => _envConfig.connectTimeout;

  /// 接收超时时间（毫秒）
  int get receiveTimeout => _envConfig.receiveTimeout;

  /// 是否启用日志
  bool get enableLogging => _envConfig.enableNetworkLogging;

  @override
  void onInit() {
    super.onInit();
    _envConfig.printEnvironmentInfo();
    _initDio();
  }

  /// 初始化Dio
  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(milliseconds: connectTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(_createInterceptor());

    if (_envConfig.isDebug && _envConfig.maxRetryCount > 0) {
      _dio.interceptors.add(_createRetryInterceptor());
    }
  }

  /// 创建拦截器
  Interceptor _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!await _checkConnectivity()) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: '网络连接不可用',
              type: DioExceptionType.connectionError,
            ),
          );
          return;
        }

        _logRequest(options);
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logResponse(response);
        handler.next(response);
      },
      onError: (error, handler) {
        _logError(error);
        handler.next(error);
      },
    );
  }

  /// 创建重试拦截器
  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        if (_shouldRetry(error)) {
          try {
            final response = await _dio.fetch(error.requestOptions);
            handler.resolve(response);
            return;
          } catch (e) {
            // 重试失败，继续抛出原错误
          }
        }
        handler.next(error);
      },
    );
  }

  /// 判断是否应该重试
  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
           error.type == DioExceptionType.receiveTimeout ||
           error.type == DioExceptionType.connectionError;
  }

  /// 检查网络连接
  Future<bool> _checkConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return true; // 如果检查失败，假设网络可用
    }
  }

  /// 统一的HTTP请求方法 - 消除重复逻辑
  Future<ApiResult<T>> _executeRequest<T>(
    String method,
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      late Response response;
      
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case 'POST':
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case 'PUT':
          response = await _dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        case 'DELETE':
          response = await _dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }
      
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _errorHandler.handleException<T>(e);
    } catch (e) {
      return _errorHandler.handleException<T>(Exception(e.toString()));
    }
  }

  /// GET请求
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) => _executeRequest<T>('GET', path, 
      queryParameters: queryParameters, 
      options: options, 
      fromJson: fromJson);

  /// POST请求
  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) => _executeRequest<T>('POST', path, 
      data: data, 
      queryParameters: queryParameters, 
      options: options, 
      fromJson: fromJson);

  /// PUT请求
  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) => _executeRequest<T>('PUT', path, 
      data: data, 
      queryParameters: queryParameters, 
      options: options, 
      fromJson: fromJson);

  /// DELETE请求
  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) => _executeRequest<T>('DELETE', path, 
      data: data, 
      queryParameters: queryParameters, 
      options: options, 
      fromJson: fromJson);

  /// 文件上传
  Future<ApiResult<T>> uploadFile<T>(
    String path,
    File file, {
    String? fileName,
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName ?? file.path.split('/').last,
        ),
        if (data != null) ...data,
      });

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
      );
      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return _errorHandler.handleException<T>(e);
    } catch (e) {
      return _errorHandler.handleException<T>(Exception('文件上传失败: $e'));
    }
  }

  /// 文件下载
  Future<ApiResult<String>> downloadFile(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResult.success(data: savePath, message: '文件下载成功');
    } on DioException catch (e) {
      return _errorHandler.handleException<String>(e);
    } catch (e) {
      return _errorHandler.handleException<String>(Exception('文件下载失败: $e'));
    }
  }

  /// 处理响应 - 简化版本
  ApiResult<T> _handleResponse<T>(
    Response response,
    T Function(dynamic)? fromJson,
  ) {
    // 检查HTTP状态码
    if (response.statusCode != 200 && response.statusCode != 201) {
      return _errorHandler.handleErrorCode<T>(response.statusCode, 'HTTP请求失败');
    }

    final data = response.data;
    
    // 检查响应体中的业务code
    if (data is Map<String, dynamic>) {
      final code = data['code'] as int?;
      final message = data['msg'] as String? ?? 
                     data['message'] as String? ?? 
                     '请求成功';
      
      if (code == 200) {
        // 业务逻辑成功
        if (fromJson != null) {
          try {
            final convertedData = fromJson(data);
            return ApiResult.success(data: convertedData, message: message);
          } catch (e) {
            return ApiResult.failure(message: '数据解析失败: $e', errorCode: code);
          }
        }
        return ApiResult.success(data: data as T, message: message);
      } else {
        // 业务逻辑失败，使用错误处理中心
        return _errorHandler.handleErrorCode<T>(code, message);
      }
    }

    // 非Map格式响应
    if (fromJson != null && data != null) {
      try {
        final convertedData = fromJson(data);
        return ApiResult.success(data: convertedData);
      } catch (e) {
        return ApiResult.failure(message: '数据解析失败: $e');
      }
    }

    return ApiResult.success(data: data as T);
  }

  /// 取消所有请求
  void cancelAllRequests() {
    _dio.close(force: true);
    _initDio();
  }

  /// 打印请求信息
  void _logRequest(RequestOptions options) {
    if (!enableLogging) return;

    final timestamp = DateTime.now().toIso8601String();
    final fullUrl = '${options.baseUrl}${options.path}';

    print('\n' + '=' * 80);
    print('🚀 HTTP REQUEST [${options.method.toUpperCase()}] - $timestamp');
    print('=' * 80);
    print('📍 URL: $fullUrl');

    if (options.queryParameters.isNotEmpty) {
      print('🔍 Query Parameters:');
      options.queryParameters.forEach((key, value) {
        print('   $key: $value');
      });
    }

    print('📋 Headers:');
    options.headers.forEach((key, value) {
      if (key.toLowerCase().contains('authorization') ||
          key.toLowerCase().contains('token')) {
        print('   $key: ${_maskSensitiveData(value.toString())}');
      } else {
        print('   $key: $value');
      }
    });

    if (options.data != null) {
      print('📦 Request Body:');
      try {
        if (options.data is Map || options.data is List) {
          print('   ${_formatJson(options.data)}');
        } else {
          print('   ${options.data}');
        }
      } catch (e) {
        print('   ${options.data}');
      }
    }

    print('⏱️  Timeout: Connect(${options.connectTimeout?.inMilliseconds}ms) | Receive(${options.receiveTimeout?.inMilliseconds}ms)');
    print('=' * 80 + '\n');
  }

  /// 打印响应信息
  void _logResponse(Response response) {
    if (!enableLogging) return;

    final timestamp = DateTime.now().toIso8601String();
    final requestOptions = response.requestOptions;
    final fullUrl = '${requestOptions.baseUrl}${requestOptions.path}';

    print('\n' + '=' * 80);
    print('✅ HTTP RESPONSE [${response.statusCode}] - $timestamp');
    print('=' * 80);
    print('📍 URL: $fullUrl');
    print('🔄 Method: ${requestOptions.method.toUpperCase()}');
    print('📊 Status: ${response.statusCode} ${response.statusMessage ?? ''}');

    print('📦 Response Data:');
    try {
      if (response.data is Map || response.data is List) {
        final jsonStr = _formatJson(response.data);
        debugPrint('   $jsonStr');
      } else {
        final dataStr = response.data.toString();
        debugPrint('   $dataStr');
      }
    } catch (e) {
      print('   ${response.data}');
    }

    print('📏 Content Length: ${response.data.toString().length} characters');
    print('=' * 80 + '\n');
  }

  /// 打印错误信息
  void _logError(DioException error) {
    if (!enableLogging) return;

    final timestamp = DateTime.now().toIso8601String();
    final requestOptions = error.requestOptions;
    final fullUrl = '${requestOptions.baseUrl}${requestOptions.path}';

    print('\n' + '=' * 80);
    print('❌ HTTP ERROR [${error.response?.statusCode ?? 'UNKNOWN'}] - $timestamp');
    print('=' * 80);
    print('📍 URL: $fullUrl');
    print('🔄 Method: ${requestOptions.method.toUpperCase()}');
    print('🚨 Error Type: ${error.type}');
    print('💬 Error Message: ${error.message ?? 'Unknown error'}');

    if (error.response != null) {
      final response = error.response!;
      print('📊 Status: ${response.statusCode} ${response.statusMessage ?? ''}');

      if (response.data != null) {
        print('📦 Error Response:');
        try {
          if (response.data is Map || response.data is List) {
            print('   ${_formatJson(response.data)}');
          } else {
            print('   ${response.data}');
          }
        } catch (e) {
          print('   ${response.data}');
        }
      }
    }

    if (_envConfig.isDebug && error.stackTrace != null) {
      print('🔍 Stack Trace:');
      print('   ${error.stackTrace.toString().split('\n').take(10).join('\n   ')}');
    }

    print('=' * 80 + '\n');
  }

  /// 格式化JSON数据
  String _formatJson(dynamic data) {
    try {
      final encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  /// 隐藏敏感数据
  String _maskSensitiveData(String data) {
    if (data.length <= 8) {
      return '*' * data.length;
    }
    return '${data.substring(0, 4)}${'*' * (data.length - 8)}${data.substring(data.length - 4)}';
  }
}
