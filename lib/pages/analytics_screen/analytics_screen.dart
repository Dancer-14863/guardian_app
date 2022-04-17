import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guardian_app/components/common/custom_app_bar.dart';
import 'package:guardian_app/components/common/custom_drawer.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);

    return Scaffold(
      backgroundColor: _themeOptions.backgroundColor,
      appBar: const CustomAppBar(),
      endDrawer: const CustomDrawer(currentRoute: '/analytics'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }
}
