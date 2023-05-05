import 'package:attenda/core/strings.dart';
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://attenda.coderyk.me',
        connectTimeout: const Duration(seconds: 80),
        receiveTimeout: const Duration(seconds: 80),
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':'Bearer $token',
          'app_key':'API_PASS',
          'Accept':'application/json',
        }
      ),
    );
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String,dynamic>? data,
  }) async{
    dio.options.headers= {
      'Content-Type': 'application/json',
      'Authorization':'Bearer $token',
      'app_key':'API_PASS',
      'Accept':'application/json',
    };
    return await dio.get(path, queryParameters: queryParameters,data: data,);
  }

  static Future<Response> postData({
    required String path,
    required Map<String,dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    dio.options.headers= {
    'Content-Type': 'application/json',
    'Authorization':'Bearer $token',
    'app_key':'API_PASS',
    'Accept':'application/json',
    };
    return await dio.post(path, queryParameters: queryParameters, data: data);
  }

  static Future<Response> putData({
    required String path,
     Map<String,dynamic>? data,
    Map<String, dynamic>? parameters,

  }) async {
    dio.options.headers= {
      'Content-Type': 'application/json',
      'Authorization':'Bearer $token',
      'app_key':'API_PASS',
      'Accept':'application/json',
    };
    return await dio.put(path, queryParameters: parameters, data: data);
  }

  static Future<Response> deleteData({
    required String path,
     Map<String, dynamic>? parameters,
     Map<String,dynamic>? data,
  }) async {
    dio.options.headers= {
      'Content-Type': 'application/json',
      'Authorization':'Bearer $token',
      'app_key':'API_PASS',
      'Accept':'application/json',
    };
    return await dio.delete(path, queryParameters: parameters, data: data);
  }
}
