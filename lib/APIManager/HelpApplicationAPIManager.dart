import 'dart:developer';

import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
export 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:desert_falcon_rescue/Models/HelpRequestModel.dart';
import 'package:desert_falcon_rescue/Models/RescuerRegisterationModel.dart';
import 'package:tuple/tuple.dart';

extension HelpApplicationAPIManager on APIManager {
  Future<Tuple2<APIResult, dynamic>> helpApplication(
      HelpRequestModel model) async {
    Tuple2<APIResult, dynamic> response =
        await post(EndPoints.helpRequest, model.toJson());
    return response;
  }
}
