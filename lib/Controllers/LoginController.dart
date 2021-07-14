import 'dart:convert';

import 'package:desert_falcon_rescue/APIManager/LoginAPIManager.dart';
import 'package:desert_falcon_rescue/APIManager/SaveTokenAPIManager.dart';
import 'package:desert_falcon_rescue/Managers/UserDefaultManager.dart';
import 'package:desert_falcon_rescue/Managers/UserSessionManager.dart';
import 'package:desert_falcon_rescue/Models/AppErrors.dart';
import 'package:desert_falcon_rescue/Models/AppUser.dart';
import 'package:desert_falcon_rescue/Views/Utils/HelperFunctions.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:platform_device_id/platform_device_id.dart';

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
      bool tokenSaved = await saveToken(user.user!.id.toString());
      if (!tokenSaved) {
        _loginStatus = LoginStatus.Error;
        Helper.showSnackbar('some-error-occured'.tr());
        notifyListeners();
        return;
      }
      UserSessionManager().user = user;
      UserDefaultManager().saveUser(user);
      _loginStatus = LoginStatus.Success;
    }
    notifyListeners();
  }

  Future<bool> saveToken(String userID) async {
    FirebaseMessaging firebaseInstane = FirebaseMessaging.instance;
    String? token = await firebaseInstane.getToken();
    String? deviceID = await PlatformDeviceId.getDeviceId;
    String device = Helper.platform();
    if (token == null || deviceID == null) return false;
    Tuple2<APIResult, dynamic> response =
        await APIManager().saveToken(userID, token, deviceID, device);
    if (response.item1 == APIResult.Failiure) {
      return false;
    } else {
      return true;
    }
  }
}
