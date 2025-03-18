import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:lib_utils/lib_utils.dart';

export 'lib_net.dart';

Duration _connectTimeout = const Duration(seconds: 10);
Duration _receiveTimeout = const Duration(seconds: 10);
Duration _sendTimeout = const Duration(seconds: 10);
Map<String, dynamic> _httpHeader = const {
  'Accept': 'application/json, text/plain, */*',
  'Accept-Encoding': 'gzip, deflate, br',
  'Accept-Language': 'zh-CN,zh;q=0.9',
  'Connection': 'keep-alive',
  'Content-Type': 'application/json',
  'User-Agent':
      'Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A372 Safari/604.1',
};

String _baseUrl = "";

void configDio({
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
  String? baseUrl,
  Map<String, dynamic>? header,
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _httpHeader = header ?? _httpHeader;

  HttpGo.instance.updateConfig();
}

class HttpGo {
  late Dio _dio;

  HttpGo._() {
    _initBase();
  }

  static final HttpGo _singletion = HttpGo._();
  static HttpGo get instance => _singletion;

  void _initBase() {
    _dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        baseUrl: _baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
        headers: _httpHeader,
      ),
    );

    // 缓存配置
    final options = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      hitCacheOnErrorExcept: [401, 403],
      maxStale: const Duration(days: 7),
      priority: CachePriority.normal,
      cipher: null,
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      allowPostMethod: false,
    );
    _dio.interceptors.add(DioCacheInterceptor(options: options));
  }

  void updateConfig() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = _connectTimeout;
    _dio.options.receiveTimeout = _receiveTimeout;
    _dio.options.sendTimeout = _sendTimeout;
    _dio.options.headers = _httpHeader;
  }

  Future<T?> request<T>(
    String url,
    String method, {
    Object? data,
    Map<String, dynamic>? queryParams,
    ProgressCallback? progressCallback,
    ProgressCallback? receiveCallback,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      Response response = await _dio.request(
        url,
        data: data,
        queryParameters: queryParams,
        onSendProgress: progressCallback,
        onReceiveProgress: receiveCallback,
      );
      if (response.statusCode == 200) {
        return fromJson(response.data);
      } else {
        LogUtils.e("请求失败： ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  void _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        showError('链接超时');
        break;
      case DioExceptionType.sendTimeout:
        showError('发送超时');
        break;
      case DioExceptionType.receiveTimeout:
        showError('接收超时');
        break;
      case DioExceptionType.badResponse:
        showError('服务器错误 ${e.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        showError('请求取消');
        break;
      default:
        showError('网络错误: ${e.message}');
        break;
    }
  }

  Future<T?> get<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParams,
    ProgressCallback? progressCallback,
    ProgressCallback? receiveCallback,
    required T Function(dynamic json) fromJson,
  }) async {
    return request(
      url,
      'GET',
      data: data,
      queryParams: queryParams,
      progressCallback: progressCallback,
      receiveCallback: receiveCallback,
      fromJson: fromJson,
    );
  }
}
