import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ScanButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            vertical: 10.sp,
            horizontal: 20.w,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(
              color: _themeOptions.primaryColor,
              width: 0.5.sp,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.visibility,
            color: _themeOptions.textColor,
            size: _themeOptions.textSize1,
          ),
          SizedBox(width: 2.w),
          Text(
            'Scan for devices',
            style: TextStyle(
              color: _themeOptions.textColor,
              fontSize: _themeOptions.textSize3,
            ),
          ),
        ],
      ),
    );
  }
}
