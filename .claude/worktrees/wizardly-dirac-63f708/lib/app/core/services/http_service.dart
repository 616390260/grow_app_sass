import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:do_task_project/app/core/services/auth_service.dart';
import 'package:do_task_project/app/data/services/auth_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as getx;
import '../config/environment_config.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/app_constants.dart';
import '../utils/json_convert.dart';
import '../i18n/i18n_keys.dart';
import 'error_handler_center.dart';

/// HTTP服务类 - 重构后的统一版本
class HttpService extends getx.GetxService {
  static HttpService get to => getx.Get.find();

  late Dio _dio;
  bool _isRefreshing = false;
  final List<RequestOptions> _pending401Queue = [];
  final Connectivity _connectivity = Connectivity();
  final EnvironmentConfig _envConfig = EnvironmentConfig.instance;
  final ErrorHandlerCenter _errorHandler = ErrorHandlerCenter();

  /// 基础URL
  String get baseUrl => _envConfig.baseUrl;

  /// 连接超时时间（毫秒）
  int get connectTimeout => _envConfig.connectTimeout;

  /// 接收超时时间（毫秒）
  int get receiveTimeout => _envConfig.receiveTimeout;

  int get sendTimeout => _envConfig.sendTimeout;

  /// 是否启用日志
  bool get enableLogging => _envConfig.enableLogging;

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
        sendTimeout: Duration(milliseconds: sendTimeout),
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
              error: I18nKeys.errorNetworkUnavailable.tr,
              type: DioExceptionType.connectionError,
            ),
          );
          return;
        }

        // 添加app-type请求头：Web平台传2，Android/iOS平台传1
        final appType = kIsWeb ? '2' : '1';
        options.headers['app-type'] = appType;
        try {
          final box = GetStorage();
          final appVersion = box.read<String>(
            AppConstants.storageKeyAppVersion,
          );
          if (appVersion != null && appVersion.isNotEmpty) {
            options.headers['App-Version'] = appVersion;
          }
        } catch (_) {}

        // 注入token到请求头
        try {
          final token = AuthService.to.token;
          if (token != null && token.isNotEmpty) {
            options.headers['APP-TOKEN'] = token;
            if (_envConfig.enableLogging) {
              debugPrint('添加Authorization头: ${_maskSensitiveData(token)}');
            }
          }
        } catch (_) {
          // 读取存储失败时忽略，不影响正常请求
        }

        // 添加语言信息到请求头
        final currentLocale = getx.Get.locale;
        if (currentLocale != null) {
          options.headers['accept-language'] =
              '${currentLocale.languageCode}_${currentLocale.countryCode ?? ''}';
        }

        _logRequest(options);
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logResponse(response);
        handler.next(response);
      },
      onError: (error, handler) async {
        _logError(error);
        if (_envConfig.enableLogging) {
          debugPrint('=== HttpService拦截器.onError 开始 ===');
          debugPrint('Dio错误: $error');
          debugPrint('状态码: ${error.response?.statusCode}');
          debugPrint('响应数据: ${error.response?.data}');
        }

        final status = error.response?.statusCode;
        if (status == 401) {
          final handled = await _handleUnauthorized(error);
          if (handled != null) {
            if (_envConfig.enableLogging) {
              debugPrint('处理401错误成功');
            }
            handler.resolve(handled);
            return;
          }
        }
        // 处理其他错误，提取业务错误码
        if (error.response != null) {
          final response = error.response;
          final data = response?.data;
          if (_envConfig.enableLogging) {
            debugPrint('开始处理业务错误');
          }
          if (data is Map<String, dynamic>) {
            final businessCode = data['code'] as int?;
            final message =
                data['msg'] as String? ??
                data['message'] as String? ??
                I18nKeys.networkRequestFailed.tr;
            if (_envConfig.enableLogging) {
              debugPrint('业务码: $businessCode, 消息: $message');
              if (businessCode != null && businessCode != 200) {
                debugPrint('抛出业务错误异常');
              }
            }
            if (businessCode != null && businessCode != 200) {
              throw _errorHandler.handleErrorCodeException(
                businessCode,
                message,
                showNotification: false,
              );
            }
          }
        }
        if (_envConfig.enableLogging) {
          debugPrint('=== HttpService拦截器.onError 结束 ===');
        }
        handler.next(error);
      },
    );
  }

  /// 创建重试拦截器
  Interceptor _createRetryInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        final req = error.requestOptions;
        if (_shouldRetry(error) && req.method.toUpperCase() == 'GET') {
          final attempt = (req.extra['retry_attempt'] as int?) ?? 0;
          final nextAttempt = attempt + 1;
          final max = _envConfig.maxRetryCount;
          if (nextAttempt <= max) {
            final delayMs = 300 * (1 << attempt);
            await Future.delayed(Duration(milliseconds: delayMs));
            req.extra['retry_attempt'] = nextAttempt;
            try {
              final response = await _dio.fetch(req);
              handler.resolve(response);
              return;
            } catch (e) {
              // fallthrough
            }
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

  /// GET请求
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponseData<T>(response);
    } on DioException catch (e) {
      throw _errorHandler.handleExceptionException(e, showNotification: false);
    } catch (e) {
      throw _errorHandler.handleExceptionException(
        Exception(e.toString()),
        showNotification: false,
      );
    }
  }

  /// POST请求 - 直接返回泛型对象
  Future<T> postData<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponseData<T>(response);
    } on DioException catch (e) {
      final exception = _errorHandler.handleExceptionException(
        e,
        showNotification: false,
      );
      if (enableLogging) {
        debugPrint(exception.message);
      }
      throw exception;
    } catch (e) {
      final exception = _errorHandler.handleExceptionException(
        Exception(e.toString()),
        showNotification: false,
      );
      if (enableLogging) {
        debugPrint(exception.message);
      }
      throw exception;
    }
  }

  /// PUT请求 - 直接返回泛型对象
  Future<T> putData<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponseData<T>(response);
    } on DioException catch (e) {
      throw _errorHandler.handleExceptionException(e, showNotification: false);
    } catch (e) {
      throw _errorHandler.handleExceptionException(
        Exception(e.toString()),
        showNotification: false,
      );
    }
  }

  /// DELETE请求 - 直接返回泛型对象
  Future<T> deleteData<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponseData<T>(response);
    } on DioException catch (e) {
      throw _errorHandler.handleExceptionException(e, showNotification: true);
    } catch (e) {
      throw _errorHandler.handleExceptionException(
        Exception(e.toString()),
        showNotification: true,
      );
    }
  }

  /// 处理响应 - 使用JsonConvert进行类型转换
  /// 增强对json_serializable注解的模型类的支持
  T _handleResponseData<T>(Response response) {
    debugPrint('=== HttpService._handleResponseData 开始 ===');
    debugPrint('HTTP状态码: ${response.statusCode}');
    debugPrint('响应数据: ${response.data}');

    final responseData = response.data;

    // 检查响应体中的业务code（处理标准API响应格式）
    if (responseData is Map<String, dynamic>) {
      final code = responseData['code'] as int?;
      final message =
          responseData['msg'] as String? ??
          responseData['message'] as String? ??
          '请求成功';

      if (code == 200) {
        // 业务逻辑成功，从响应中提取data字段
        final businessData = responseData['data'];

        // 如果直接请求的是bool类型，并且data字段是bool，直接返回
        if (T == bool && businessData is bool) {
          return businessData as T;
        }

        return _convertDataToType<T>(businessData ?? responseData);
      } else {
        // 业务逻辑失败，统一抛出ApiException，确保错误能够被上层捕获处理
        debugPrint('业务逻辑失败，抛出异常: code=$code, message=$message');
        throw _errorHandler.handleErrorCodeException(
          code,
          message,
          showNotification: true,
        );
      }
    }

    // 检查HTTP状态码（非标准响应格式时）
    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint('HTTP状态码异常，抛出HTTP请求失败异常');
      throw _errorHandler.handleErrorCode<T>(
        response.statusCode,
        I18nKeys.networkRequestFailed.tr,
      );
    }

    // 非标准API响应格式（非Map），直接进行类型转换
    return _convertDataToType<T>(responseData);
  }

  /// 通用数据类型转换方法
  /// 将任意类型数据转换为指定的泛型类型
  T _convertDataToType<T>(dynamic data) {
    try {
      // 1. 优先尝试使用JsonConvert进行转换
      final result = JsonConvert.fromJsonAsT<T>(data);
      if (enableLogging) {
        print(result);
      }
      if (result != null) {
        return result;
      }

      // 2. 针对Map类型数据的特殊处理（支持json_serializable）
      if (data is Map<String, dynamic>) {
        try {
          // 对于需要自定义转换的类型，直接返回Map供调用方处理
          return data as T;
        } catch (_) {
          // 继续尝试其他方式
        }
      }

      // 3. 处理基本类型转换
      if (T == String) {
        return data.toString() as T;
      } else if (T == int && data is num) {
        return data.toInt() as T;
      } else if (T == double && data is num) {
        return data.toDouble() as T;
      } else if (T == bool) {
        if (enableLogging) {
          debugPrint('处理bool类型: $data, 类型: ${data.runtimeType}');
        }
        if (data is bool) {
          // 直接返回bool类型数据
          return data as T;
        } else if (data is num) {
          // 数字转换为bool
          return (data != 0) as T;
        } else if (data is String) {
          // 字符串转换为bool
          final lowerData = data.toLowerCase();
          return (lowerData == 'true' ||
                  lowerData == '1' ||
                  lowerData == 'yes' ||
                  lowerData == 'on')
              as T;
        }
        // 如果以上都不匹配，尝试toString后再判断
        final stringValue = data?.toString()?.toLowerCase();
        if (stringValue != null) {
          return (stringValue == 'true' ||
                  stringValue == '1' ||
                  stringValue == 'yes' ||
                  stringValue == 'on')
              as T;
        }
        // 默认返回false
        return false as T;
      }

      // 4. 尝试直接类型转换作为最后手段
      try {
        return data as T;
      } catch (e) {
        throw Exception('类型转换失败: 无法将响应数据转换为类型 $T: $e');
      }
    } catch (e) {
      final errorMsg = e is Exception
          ? e.toString()
          : I18nKeys.unknownTypeConversionException.tr;
      throw Exception('类型转换异常: $errorMsg');
    }
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

    debugPrint('\n' + '=' * 80);
    debugPrint(
      '🚀 HTTP REQUEST [${options.method.toUpperCase()}] - $timestamp',
    );
    debugPrint('=' * 80);
    debugPrint('📍 URL: $fullUrl');

    if (options.queryParameters.isNotEmpty) {
      debugPrint('🔍 Query Parameters:');
      options.queryParameters.forEach((key, value) {
        debugPrint('   $key: $value');
      });
    }

    debugPrint('📋 Headers:');
    options.headers.forEach((key, value) {
      if (key.toLowerCase().contains('authorization') ||
          key.toLowerCase().contains('token')) {
        debugPrint('   $key: ${_maskSensitiveData(value.toString())}');
      } else {
        debugPrint('   $key: $value');
      }
    });

    if (options.data != null) {
      debugPrint('📦 Request Body:');
      try {
        if (options.data is Map || options.data is List) {
          debugPrint('   ${_formatJson(options.data)}');
        } else {
          debugPrint('   ${options.data}');
        }
      } catch (e) {
        debugPrint('   ${options.data}');
      }
    }

    debugPrint(
      '⏱️  Timeout: Connect(${options.connectTimeout?.inMilliseconds}ms) | Receive(${options.receiveTimeout?.inMilliseconds}ms) | Send(${options.sendTimeout?.inMilliseconds}ms)',
    );
    debugPrint('=' * 80 + '\n');
  }

  /// 打印响应信息
  void _logResponse(Response response) {
    if (!enableLogging) return;

    final timestamp = DateTime.now().toIso8601String();
    final requestOptions = response.requestOptions;
    final fullUrl = '${requestOptions.baseUrl}${requestOptions.path}';

    debugPrint('\n' + '=' * 80);
    debugPrint('✅ HTTP RESPONSE [${response.statusCode}] - $timestamp');
    debugPrint('=' * 80);
    debugPrint('📍 URL: $fullUrl');
    debugPrint('🔄 Method: ${requestOptions.method.toUpperCase()}');
    debugPrint(
      '📊 Status: ${response.statusCode} ${response.statusMessage ?? ''}',
    );

    debugPrint('📦 Response Data:');
    try {
      if (response.data is Map || response.data is List) {
        final jsonStr = _formatJson(response.data);
        debugPrint('   $jsonStr');
      } else {
        final dataStr = response.data.toString();
        debugPrint('   $dataStr');
      }
    } catch (e) {
      debugPrint('   ${response.data}');
    }

    debugPrint(
      '📏 Content Length: ${response.data.toString().length} characters',
    );
    debugPrint('=' * 80 + '\n');
  }

  /// 打印错误信息
  void _logError(DioException error) {
    if (!enableLogging) return;

    final timestamp = DateTime.now().toIso8601String();
    final requestOptions = error.requestOptions;
    final fullUrl = '${requestOptions.baseUrl}${requestOptions.path}';

    debugPrint('\n' + '=' * 80);
    debugPrint(
      '❌ HTTP ERROR [${error.response?.statusCode ?? 'UNKNOWN'}] - $timestamp',
    );
    debugPrint('=' * 80);
    debugPrint('📍 URL: $fullUrl');
    debugPrint('🔄 Method: ${requestOptions.method.toUpperCase()}');
    debugPrint('🚨 Error Type: ${error.type}');
    debugPrint('💬 Error Message: ${error.message ?? 'Unknown error'}');

    if (error.response != null) {
      final response = error.response!;
      debugPrint(
        '📊 Status: ${response.statusCode} ${response.statusMessage ?? ''}',
      );

      if (response.data != null) {
        debugPrint('📦 Error Response:');
        try {
          if (response.data is Map || response.data is List) {
            debugPrint('   ${_formatJson(response.data)}');
          } else {
            debugPrint('   ${response.data}');
          }
        } catch (e) {
          debugPrint('   ${response.data}');
        }
      }
    }

    if (_envConfig.isDebug && error.stackTrace != null) {
      debugPrint('🔍 Stack Trace:');
      debugPrint(
        '   ${error.stackTrace.toString().split('\n').take(10).join('\n   ')}',
      );
    }

    debugPrint('=' * 80 + '\n');
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

  Future<Response?> _handleUnauthorized(DioException error) async {
    final request = error.requestOptions;
    final rememberEnabled = AuthService.to.isRememberPasswordEnabled();
    if (!rememberEnabled) {
      return null;
    }

    _pending401Queue.add(request);

    if (_isRefreshing) {
      return null;
    }

    _isRefreshing = true;
    try {
      final account = AuthService.to.getSavedAccount();
      final password = AuthService.to.getSavedPassword();
      if (account == null ||
          password == null ||
          account.isEmpty ||
          password.isEmpty) {
        return null;
      }

      final newToken = await AuthApiService().login(
        account: account,
        password: password,
      );
      if (newToken.isNotEmpty) {
        await AuthService.to.saveToken(newToken);

        Response? lastResponse;
        for (final pending in List<RequestOptions>.from(_pending401Queue)) {
          pending.headers['APP-TOKEN'] = newToken;
          try {
            final resp = await _dio.fetch(pending);
            lastResponse = resp;
          } catch (_) {}
          _pending401Queue.remove(pending);
        }
        return lastResponse;
      }
    } catch (_) {
      // ignore
    } finally {
      _isRefreshing = false;
      _pending401Queue.clear();
    }
    return null;
  }

  /// 隐藏敏感数据
  String _maskSensitiveData(String data) {
    if (data.length <= 8) {
      return '*' * data.length;
    }
    return '${data.substring(0, 4)}${'*' * (data.length - 8)}${data.substring(data.length - 4)}';
  }
}
