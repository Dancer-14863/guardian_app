import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guardian_app/components/common/custom_card.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  const AnalyticsCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return CustomCard(
      height: 10.h,
      color: _themeOptions.primaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                color: _themeOptions.textColor,
                fontSize: _themeOptions.textSize4,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: _themeOptions.textColor,
                fontWeight: FontWeight.bold,
                fontSize: _themeOptions.textSize1,
                letterSpacing: 2.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
