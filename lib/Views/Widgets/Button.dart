import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  Function() onTap;
  String text;
  CustomButton(this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.greenColor),
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontSize: 45.sp,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
