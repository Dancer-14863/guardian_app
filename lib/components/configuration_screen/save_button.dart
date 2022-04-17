import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            vertical: 10.sp,
            horizontal: 12.sp,
          ),
        ),
        backgroundColor: MaterialStateProperty.all(_themeOptions.primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(
              color: _themeOptions.primaryColor,
              width: 0.5.sp,
            ),
          ),
        ),
      ),
      child: Text(
        'Save',
        style: TextStyle(
          color: _themeOptions.textColor,
          fontSize: _themeOptions.textSize4,
        ),
      ),
    );
  }
}
