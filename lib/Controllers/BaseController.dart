import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class BaseController {
  String? parseDioError(DioError e) {
    if (e.response?.statusCode == 400) {
      return "invalid-credentials".tr();
    }
    return null;
  }
}
