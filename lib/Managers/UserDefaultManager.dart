import 'dart:convert';

import 'package:desert_falcon_rescue/Models/AppUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDefaultManager {
  UserDefaultManager._internal();

  static final UserDefaultManager _self = UserDefaultManager._internal();

  factory UserDefaultManager() => _self;

  String _userKey = "User";

  saveUser(AppUser user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_userKey);
  }

  Future<AppUser?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString(_userKey);
    if (userString == null) return null;
    AppUser user = AppUser.fromJson(jsonDecode(userString));
    return user;
  }
}
