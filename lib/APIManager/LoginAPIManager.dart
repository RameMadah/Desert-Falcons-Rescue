import 'dart:developer';

import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:tuple/tuple.dart';

extension LoginAPIManager on APIManager {
  Future<Tuple2<APIResult, dynamic>> login(
      String username, String password) async {
    Map<String, dynamic> loginData = {
      "identifier": username,
      "password": password
    };
    Tuple2<APIResult, dynamic> response =
        await post(EndPoints.login, loginData);
    return response;
  }
}
