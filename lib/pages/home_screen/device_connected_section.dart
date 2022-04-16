import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_app/pages/home_screen/home_screen.dart';
import 'package:guardian_app/services/guardian_service.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class DeviceConnectedSection extends ConsumerWidget {
  const DeviceConnectedSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final _isDeviceActive = ref.watch(isDeviceActive);
    final _guardianService = ref.watch(guardianService);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swap_vert,
              size: _themeOptions.textSize2,
              color: _themeOptions.successColor,
            ),
            SizedBox(width: 2.w),
            Text(
              'Device Connected',
              style: TextStyle(
                color: _themeOptions.textColorOnPrimary,
                fontSize: _themeOptions.textSize3,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        ToggleSwitch(
          minWidth: 20.w,
          cornerRadius: 12.sp,
          activeBgColors: [
            [_themeOptions.errorColor],
            [_themeOptions.successColor],
          ],
          activeFgColor: _themeOptions.textColorOnPrimary,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: _themeOptions.textColorOnPrimary,
          initialLabelIndex: _isDeviceActive ? 1 : 0,
          totalSwitches: 2,
          labels: const ['Inactive', 'Active'],
          radiusStyle: true,
          onToggle: (index) {
            switch (index) {
              case 0:
                _guardianService.deactivateDevice();
                break;
              case 1:
                _guardianService.activateDevice();
                break;
            }
          },
        ),
      ],
    );
  }
}
