import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:desert_falcon_rescue/Views/Screens/LoginPage.dart';
import 'package:desert_falcon_rescue/Views/Utils/AppRoutes.dart';
import 'package:desert_falcon_rescue/Views/Widgets/CardButton.dart';
import 'package:desert_falcon_rescue/Views/Widgets/Logo.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ApplicationScreen.dart';

class StartPage extends StatelessWidget {
  late double screenHeight;
  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    context.setLocale(Locale('en'));
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(child: _body(context)),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Logo(),
        Center(
          child: Text('stuck_in_desert',
                  style: TextStyle(
                      color: AppColors.textBlackColor,
                      fontSize: 111.sp,
                      fontWeight: FontWeight.bold))
              .tr(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            'start_page_description',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.textBlackColor,
                fontWeight: FontWeight.w300,
                fontSize: 50.sp),
          ).tr(),
        ),
        _redButton(context),
        Container(
          width: double.infinity,
          color: AppColors.borderColor,
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cardButton(
                  "assets/images/redButtonBGImage.png",
                  "assets/images/carlogo.png",
                  AppColors.whiteColor,
                  Text('about-us',
                          style: TextStyle(
                              fontSize: 45.sp, color: AppColors.textBlackColor))
                      .tr(),
                  screenHeight,
                  () {}),
              cardButton(
                  "assets/images/greenBGImage.png",
                  "assets/images/rescuerLogo.png",
                  AppColors.greenColor01,
                  Text('login-as-rescuer',
                          style: TextStyle(
                              fontSize: 45.sp, color: AppColors.whiteColor))
                      .tr(),
                  screenHeight, () {
                AppRoutes.push(context, LoginPage());
              }),
            ],
          ),
        ),
      ],
    );
  }

  _redButton(BuildContext context) {
    return InkWell(
      onTap: () {
        AppRoutes.push(context, ApplicationScreen());
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3))
                ],
              ),
              child: Image.asset("assets/images/redButtonImage.png",
                  height: screenHeight * 0.22, width: screenHeight * 0.22),
            ),
          ),
          Text(
            'help',
            style: TextStyle(
                fontSize: 111.sp,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold),
          ).tr(),
        ],
      ),
    );
  }

  Widget _rescuersOnlineWidget() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Text('rescuers-online-now-in-uae',
                        style: TextStyle(
                            fontSize: 46.sp, color: AppColors.textBlackColor))
                    .tr()),
            Container(
              width: screenWidth * 0.30,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: AppColors.greenColor),
              child: Center(
                  child: Text('142',
                      style: TextStyle(
                          fontSize: 46.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor))),
            )
          ],
        ),
      ),
    );
  }
}
