import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_app/components/common/custom_app_bar.dart';
import 'package:guardian_app/components/common/custom_drawer.dart';
import 'package:guardian_app/components/home_screen/scan_button.dart';
import 'package:guardian_app/components/home_screen/device_connected_section.dart';
import 'package:guardian_app/services/guardian_service.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:guardian_app/utils/constants/status.dart';
import 'package:guardian_app/utils/toast_helpers.dart';
import 'package:theme_provider/theme_provider.dart';

final guardianService = Provider.autoDispose((ref) => GuardianService(ref));

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final _guardianService = ref.watch(guardianService);
    final _isDeviceConnected = ref.watch(isDeviceConnected);

    return Scaffold(
      backgroundColor: _themeOptions.backgroundColor,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentRoute: '/home'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: !_isDeviceConnected
                ? ScanButton(
                    onPressed: () async {
                      try {
                        await _guardianService.connectToDevice();
                      } catch (e) {
                        showToast(
                          message: e.toString(),
                          status: Status.error,
                        );
                      }
                    },
                  )
                : const DeviceConnectedSection(),
          ),
        ],
      ),
    );
  }
}
