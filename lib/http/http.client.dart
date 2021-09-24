import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Sec;

class HttpClient {
  static Dio _dio;
  static Sec.FlutterSecureStorage _secureStorage;
  static String _token;
  static String _ping;

  static init() async {
    _dio = Dio();
    _secureStorage = Sec.FlutterSecureStorage();
    _token = await _secureStorage.read(key: 'token') ?? null;
    _ping = await _secureStorage.read(key: 'ping') ?? null;
  }

  static Future<Dio> http() async {
    if (_token == null) {
      await init();
    }

    if (_token != null) {
      _dio.interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers["Authorization"] = "Bearer " + _token;
        options.headers["User-Agent"] = "Mobile App";
        options.headers["Accept"] = "application/json";
        return handler.next(options);
      }));
    } else if (_ping != null) {
      _dio.interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers["Authorization"] = "Bearer " + _ping;
        options.headers["User-Agent"] = "Mobile App";
        options.headers["Accept"] = "application/json";
        return handler.next(options);
      }));
    } else {
      _dio.interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers["User-Agent"] = "Mobile App";
        options.headers["Accept"] = "application/json";
        return handler.next(options);
      }));
    }

    // _dio.interceptors.add(InterceptorsWrapper(onResponse: (Response response, ResponseInterceptorHandler handler) async {
    //   if (response.headers['authorization'] != null) {
    //     _token = response.headers['authorization'].toString().substring(8, response.headers['authorization'].toString().length - 1);
    //     print('New Token: ${_token.substring(0,10)}');
    //     await setToken(_token);
    //   }
    //   return handler.next(response);
    // }));

    return _dio;
  }

  static Future<String> getToken() async {
    if (_token == null) {
      await init();
    }

    return _token;
  }

  static Future<void> setToken(String token) async {
    await init();
    await _secureStorage.write(key: 'token', value: token);
  }

  static Future<void> removeToken() async {
    if (_token == null) {
      await init();
    }

    await _secureStorage.delete(key: 'token');
  }
}