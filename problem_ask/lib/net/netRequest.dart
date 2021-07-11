import 'package:dio/dio.dart';
import 'package:problem_ask/config/config.dart';

class NetRequestor {
  static Dio _dio = Dio(
    BaseOptions(
      baseUrl: serverUrl,
    ),
  );
  static Future request(String url) async {
    try {
      Response _res = await _dio.post(url);
      return _res.data;
    } on DioError catch (e) {
      throw (e);
      //return null;
    }
  }

  static Future getImg(String url) async {
    try {
      Response _res = await _dio.post(url);
      print("???_res");
      print(_res);
      return _res;
    } on DioError catch (e) {
      throw (e);
      //return null;
    }
  }

  static Future uploadImage(String url, FormData formData) async {
    try {
      Response _res = await _dio.post(url, data: formData);
      return _res.data;
    } on DioError catch (e) {
      throw (e);
      //return null;
    }
  }
}
