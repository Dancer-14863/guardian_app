import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:guardian_app/utils/constants/status.dart';
import 'package:theme_provider/theme_provider.dart';

void showToast({
  required BuildContext context,
  required String message,
  Toast length = Toast.LENGTH_SHORT,
  Status status = Status.success,
}) {
  final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
  final Color backgroundColor;

  switch (status) {
    case Status.success:
      backgroundColor = _themeOptions.successColor;
      break;
    case Status.warning:
      backgroundColor = _themeOptions.warningColor;
      break;
    case Status.error:
      backgroundColor = _themeOptions.errorColor;
      break;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: length,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: backgroundColor,
    textColor: _themeOptions.textColorOnPrimary,
    fontSize: _themeOptions.textSize5,
  );
}
