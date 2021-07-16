import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  late double _screenHeight;

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Image.asset("assets/images/icon.png",
          height: _screenHeight * 0.30, width: _screenHeight * 0.30),
    );
  }
}
