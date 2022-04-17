import 'package:beamer/beamer.dart';
import 'package:guardian_app/models/models.dart';
import 'package:guardian_app/pages/analytics_screen/analytics_screen.dart';
import 'package:guardian_app/pages/configuration_screen/configuration_screen.dart';
import 'package:guardian_app/pages/home_screen/home_screen.dart';
import 'package:guardian_app/pages/splash_screen/splash_screen.dart';

final appRouterDelegate = BeamerDelegate(
  initialPath: '/splash',
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/splash': (context, state, data) => const SplashScreen(),
      '/home': (context, state, data) => const HomeScreen(),
      '/configuration': (context, state, data) => const ConfigurationScreen(),
      '/analytics': (context, state, data) => const AnalyticsScreen(),
    },
  ),
);
