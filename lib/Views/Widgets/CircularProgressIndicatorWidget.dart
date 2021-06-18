import 'package:desert_falcon_rescue/Globals/Colors.dart';
import 'package:flutter/material.dart';

class CircularProgressIndicatorWidget extends StatelessWidget {
  Color? color = AppColors.greenColor;
  CircularProgressIndicatorWidget({this.color});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 4,
        valueColor:
            new AlwaysStoppedAnimation<Color>(color ?? AppColors.greenColor),
      ),
    );
  }
}
