export 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:tuple/tuple.dart';

extension HelpRequestFetch on APIManager {
  Future<Tuple2<APIResult, dynamic>> fetchHelpRequest(
      String? phoneNumber) async {
    Tuple2<APIResult, dynamic> response =
        await getRequest(EndPoints.helpRequests(phoneNumber));
    return response;
  }
}
