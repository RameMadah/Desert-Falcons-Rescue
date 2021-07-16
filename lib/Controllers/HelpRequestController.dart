import 'dart:async';
import 'dart:convert';

import 'package:desert_falcon_rescue/APIManager/APIManager.dart';
import 'package:desert_falcon_rescue/APIManager/HelpRequestFetchAPIManager.dart';
import 'package:desert_falcon_rescue/APIManager/CheckoutRequestAPIManager.dart';
import 'package:desert_falcon_rescue/Managers/UserSessionManager.dart';
import 'package:desert_falcon_rescue/Models/AppErrors.dart';
import 'package:desert_falcon_rescue/Models/HelpRequestFetchModel.dart';
import 'package:desert_falcon_rescue/Views/Utils/HelperFunctions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

enum HelpRequestStates { NoData, Fetching, Fetched }
enum CheckoutRequestStates { Uninitalized, InProcess, Completed, Error }

class HelpRequestController extends ChangeNotifier {
  final StreamController<HelpRequestStates> streamController =
      StreamController();

  final List<HelpRequestFetchModel> helpRequestsList = [];

  CheckoutRequestStates checkoutRequestStates =
      CheckoutRequestStates.Uninitalized;

  fetchHelpRequest(String? phoneNumber) async {
    helpRequestsList.clear();
    streamController.add(HelpRequestStates.Fetching);
    Tuple2<APIResult, dynamic> response =
        await APIManager().fetchHelpRequest(phoneNumber);
    if (response.item1 == APIResult.Failiure) {
      DioError error = response.item2 as DioError;
      AppError appError =
          AppError.fromJson(jsonDecode(error.response.toString()));
      Helper.showSnackbar(appError.message?[0].messages?[0].message ??
          'some-error-occured'.tr());
      streamController.addError(appError);
    } else {
      for (var item in response.item2) {
        HelpRequestFetchModel model = HelpRequestFetchModel.fromJson(item);
        helpRequestsList.add(model);
      }
      if (helpRequestsList.isEmpty) {
        streamController.add(HelpRequestStates.NoData);
      } else {
        streamController.add(HelpRequestStates.Fetched);
      }
    }
  }

  checkoutRequest(int requestID, bool isRescuer) async {
    checkoutRequestStates = CheckoutRequestStates.InProcess;
    notifyListeners();
    Tuple2<APIResult, dynamic> response = await APIManager().checkoutRequest(
        requestID, isRescuer ? UserSessionManager().user!.user!.id! : null);
    if (response.item1 == APIResult.Failiure) {
      DioError error = response.item2 as DioError;
      AppError appError =
          AppError.fromJson(jsonDecode(error.response.toString()));
      Helper.showSnackbar(appError.message?[0].messages?[0].message ??
          'some-error-occured'.tr());
      checkoutRequestStates = CheckoutRequestStates.Error;
    } else {
      Helper.showSnackbar(
          isRescuer ? 'request-checked-out'.tr() : "You have been helped");
      checkoutRequestStates = CheckoutRequestStates.Completed;
    }
    notifyListeners();
  }
}
