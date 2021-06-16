import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';

enum APIResult { Success, Failiure }

class APIManager {
  // Self Instace
  static final _selfInstance = APIManager._internal();

  // Initializers
  APIManager._internal();
  factory APIManager() => _selfInstance;

  // Private Properties
  Dio _dio = Dio();

  // Public Methods
  Future<Tuple2<APIResult, dynamic>> post(
      String url, Map<String, dynamic> data) async {
    Tuple2<APIResult, dynamic> result;
    try {
      Response response = await Dio().post(url,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(data));
      result = Tuple2<APIResult, dynamic>(APIResult.Success, response.data);
    } on DioError catch (e) {
      result = Tuple2<APIResult, dynamic>(APIResult.Failiure, e);
    }
    return result;
  }
}
