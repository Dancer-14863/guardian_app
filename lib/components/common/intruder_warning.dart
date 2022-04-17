import 'package:flutter/material.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class IntruderWarning extends StatelessWidget {
  const IntruderWarning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return Container(
      margin: EdgeInsets.only(left: 5.w),
      padding: EdgeInsets.symmetric(
        horizontal: 10.sp,
        vertical: 4.sp,
      ),
      color: _themeOptions.errorColor,
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: _themeOptions.textSize2,
            color: _themeOptions.textColorOnPrimary,
          ),
          SizedBox(width: 2.w),
          Text(
            'Intruder Detected! ',
            style: TextStyle(
              fontSize: _themeOptions.textSize5,
              color: _themeOptions.textColorOnPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
