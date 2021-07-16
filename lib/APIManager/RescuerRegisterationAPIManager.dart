import 'dart:developer';

import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
export 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:desert_falcon_rescue/Models/RescuerRegisterationModel.dart';
import 'package:tuple/tuple.dart';

extension RescuerRegisterationAPIManager on APIManager {
  Future<Tuple2<APIResult, dynamic>> rescuerRegister(
      RescuerRegisterationModel model) async {
    Tuple2<APIResult, dynamic> response =
        await post(EndPoints.rescuerRegister, model.toJson());
    return response;
  }
}
