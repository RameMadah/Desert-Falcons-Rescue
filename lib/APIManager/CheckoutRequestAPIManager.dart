import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:desert_falcon_rescue/Models/RescuerRegisterationModel.dart';
import 'package:tuple/tuple.dart';

extension CheckoutRequestAPIManager on APIManager {
  Future<Tuple2<APIResult, dynamic>> checkoutRequest(
      int requestID, int? userID) async {
    late Map<String, dynamic> _data;
    if (userID != null)
      _data = {"users_permissions_user": "$userID"};
    else
      _data = {"RequestStatus": true};
    Tuple2<APIResult, dynamic> response =
        await putRequest(EndPoints.checkoutRequest(requestID), _data);
    return response;
  }
}
