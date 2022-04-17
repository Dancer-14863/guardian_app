import 'package:flutter/material.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class DeactivateAlarmButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DeactivateAlarmButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            vertical: 10.sp,
            horizontal: 5.w,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(
              color: _themeOptions.errorColor,
              width: 0.5.sp,
            ),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.alarm_off_outlined,
            color: _themeOptions.errorColor,
            size: _themeOptions.textSize3,
          ),
          SizedBox(width: 2.w),
          Text(
            'Turn Alarm Off',
            style: TextStyle(
              color: _themeOptions.errorColor,
              fontSize: _themeOptions.textSize5,
            ),
          ),
        ],
      ),
    );
  }
}
