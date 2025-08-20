import 'package:flutter/material.dart';

class ChangeTheme {
  static bool darkModeCheck(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void changeTheme(BuildContext context) {
    if (darkModeCheck(context)) {
      Theme.of(context).brightness == Brightness.light;
    } else {
      Theme.of(context).brightness == Brightness.dark;
    }
  }
}
