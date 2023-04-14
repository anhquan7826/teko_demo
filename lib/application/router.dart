import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../presentation/splash/splash_screen.dart';

GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) {
        return const SplashScreen();
      }
    )
  ],
);
