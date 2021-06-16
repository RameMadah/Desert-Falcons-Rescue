import 'dart:developer';

import 'package:desert_falcon_rescue/Controllers/LoginController.dart';
import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:desert_falcon_rescue/Views/Utils/AppRoutes.dart';
import 'package:desert_falcon_rescue/Views/Widgets/CircularProgressIndicatorWidget.dart';
import 'package:desert_falcon_rescue/Views/Widgets/Logo.dart';
import 'package:desert_falcon_rescue/Views/Widgets/TextInputWidget.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _userName, _password;

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before,
              color: AppColors.darkGrayColor, size: 40),
          onPressed: () {
            AppRoutes.pop(context);
          },
        ),
        title: Text(
          'login',
          style: TextStyle(color: AppColors.darkGrayColor, fontSize: 60.sp),
        ).tr(),
        centerTitle: true,
        backgroundColor: AppColors.grayColor,
      ),
      body: SafeArea(
          child: ChangeNotifierProvider.value(
        value: LoginController(),
        child: Consumer<LoginController>(
            builder: (context, _loginController, child) {
          switch (_loginController.loginStatus) {
            case LoginStatus.Uninitialized:
            case LoginStatus.InProgress:
            case LoginStatus.Success:
            case LoginStatus.Error:
              return _body(context);
          }
        }),
      )),
    );
  }

  Widget _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          Logo(),
          _userNameTextField(),
          _passwordTextField(),
          _loginButton(context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Apply-for-registration-as-Rescuer',
                style: TextStyle(
                    fontSize: 50.sp,
                    color: AppColors.darkGrayColor,
                    decoration: TextDecoration.underline),
              ).tr(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userNameTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.person,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'user-name'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: false,
        controller: null,
        onSaved: (value) {
          this._userName = value;
        },
        validationText: "please-enter-username".tr(),
        textInputAction: null);
  }

  Widget _passwordTextField() {
    return TextInputWidget(
        prefix: Icon(
          Icons.lock_open_rounded,
          color: AppColors.darkGrayColor,
        ),
        labelText: '',
        hintText: 'password'.tr(),
        keyBoardType: TextInputType.text,
        obscureText: true,
        maxLines: 1,
        controller: null,
        onSaved: (value) {
          this._password = value;
        },
        validationText: "please-enter-password".tr(),
        textInputAction: null);
  }

  Widget _loginButton(BuildContext context) {
    return Provider.of<LoginController>(context).loginStatus ==
            LoginStatus.InProgress
        ? CircularProgressIndicatorWidget()
        : InkWell(
            onTap: () {
              if (_formKey.currentState == null) {
                return;
              }
              FormState currentState = _formKey.currentState!;
              if (currentState.validate()) {
                currentState.save();
                _login();
              }
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.greenColor),
              child: Center(
                  child: Text(
                'login',
                style: TextStyle(
                    fontSize: 45.sp,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold),
              ).tr()),
            ),
          );
  }

  _login() {
    LoginController().login(_userName, _password);
  }
}
