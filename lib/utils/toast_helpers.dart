import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guardian_app/utils/constants/status.dart';
import 'package:sizer/sizer.dart';

void showToast({
  required String message,
  Toast length = Toast.LENGTH_SHORT,
  Status status = Status.success,
}) {
  final Color backgroundColor;

  switch (status) {
    case Status.success:
      backgroundColor = const Color(0xFF49CE78);
      break;
    case Status.warning:
      backgroundColor = const Color(0xFFE1B845);
      break;
    case Status.error:
      backgroundColor = const Color(0xFFDB5B53);
      break;
  }

  Fluttertoast.showToast(
    msg: message,
    toastLength: length,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    fontSize: 6.sp,
  );
}
