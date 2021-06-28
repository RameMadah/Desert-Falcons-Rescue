import 'dart:convert';
import 'dart:io';

import 'package:desert_falcon_rescue/APIManager/RescuerRegisterationAPIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:desert_falcon_rescue/Managers/UserSessionManager.dart';
import 'package:desert_falcon_rescue/Models/AppErrors.dart';
import 'package:desert_falcon_rescue/Models/AppUser.dart';
import 'package:desert_falcon_rescue/Models/RescuerRegisterationModel.dart';
import 'package:desert_falcon_rescue/Views/Utils/HelperFunctions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

enum RescuerRegisterationStatus { Uninitialized, InProgress, Success, Error }

class RescuerRegisterationController extends ChangeNotifier {
  // Self Instace
  static final _selfInstance = RescuerRegisterationController._internal();

  // Initializers
  RescuerRegisterationController._internal();
  factory RescuerRegisterationController() => _selfInstance;

  // Private Properties
  RescuerRegisterationStatus _rescuerRegisterationStatus =
      RescuerRegisterationStatus.Uninitialized;

  // Access Modifiers
  RescuerRegisterationStatus get registerationStatus =>
      _rescuerRegisterationStatus;

  // Public Methods
  registerwithModelAndUploadAttachments(
      RescuerRegisterationModel _rescuerRegisterationModel,
      List<File> images) async {
    _rescuerRegisterationStatus = RescuerRegisterationStatus.InProgress;
    notifyListeners();
    Tuple2<APIResult, dynamic> response =
        await APIManager().rescuerRegister(_rescuerRegisterationModel);
    if (response.item1 == APIResult.Failiure) {
      DioError error = response.item2 as DioError;
      AppError appError =
          AppError.fromJson(jsonDecode(error.response.toString()));
      Helper.showSnackbar(appError.message?[0].messages?[0].message ??
          'some-error-occured'.tr());
      _rescuerRegisterationStatus = RescuerRegisterationStatus.Error;
    } else {
      AppUser user = AppUser.fromJson(response.item2);
      UserSessionManager().user = user;
      if (user.user != null && user.user?.id != null) {
        await uploadImages(images, user.user!.id.toString());
      }
      Helper.showSnackbar(
          "Succesfully REGISTERED"); //TODO This may get removed when we go to next screen in next phase/sprint
      _rescuerRegisterationStatus = RescuerRegisterationStatus.Success;
    }
    notifyListeners();
  }

  uploadImages(List<File> images, String userID) async {
    await APIManager()
        .postAttachment(EndPoints.uploadAttachments, images, userID);
  }
}
