import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:tuple/tuple.dart';

extension SaveTokenAPIManager on APIManager {
  saveToken(
      String userID, String token, String deviceID, String platform) async {
    Tuple2<APIResult, dynamic> response = await post(EndPoints.saveToken, {
      "user_id": userID,
      "token": token,
      "type": platform,
      "device_id": deviceID
    });
    return response;
  }
}
