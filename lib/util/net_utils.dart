import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:async';

Dio dio = new Dio();

class NetUtils {
  static Future get(String url, { Map<String, dynamic> params }) async {
    var res = await dio.get(url, queryParameters: params);
    return res.data;
  }

  static Future post(String url, Map<String, dynamic> params) async {
    var res = await dio.post(url,data: params);
    return res.data;
  }

  static Future fromDataUpload (
    String url, Map<String, dynamic> params
  ) async {
    FormData formData = FormData.fromMap(params);
    var res = await dio.post(url, data: formData);
    return res;
  }
}
