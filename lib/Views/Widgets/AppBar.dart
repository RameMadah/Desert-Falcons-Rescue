import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:desert_falcon_rescue/Views/Utils/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

CustomAppBar(BuildContext context, String title, {bool showBackButton = true}) {
  return AppBar(
    leading: showBackButton
        ? IconButton(
            icon: Icon(Icons.navigate_before,
                color: AppColors.darkGrayColor, size: 40),
            onPressed: () {
              AppRoutes.pop(context);
            },
          )
        : null,
    title: Text(
      title,
      style: TextStyle(color: AppColors.darkGrayColor, fontSize: 60.sp),
    ),
    centerTitle: true,
    backgroundColor: AppColors.grayColor,
  );
}
