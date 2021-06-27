import 'dart:convert';
import 'dart:developer';

import 'package:desert_falcon_rescue/APIManager/LoginAPIManager.dart';
import 'package:desert_falcon_rescue/Managers/UserSessionManager.dart';
import 'package:desert_falcon_rescue/Models/AppErrors.dart';
import 'package:desert_falcon_rescue/Models/AppUser.dart';
import 'package:desert_falcon_rescue/Views/Utils/HelperFunctions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';

enum LoginStatus { Uninitialized, InProgress, Success, Error }

class LoginController extends ChangeNotifier {
  // Self Instace
  static final _selfInstance = LoginController._internal();

  // Initializers
  LoginController._internal();
  factory LoginController() => _selfInstance;

  // Private Properties
  LoginStatus _loginStatus = LoginStatus.Uninitialized;

  // Access Modifiers
  LoginStatus get loginStatus => _loginStatus;

  // Public Methods
  login(String username, String password) async {
    _loginStatus = LoginStatus.InProgress;
    notifyListeners();
    Tuple2<APIResult, dynamic> response =
        await APIManager().login(username, password);
    if (response.item1 == APIResult.Failiure) {
      DioError error = response.item2 as DioError;
      AppError appError =
          AppError.fromJson(jsonDecode(error.response.toString()));
      Helper.showSnackbar(appError.message?[0].messages?[0].message ??
          'some-error-occured'.tr());
      _loginStatus = LoginStatus.Error;
    } else {
      AppUser user = AppUser.fromJson(response.item2);
      UserSessionManager().user = user;
      Helper.showSnackbar(
          "Succesfully Logged IN"); //TODO This may get removed when we go to next screen in next phase/sprint
      _loginStatus = LoginStatus.Success;
    }
    notifyListeners();
  }
}
