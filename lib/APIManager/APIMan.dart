class APIManager {

  APIManager._internal();

  factory APIManager() => _selfInstance;

  static final APIManager _selfInstance = APIManager._internal();



  final Dio _dio = Dio();

  Future<Response> postRequest(

      String endpoint, Map<String, dynamic>? _data) async {

    try {

      return await _dio.post(endpoint, data: _data);

    } catch (e) {

      rethrow;

    }

  }



  Future<Response> getRequest(

      String endpoint, Map<String, dynamic>? _data) async {

    try {

      return await _dio.get(endpoint);

    } catch (e) {

      rethrow;

    }

  }



  Future<Response> putRequest(

      String endpoint, Map<String, dynamic>? _data) async {

    try {

      return await _dio.put(endpoint);

    } catch (e) {

      rethrow;

    }

  }



  Future<Response> deleteRequest(

      String endpoint, Map<String, dynamic>? _data) async {

    try {

      return await _dio.delete(endpoint);

    } catch (e) {

      rethrow;

    }

  }

}
