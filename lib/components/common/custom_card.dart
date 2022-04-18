import 'package:flutter/material.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomCard extends StatelessWidget {
  final double? height;
  final double? width;
  final double? elevation;
  final double? borderRadius;
  final Color? color;
  final Color borderColor;
  final Widget? child;

  const CustomCard({
    Key? key,
    this.height,
    this.width,
    this.borderRadius,
    this.color,
    this.child,
    this.borderColor = Colors.transparent,
    this.elevation = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      color: color ?? _themeOptions.backgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(
          borderRadius ?? 4.sp,
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: child,
      ),
      elevation: elevation,
    );
  }
}
