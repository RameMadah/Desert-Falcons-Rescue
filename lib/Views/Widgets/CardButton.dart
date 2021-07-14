import 'package:flutter/material.dart';

Widget cardButton(String bgImage, String? logoImage, Color bgColor, Text text,
    double screenHeight, Function() onPress) {
  return InkWell(
    onTap: () {
      onPress();
    },
    child: Card(
      color: bgColor,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(bgImage,
                          height: screenHeight * 0.08,
                          width: screenHeight * 0.08)),
                  Align(
                    alignment: Alignment.center,
                    child: logoImage != null
                        ? Image.asset(logoImage,
                            height: screenHeight * 0.06,
                            width: screenHeight * 0.06)
                        : CircleAvatar(
                            child: Image.asset(
                                "assets/images/profile_image.png",
                                fit: BoxFit.contain)),
                  ),
                ],
              ),
            ),
            text
          ],
        ),
      ),
    ),
  );
}
