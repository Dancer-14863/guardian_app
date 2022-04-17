import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_app/components/common/custom_app_bar.dart';
import 'package:guardian_app/components/common/custom_drawer.dart';
import 'package:guardian_app/components/configuration_screen/save_button.dart';
import 'package:guardian_app/pages/home_screen/home_screen.dart';
import 'package:guardian_app/services/guardian_service.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:guardian_app/utils/constants/status.dart';
import 'package:guardian_app/utils/toast_helpers.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class ConfigurationScreen extends ConsumerStatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigurationScreenState();
}

class _ConfigurationScreenState extends ConsumerState<ConfigurationScreen> {
  late GuardianService _guardianService;
  bool _shouldWaterGunBeOn = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _guardianService = ref.watch(guardianService);
      setState(() {
        _shouldWaterGunBeOn = ref.watch(shouldWaterGunBeOn);
        _controller.text = ref.watch(distanceAlarmThreshold).toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return Scaffold(
      backgroundColor: _themeOptions.backgroundColor,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentRoute: '/configuration'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 6.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Configuration',
              style: TextStyle(
                color: _themeOptions.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: _themeOptions.textSize1,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activate water gun on alarm trigger',
                  style: TextStyle(
                    color: _themeOptions.textColor,
                    fontSize: _themeOptions.textSize4,
                  ),
                ),
                Checkbox(
                  checkColor: _themeOptions.successColor,
                  fillColor:
                      MaterialStateProperty.all(_themeOptions.primaryColor),
                  value: _shouldWaterGunBeOn,
                  onChanged: (value) {
                    setState(() {
                      _shouldWaterGunBeOn = !_shouldWaterGunBeOn;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Distance at which alarm is triggered (cm)',
              style: TextStyle(
                color: _themeOptions.textColor,
                fontSize: _themeOptions.textSize4,
              ),
            ),
            SizedBox(height: 0.5.h),
            TextFormField(
              controller: _controller,
              style: TextStyle(
                color: _themeOptions.textColor,
                fontSize: _themeOptions.textSize4,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _themeOptions.primaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _themeOptions.primaryColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SaveButton(
              onPressed: () async {
                await _guardianService.setWaterGunStatus(_shouldWaterGunBeOn);
                int distance = int.tryParse(_controller.value.text) ?? 0;
                await _guardianService.setDistanceAlarmThreshold(distance);
                showToast(
                  message: 'Configuration saved!',
                  status: Status.success,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
