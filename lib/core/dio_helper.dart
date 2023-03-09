
import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://graph.facebook.com/v15.0/',
        connectTimeout: const Duration(seconds: 80),
        receiveTimeout: const Duration(seconds: 80),
        receiveDataWhenStatusError: true,
      ),
    );
  }

  // static Future<dynamic> getData({
  //   required String path,
  //   required Map<String, dynamic>? queryParameters,
  //   required String? token,
  // }) async{
  //   dio.options.headers = {
  //     'Content-Type': 'application/json',
  //     'lang': 'en',
  //     'Authorization': token,
  //   };
  //   return await dio.get(path, queryParameters: queryParameters);
  // }

  static Future<dynamic> postData({
    required String path,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer EAADShv1uSjgBAN8oV4F9RfKZAWZAlyTuL2irh7XacIK1WtZB5uBL8FitNmSHCRhWYVVVOV6YkTcsmZBmpBO49BbJKVlmDUehxmOcug1fl8MUbueRKLi44OtyZBhnbjkKdZC16q4TE342DpM7gu4SRxzjHceZBU8kbf8oPS7dPY97L0Ne0VvBcX7r9ZAExNmicm6iB1X2ZBdiSfbFJ7vIhXjRaOXYjNavYhxQZD',
    };
    return await dio.post(path, queryParameters: queryParameters, data: data);
  }

  // static Future<dynamic> putData({
  //   required String path,
  //   required Map<String, dynamic>? parameters,
  //   required dynamic data,
  //   required String token,
  // }) async {
  //   dio.options.headers = {
  //     'Content-Type': 'application/json',
  //     'lang': 'en',
  //     'Authorization': token,
  //   };
  //   return await dio.put(path, queryParameters: parameters, data: data);
  // }
}
