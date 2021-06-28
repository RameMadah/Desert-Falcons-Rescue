import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:desert_falcon_rescue/APIManager/HelpApplicationAPIManager.dart';
import 'package:desert_falcon_rescue/APIManager/RescuerRegisterationAPIManager.dart';
import 'package:desert_falcon_rescue/Globals/Endpoints.dart';
import 'package:desert_falcon_rescue/Managers/UserSessionManager.dart';
import 'package:desert_falcon_rescue/Models/AppErrors.dart';
import 'package:desert_falcon_rescue/Models/AppUser.dart';
import 'package:desert_falcon_rescue/Models/HelpRequestModel.dart';
import 'package:desert_falcon_rescue/Views/Utils/HelperFunctions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

enum HelpApplicationStatus { Uninitialized, InProgress, Success, Error }

class ApplicationController extends ChangeNotifier {
  // Self Instace
  static final _selfInstance = ApplicationController._internal();

  // Initializers
  ApplicationController._internal();
  factory ApplicationController() => _selfInstance;

  // Private Properties
  HelpApplicationStatus _helpApplicationStatus =
      HelpApplicationStatus.Uninitialized;

  // Access Modifiers
  HelpApplicationStatus get registerationStatus => _helpApplicationStatus;

  // Public Methods
  helpRequestWithModelAndUploadImages(
      HelpRequestModel _helpRequestModel, List<File> images) async {
    _helpApplicationStatus = HelpApplicationStatus.InProgress;
    notifyListeners();
    Tuple2<APIResult, dynamic> response =
        await APIManager().helpApplication(_helpRequestModel);

    if (response.item1 == APIResult.Failiure) {
      Helper.showSnackbar('some-error-occured'.tr());
      _helpApplicationStatus = HelpApplicationStatus.Error;
    } else {
      int id = response.item2["id"];
      await uploadImages(images, id.toString());
      Helper.showSnackbar(
          "Succesfully registered the help"); //TODO This may get removed when we go to next screen in next phase/sprint
      _helpApplicationStatus = HelpApplicationStatus.Success;
    }
    notifyListeners();
  }

  uploadImages(List<File> images, String userID) async {
    await APIManager().postAttachment(
        EndPoints.uploadAttachments, images, userID,
        field: "IncidentAttachment");
  }
}
