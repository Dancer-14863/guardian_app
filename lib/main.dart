import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:guardian_app/routes/app_router_delegate.dart';
import 'package:guardian_app/themes/default_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(const GuardianApp());
}

class GuardianApp extends StatelessWidget {
  const GuardianApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Sizer(
        builder: (context, orientation, deviceType) => ThemeProvider(
          themes: [
            DefaultTheme(),
            AppTheme.dark(),
          ],
          defaultThemeId: 'default_theme',
          saveThemesOnChange: true,
          loadThemeOnInit: true,
          child: ThemeConsumer(
            child: Builder(
              builder: (context) {
                return MaterialApp.router(
                  title: 'Guardian App',
                  theme: Theme.of(context),
                  routeInformationParser: BeamerParser(),
                  routerDelegate: appRouterDelegate,
                  backButtonDispatcher:
                      BeamerBackButtonDispatcher(delegate: appRouterDelegate),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
