import 'package:desert_falcon_rescue/Models/AppUser.dart';

class UserSessionManager {
  // Self Instace
  static final _selfInstance = UserSessionManager._internal();

  // Initializers
  UserSessionManager._internal();
  factory UserSessionManager() => _selfInstance;

  // Private properties
  AppUser? _user;

  // Access Modifiers
  bool get isLoggedIn => _user != null;

  AppUser? get user => _user;

  set user(AppUser? user) {
    this._user = user;
  }
}
