export 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:tuple/tuple.dart';

extension AreasAPIManager on APIManager {
  Future<Tuple2<APIResult, dynamic>> fetchAreas() async {
    Tuple2<APIResult, dynamic> response =
        await getRequest(EndPoints.areasRequest);
    return response;
  }
}
