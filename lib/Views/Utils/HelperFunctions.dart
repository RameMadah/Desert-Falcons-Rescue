import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

class Helper {
  static closeKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static showSnackbar(String text) {
    OneContext().showSnackBar(builder: (_) => SnackBar(content: Text(text)));
  }
}
