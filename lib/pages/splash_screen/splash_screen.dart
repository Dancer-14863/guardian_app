import 'dart:async';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_app/pages/home_screen/home_screen.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  static const String _logoAssetPath = 'assets/logo.svg';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final beamer = Beamer.of(context);
      await _addDefaultConfigurationIfNotExists();
      Timer(const Duration(milliseconds: 1000), () {
        beamer.beamToNamed('/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return Scaffold(
      backgroundColor: _themeOptions.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              _logoAssetPath,
              height: 15.h,
              width: 20.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'Guardian',
              style: TextStyle(
                color: _themeOptions.textColor,
                fontSize: _themeOptions.textSize1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addDefaultConfigurationIfNotExists() async {
    await ref.watch(guardianService).initConfiguration();
  }
}
