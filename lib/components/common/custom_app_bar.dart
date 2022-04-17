import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guardian_app/components/common/intruder_warning.dart';
import 'package:guardian_app/services/guardian_service.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(8.h);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  static const String _logoAssetPath = 'assets/logo.svg';

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return AppBar(
      backgroundColor: _themeOptions.backgroundColor,
      toolbarHeight: 10.h,
      elevation: 0,
      title: SafeArea(
        child: Row(
          children: [
            SvgPicture.asset(
              _logoAssetPath,
              height: 4.h,
            ),
            SizedBox(width: 2.w),
            Text(
              'Guardian',
              style: TextStyle(
                color: _themeOptions.textColor,
                fontSize: _themeOptions.textSize2,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (ref.watch(isDeviceInAlarmState)) const IntruderWarning(),
          ],
        ),
      ),
    );
  }
}
