export 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:tuple/tuple.dart';

extension Logout on APIManager {
  Future<Tuple2<APIResult, dynamic>> logout(String deviceID) async {
    Tuple2<APIResult, dynamic> response =
        await deleteRequest(EndPoints.removeToken(deviceID));
    return response;
  }
}
