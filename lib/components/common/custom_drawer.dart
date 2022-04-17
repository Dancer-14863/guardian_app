import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guardian_app/themes/theme_options.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomDrawer extends StatelessWidget {
  final String currentRoute;
  const CustomDrawer({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeOptions = ThemeProvider.optionsOf<ThemeOptions>(context);
    final _beamer = Beamer.of(context);

    return Drawer(
      backgroundColor: _themeOptions.backgroundColor,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Text(
                'Pages',
                style: TextStyle(
                  color: _themeOptions.textColorOnPrimary,
                  fontSize: _themeOptions.textSize3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: _themeOptions.textColorOnPrimary,
                size: _themeOptions.textSize3,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  color: _themeOptions.textColorOnPrimary,
                  fontSize: _themeOptions.textSize5,
                ),
              ),
              selectedTileColor: _themeOptions.primaryColor,
              selected: currentRoute == '/home',
              onTap: () => _beamer.beamToNamed('/home'),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: _themeOptions.textColorOnPrimary,
                size: _themeOptions.textSize3,
              ),
              title: Text(
                'Configuration',
                style: TextStyle(
                  color: _themeOptions.textColorOnPrimary,
                  fontSize: _themeOptions.textSize5,
                ),
              ),
              selectedTileColor: _themeOptions.primaryColor,
              selected: currentRoute == '/configuration',
              onTap: () => _beamer.beamToNamed('/configuration'),
            ),
            ListTile(
              leading: Icon(
                Icons.analytics_outlined,
                color: _themeOptions.textColorOnPrimary,
                size: _themeOptions.textSize3,
              ),
              title: Text(
                'Analytics',
                style: TextStyle(
                  color: _themeOptions.textColorOnPrimary,
                  fontSize: _themeOptions.textSize5,
                ),
              ),
              selectedTileColor: _themeOptions.primaryColor,
              selected: currentRoute == '/analytics',
              onTap: () => _beamer.beamToNamed('/analytics'),
            ),
          ],
        ),
      ),
    );
  }
}
